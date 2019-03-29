//===-- ECLairMCAsmInfo.h - ECLair Asm Info ----------------------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the ECLairMCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_ECLAIR_MCTARGETDESC_ECLAIRMCASMINFO_H
#define LLVM_LIB_TARGET_ECLAIR_MCTARGETDESC_ECLAIRMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class ECLairMCAsmInfo : public MCAsmInfoELF {
  void anchor() override;

public:
  explicit ECLairMCAsmInfo(const Triple &TargetTriple);
};

} // namespace llvm

#endif