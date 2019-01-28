//===-- ECLairTargetInfo.cpp - ECLair Target Implementation -----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

namespace llvm {

Target &getTheECLairTarget() {
  static Target TheECLairTarget;
  return TheECLairTarget;
}

}

extern "C" void LLVMInitializeECLairTargetInfo() {
  RegisterTarget<Triple::eclair> X(getTheECLairTarget(), "eclair",
                                    "ECLair", "ECLair");
}

// FIXME: Temporary stub - this function must be defined for linking
// to succeed and will be called unconditionally by llc, so must be a no-op.
// Remove once this function is properly implemented.
extern "C" void LLVMInitializeECLairTargetMC() {}