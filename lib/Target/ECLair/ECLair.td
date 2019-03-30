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

//===----------------------------------------------------------------------===//
// ECLair processors supported.
//===----------------------------------------------------------------------===//

def ECLairInstrInfo : InstrInfo;

def ECLairAsmParser : AsmParser {
  let ShouldEmitMatchRegisterAltName = 1;
}

def : ProcessorModel<"generic-eclair", NoSchedModel, []>;

//===----------------------------------------------------------------------===//
// Define the ECLair target.
//===----------------------------------------------------------------------===//

def ECLair : Target {
  let InstructionSet = ECLairInstrInfo;
  let AssemblyParsers = [ECLairAsmParser];
}