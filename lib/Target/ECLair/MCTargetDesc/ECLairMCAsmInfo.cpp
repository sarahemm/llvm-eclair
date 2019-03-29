//===-- ECLairMCAsmInfo.cpp - ECLair Asm properties -------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations of the ECLairMCAsmInfo properties.
//
//===----------------------------------------------------------------------===//

#include "ECLairMCAsmInfo.h"
#include "llvm/ADT/Triple.h"
using namespace llvm;

void ECLairMCAsmInfo::anchor() {}

ECLairMCAsmInfo::ECLairMCAsmInfo(const Triple &TT) {
  // TODO: revisit this
  CodePointerSize = CalleeSaveStackSlotSize = 4;
  CommentString = "#";
  // TODO: revisit this too
  AlignmentIsInBytes = false;
  SupportsDebugInformation = true;
}