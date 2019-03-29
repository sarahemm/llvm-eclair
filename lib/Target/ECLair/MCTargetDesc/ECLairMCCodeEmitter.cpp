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

public:
  ECLairMCCodeEmitter(MCContext &ctx) : Ctx(ctx) {}

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
};
} // end anonymous namespace

MCCodeEmitter *llvm::createECLairMCCodeEmitter(const MCInstrInfo &MCII,
                                              const MCRegisterInfo &MRI,
                                              MCContext &Ctx) {
  return new ECLairMCCodeEmitter(Ctx);
}

void ECLairMCCodeEmitter::encodeInstruction(const MCInst &MI, raw_ostream &OS,
                                           SmallVectorImpl<MCFixup> &Fixups,
                                           const MCSubtargetInfo &STI) const {
  // FIXME: this might not work with 8/16-bit instructions (which are all of them)
  uint16_t Bits = getBinaryCodeForInstr(MI, Fixups, STI);
  support::endian::write(OS, Bits, support::big);
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

#include "ECLairGenMCCodeEmitter.inc"