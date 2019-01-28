//===-- ECLair.td - Describe the ECLair Target Machine -------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// ECLair subtarget features and instruction predicates.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Register file, instruction descriptions.
//===----------------------------------------------------------------------===//

include "ECLairRegisterInfo.td"
include "ECLairInstrInfo.td"

def ECLairInstrInfo : InstrInfo;

//===----------------------------------------------------------------------===//
// ECLair processors supported.
//===----------------------------------------------------------------------===//

def : ProcessorModel<"generic-eclair", NoSchedModel, []>;

//===----------------------------------------------------------------------===//
// Define the RISC-V target.
//===----------------------------------------------------------------------===//

def ECLair : Target {
  let InstructionSet = ECLairInstrInfo;
}