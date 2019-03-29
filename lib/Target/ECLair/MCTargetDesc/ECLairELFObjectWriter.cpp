//===-- ECLairELFObjectWriter.cpp - ECLair ELF Writer -----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/ECLairMCTargetDesc.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

namespace {
class ECLairELFObjectWriter : public MCELFObjectTargetWriter {
public:
  ECLairELFObjectWriter(uint8_t OSABI);

  ~ECLairELFObjectWriter() override;

protected:
  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;
};
}

ECLairELFObjectWriter::ECLairELFObjectWriter(uint8_t OSABI)
    : MCELFObjectTargetWriter(false, OSABI, ELF::EM_ECLAIR,
                              /*HasRelocationAddend*/ true) {}

ECLairELFObjectWriter::~ECLairELFObjectWriter() {}

unsigned ECLairELFObjectWriter::getRelocType(MCContext &Ctx,
                                            const MCValue &Target,
                                            const MCFixup &Fixup,
                                            bool IsPCRel) const {
  report_fatal_error("invalid fixup kind!");
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createECLairELFObjectWriter(uint8_t OSABI) {
  return llvm::make_unique<ECLairELFObjectWriter>(OSABI);
}