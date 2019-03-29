//===-- ECLairAsmBackend.cpp - ECLair Assembler Backend ---------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/ECLairMCTargetDesc.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCDirectives.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {
class ECLairAsmBackend : public MCAsmBackend {
  uint8_t OSABI;

public:
  ECLairAsmBackend(uint8_t OSABI) : MCAsmBackend(support::big), OSABI(OSABI) {}
  ~ECLairAsmBackend() override {}

  void applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                  const MCValue &Target, MutableArrayRef<char> Data,
                  uint64_t Value, bool IsResolved, const MCSubtargetInfo *STI) const override;

  std::unique_ptr<MCObjectTargetWriter>
  createObjectTargetWriter() const override;

  bool fixupNeedsRelaxation(const MCFixup &Fixup, uint64_t Value,
                            const MCRelaxableFragment *DF,
                            const MCAsmLayout &Layout) const override {
    return false;
  }

  unsigned getNumFixupKinds() const override { return 1; }

  bool mayNeedRelaxation(const MCInst &Inst, const MCSubtargetInfo &STI) const override {
    return false;
  }

  void relaxInstruction(const MCInst &Inst, const MCSubtargetInfo &STI,
                        MCInst &Res) const override {

    report_fatal_error("ECLairAsmBackend::relaxInstruction() unimplemented");
  }

  bool writeNopData(raw_ostream &OS, uint64_t Count) const override;
};

bool ECLairAsmBackend::writeNopData(raw_ostream &OS, uint64_t Count) const {
  // TODO: We can probably eliminate this since we don't need to word-align anything
  if ((Count % 4) != 0)
    return false;
  
  // The canonical nop on ECLair is fetch2
  for (uint64_t i = 0; i < Count; i += 4)
    OS.write(224);

  return true;
}

void ECLairAsmBackend::applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                                 const MCValue &Target,
                                 MutableArrayRef<char> Data, uint64_t Value,
                                 bool IsResolved, const MCSubtargetInfo *STI) const {
  return;
}

std::unique_ptr<MCObjectTargetWriter>
ECLairAsmBackend::createObjectTargetWriter() const {
  return createECLairELFObjectWriter(OSABI);
}

} // end anonymous namespace

MCAsmBackend *llvm::createECLairAsmBackend(const Target &T,
                                          const MCSubtargetInfo &STI,
                                          const MCRegisterInfo &MRI,
                                          const MCTargetOptions &Options) {
  const Triple &TT = STI.getTargetTriple();
  uint8_t OSABI = MCELFObjectTargetWriter::getOSABI(TT.getOS());
  return new ECLairAsmBackend(OSABI);
}