//===-- ECLairTargetMachine.cpp - Define TargetMachine for ECLair -----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Implements the info about ECLair target spec.
//
//===----------------------------------------------------------------------===//

#include "ECLairTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"
using namespace llvm;

extern "C" void LLVMInitializeECLairTarget() {
  RegisterTargetMachine<ECLairTargetMachine> X(getTheECLairTarget());
}

static std::string computeDataLayout(const Triple &TT) {
  std::string Ret = "";
  
  // Big endian
  Ret += "E";

  // ELF-style mangling
  Ret += "-m:e";

  // Pointers are 16-bits, no alignment required (which aligning to bytes accomplishes)
  Ret += "-p:16:8";

  // 8 and 16 bit integers need no special alignment either
  Ret += "-i8:8:8-i16:8:8";

  // Native integer types are 8 and 16 bits
  Ret += "-n8:16";
  
  // No stack alignment required
  Ret += "-S8";

  return Ret;
}

static Reloc::Model getEffectiveRelocModel(const Triple &TT,
                                           Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    return Reloc::Static;
  
  return *RM;
}

ECLairTargetMachine::ECLairTargetMachine(const Target &T, const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       Optional<Reloc::Model> RM,
                                       Optional<CodeModel::Model> CM,
                                       CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(TT), TT, CPU, FS, Options,
                        getEffectiveRelocModel(TT, RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(make_unique<TargetLoweringObjectFileELF>()) {
  initAsmInfo();
}

TargetPassConfig *ECLairTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new TargetPassConfig(*this, PM);
}