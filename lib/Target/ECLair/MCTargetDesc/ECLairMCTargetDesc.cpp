//===-- ECLairMCTargetDesc.cpp - ECLair Target Descriptions -----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// This file provides ECLair-specific target descriptions.
///
//===----------------------------------------------------------------------===//

#include "ECLairMCTargetDesc.h"
#include "InstPrinter/ECLairInstPrinter.h"
#include "ECLairMCAsmInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_MC_DESC
#include "ECLairGenInstrInfo.inc"

#define GET_REGINFO_MC_DESC
#include "ECLairGenRegisterInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "ECLairGenSubtargetInfo.inc"

using namespace llvm;

static MCInstrInfo *createECLairMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitECLairMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createECLairMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  // TODO: revisit what A is for
  InitECLairMCRegisterInfo(X, ECLair::A);
  return X;
}

static MCAsmInfo *createECLairMCAsmInfo(const MCRegisterInfo &MRI,
                                       const Triple &TT) {
  return new ECLairMCAsmInfo(TT);
}

static MCSubtargetInfo *createECLairMCSubtargetInfo(const Triple &TT,
                                                   StringRef CPU, StringRef FS) {
  std::string CPUName = CPU;
  if (CPUName.empty())
    CPUName = "generic-eclair";
  return createECLairMCSubtargetInfoImpl(TT, CPUName, FS);
}

static MCInstPrinter *createECLairMCInstPrinter(const Triple &T,
                                               unsigned SyntaxVariant,
                                               const MCAsmInfo &MAI,
                                               const MCInstrInfo &MII,
                                               const MCRegisterInfo &MRI) {
  return new ECLairInstPrinter(MAI, MII, MRI);
}


extern "C" void LLVMInitializeECLairTargetMC() {
  for (Target *T : {&getTheECLairTarget()}) {
    TargetRegistry::RegisterMCAsmInfo(*T, createECLairMCAsmInfo);
    TargetRegistry::RegisterMCInstrInfo(*T, createECLairMCInstrInfo);
    TargetRegistry::RegisterMCRegInfo(*T, createECLairMCRegisterInfo);
    TargetRegistry::RegisterMCAsmBackend(*T, createECLairAsmBackend);
    TargetRegistry::RegisterMCCodeEmitter(*T, createECLairMCCodeEmitter);
    TargetRegistry::RegisterMCSubtargetInfo(*T, createECLairMCSubtargetInfo);
    TargetRegistry::RegisterMCInstPrinter(*T, createECLairMCInstPrinter);
  }
}