//===-- ECLairMCCodeEmitter.cpp - Convert ECLair code to machine code -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the ECLairMCCodeEmitter class.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/ECLairMCTargetDesc.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstBuilder.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "mccodeemitter"

// FIXME: this won't compile but we should make it work
//STATISTIC(MCNumEmitted, "Number of MC instructions emitted");

namespace {
class ECLairMCCodeEmitter : public MCCodeEmitter {
  ECLairMCCodeEmitter(const ECLairMCCodeEmitter &) = delete;
  void operator=(const ECLairMCCodeEmitter &) = delete;
  MCContext &Ctx;
  MCInstrInfo const &MCII;

public:
  ECLairMCCodeEmitter(MCContext &ctx, MCInstrInfo const &MCII) : Ctx(ctx), MCII(MCII) {}

  ~ECLairMCCodeEmitter() override {}

  void encodeInstruction(const MCInst &MI, raw_ostream &OS,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const override;

  /// TableGen'erated function for getting the binary encoding for an
  /// instruction.
  uint64_t getBinaryCodeForInstr(const MCInst &MI,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &STI) const;

  /// Return binary encoding of operand. If the machine operand requires
  /// relocation, record the relocation and return zero.
  unsigned getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &STI) const;
  unsigned getImmOpValue(const MCInst &MI, unsigned OpNo,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const;
};
} // end anonymous namespace

MCCodeEmitter *llvm::createECLairMCCodeEmitter(const MCInstrInfo &MCII,
                                              const MCRegisterInfo &MRI,
                                              MCContext &Ctx) {
  return new ECLairMCCodeEmitter(Ctx, MCII);
}

void ECLairMCCodeEmitter::encodeInstruction(const MCInst &MI, raw_ostream &OS,
                                           SmallVectorImpl<MCFixup> &Fixups,
                                           const MCSubtargetInfo &STI) const {
  const MCInstrDesc &Desc = MCII.get(MI.getOpcode());
  unsigned Size = Desc.getSize();
  switch(Size) {
    default:
      llvm_unreachable("Unhandled encodeInstruction length!");
    case 1: {
      uint8_t ByteBits = getBinaryCodeForInstr(MI, Fixups, STI);
      support::endian::write(OS, ByteBits, support::big);
      break;
    }
    case 2: {
      uint16_t WordBits = getBinaryCodeForInstr(MI, Fixups, STI);
      support::endian::write(OS, WordBits, support::big);
      break;
    }
    case 3: {
      uint32_t ByteWordBits = getBinaryCodeForInstr(MI, Fixups, STI);
      uint8_t OpcodeBits = (ByteWordBits >> 16) & 0xFF;
      uint16_t ArgBits = ByteWordBits & 0xFFFF;
      support::endian::write(OS, OpcodeBits, support::big);
      support::endian::write(OS, ArgBits, support::big);
      break;
    }
  }
  // FIXME: this won't compile but we should make it work
  //++MCNumEmitted; // Keep track of the # of mi's emitted.
}

unsigned
ECLairMCCodeEmitter::getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                                      SmallVectorImpl<MCFixup> &Fixups,
                                      const MCSubtargetInfo &STI) const {

  if (MO.isReg())
    return Ctx.getRegisterInfo()->getEncodingValue(MO.getReg());

  if (MO.isImm())
    return static_cast<unsigned>(MO.getImm());

  llvm_unreachable("Unhandled expression!");
  return 0;
}


unsigned ECLairMCCodeEmitter::getImmOpValue(const MCInst &MI, unsigned OpNo,
                                            SmallVectorImpl<MCFixup> &Fixups,
                                            const MCSubtargetInfo &STI) const {

  const MCOperand &MO = MI.getOperand(OpNo);

  // If the destination is an immediate, there is nothing to do
  if (MO.isImm())
    return MO.getImm();

  llvm_unreachable("Unhandled expression!");

  return 0;
}

#include "ECLairGenMCCodeEmitter.inc"