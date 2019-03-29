//===-- ECLairMCTargetDesc.h - ECLair Target Descriptions ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides ECLair specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_ECLAIR_MCTARGETDESC_ECLAIRMCTARGETDESC_H
#define LLVM_LIB_TARGET_ECLAIR_MCTARGETDESC_ECLAIRMCTARGETDESC_H

#include "llvm/Config/config.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/DataTypes.h"
#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class StringRef;
class Target;
class Triple;
class raw_ostream;
class raw_pwrite_stream;

Target &getTheECLairTarget();

MCCodeEmitter *createECLairMCCodeEmitter(const MCInstrInfo &MCII,
                                        const MCRegisterInfo &MRI,
                                        MCContext &Ctx);

MCAsmBackend *createECLairAsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                    const MCRegisterInfo &MRI,
                                    const MCTargetOptions &Options);

std::unique_ptr<MCObjectTargetWriter>
createECLairELFObjectWriter(uint8_t OSABI);
}

// Defines symbolic names for ECLair registers.
#define GET_REGINFO_ENUM
#include "ECLairGenRegisterInfo.inc"

// Defines symbolic names for ECLair instructions.
#define GET_INSTRINFO_ENUM
#include "ECLairGenInstrInfo.inc"

#endif