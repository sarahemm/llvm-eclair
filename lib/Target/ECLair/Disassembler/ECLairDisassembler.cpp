//===-- ECLairDisassembler.cpp - Disassembler for ECLair --------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the ECLair Disassembler class.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/ECLairMCTargetDesc.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCFixedLenDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "eclair-disassembler"

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {
class ECLairDisassembler : public MCDisassembler {

public:
  ECLairDisassembler(const MCSubtargetInfo &STI, MCContext &Ctx)
      : MCDisassembler(STI, Ctx) {}

  DecodeStatus getInstruction(MCInst &Instr, uint64_t &Size,
                              ArrayRef<uint8_t> Bytes, uint64_t Address,
                              raw_ostream &VStream,
                              raw_ostream &CStream) const override;
};
} // end anonymous namespace

static MCDisassembler *createECLairDisassembler(const Target &T,
                                                const MCSubtargetInfo &STI,
                                                MCContext &Ctx) {
  return new ECLairDisassembler(STI, Ctx);
}

extern "C" void LLVMInitializeECLairDisassembler() {
  // Register the disassembler for each target.
  TargetRegistry::RegisterMCDisassembler(getTheECLairTarget(),
                                         createECLairDisassembler);
}

static const unsigned FullWidthDecoderTable[] = {
  ECLair::A,  ECLair::B,
  ECLair::C,  ECLair::D,
};

static const unsigned HalfWidthLowDecoderTable[] = {
  ECLair::AL,  ECLair::BL,
  ECLair::CL,  ECLair::DL,
};

static const unsigned HalfWidthHighDecoderTable[] = {
  ECLair::AH,  ECLair::BH,
  ECLair::CH,  ECLair::DH,
};

static DecodeStatus DecodeFullWidthRegisterClass(MCInst &Inst, uint64_t RegNo,
                                                    uint64_t Address,
                                                    const void *Decoder) {
   if (RegNo > sizeof(FullWidthDecoderTable))
     return MCDisassembler::Fail;

   unsigned Reg = FullWidthDecoderTable[RegNo];
   Inst.addOperand(MCOperand::createReg(Reg));
   return MCDisassembler::Success;
}

static DecodeStatus DecodeHalfWidthLowRegisterClass(MCInst &Inst, uint64_t RegNo,
                                                    uint64_t Address,
                                                    const void *Decoder) {
   if (RegNo > sizeof(HalfWidthLowDecoderTable))
     return MCDisassembler::Fail;

   unsigned Reg = HalfWidthLowDecoderTable[RegNo];
   Inst.addOperand(MCOperand::createReg(Reg));
   return MCDisassembler::Success;
}

static DecodeStatus DecodeHalfWidthHighRegisterClass(MCInst &Inst, uint64_t RegNo,
                                                    uint64_t Address,
                                                    const void *Decoder) {
   if (RegNo > sizeof(HalfWidthHighDecoderTable))
     return MCDisassembler::Fail;

   unsigned Reg = HalfWidthHighDecoderTable[RegNo];
   Inst.addOperand(MCOperand::createReg(Reg));
   return MCDisassembler::Success;
}

template <unsigned N>
static DecodeStatus decodeUImmOperand(MCInst &Inst, uint64_t Imm,
                                      int64_t Address, const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid immediate");
  Inst.addOperand(MCOperand::createImm(Imm));
  return MCDisassembler::Success;
}

template <unsigned N>
static DecodeStatus decodeSImmOperand(MCInst &Inst, uint64_t Imm,
                                      int64_t Address, const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid immediate");
  // Sign-extend the number in the bottom N bits of Imm
  Inst.addOperand(MCOperand::createImm(SignExtend64<N>(Imm)));
  return MCDisassembler::Success;
}

template <unsigned N>
static DecodeStatus decodeSImmOperandAndLsl1(MCInst &Inst, uint64_t Imm,
                                             int64_t Address,
                                             const void *Decoder) {
  assert(isUInt<N>(Imm) && "Invalid immediate");
  // Sign-extend the number in the bottom N bits of Imm after accounting for
  // the fact that the N bit immediate is stored in N-1 bits (the LSB is
  // always zero)
  Inst.addOperand(MCOperand::createImm(SignExtend64<N>(Imm << 1)));
  return MCDisassembler::Success;
}

#include "ECLairGenDisassemblerTables.inc"

DecodeStatus ECLairDisassembler::getInstruction(MCInst &MI, uint64_t &Size,
                                                ArrayRef<uint8_t> Bytes,
                                                uint64_t Address,
                                                raw_ostream &OS,
                                                raw_ostream &CS) const {

  // Get the bytes of the instruction.
  DecodeStatus status;

  // try to decode the instruction as 24 bits wide first
  uint8_t  opcode = support::endian::read<uint8_t, support::endianness::big>(Bytes.data());
  uint16_t arg = support::endian::read16be(Bytes.data()+1);
  uint32_t bigInst = opcode << 16 | arg;
  //printf("opcode: %x arg: %x bigInst: %x", opcode, arg, bigInst);
  status = decodeInstruction(DecoderTable24, MI, bigInst, Address, this, STI);
  if(status == Success) {
    // 24 bit wide instruction decode succeeded
    Size = 3;
    return Success;
  }

  // 24 bit wide instruction decode failed, try 16 bit wide
  uint16_t shortInst = support::endian::read16be(Bytes.data());
  status = decodeInstruction(DecoderTable16, MI, shortInst, Address, this, STI);
  if(status == Success) {
    // 16 bit wide instruction decode succeeded
    Size = 2;
    return Success;
  }
  
  // 16 bit wide instruction decode failed, try 8 bit wide
  uint8_t byteInst = support::endian::read<uint8_t, support::endianness::big>(Bytes.data());
  status = decodeInstruction(DecoderTable8, MI, byteInst, Address, this, STI);
  if(status == Success) {
    // 8 bit wide instruction decode succeeded
    Size = 1;
    return Success;
  }

  // no width of decode worked, give up
  Size = 0;
  return status;
}