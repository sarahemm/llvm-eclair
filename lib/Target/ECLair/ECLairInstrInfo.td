//===-- ECLairInstrInfo.td - Target Description for ECLair ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the ECLair instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

include "ECLairInstrFormats.td"

//===----------------------------------------------------------------------===//
// Operand and SDNode transformation definitions.
//===----------------------------------------------------------------------===//

class SImmAsmOperand<int width>
    : AsmOperandClass {
  let Name = "SImm" # width;
  let RenderMethod = "addImmOperands";
  let DiagnosticType = !strconcat("Invalid", Name);
}

def simm8 : Operand<i8> {
  let ParserMatchClass = SImmAsmOperand<8>;
}

def simm16 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<16>;
}

//===----------------------------------------------------------------------===//
// Instruction Class Templates
//===----------------------------------------------------------------------===//

let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in
class Basic<ECLairOpcode opcode, string opcodestr>
    : ECLairInstNoReg<opcode, (outs), (ins), opcodestr, "">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RegReg<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs FullWidth:$rd), (ins FullWidth:$rs1, FullWidth:$rs2),
                opcodestr, "$rd, $rs1, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class ImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstImmWord<opcode, (outs), (ins simm16:$imm16),
                              opcodestr, "$imm16">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RegImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmByte<opcode, (outs), (ins HalfWidth:$rs1, simm8:$imm8),
                                            opcodestr, "$rs1, $imm8">;

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

def HALT : Basic<OPC_HALT, "halt"> {}

def ADD16 : RegReg<OPC_ADD16, "add16"> {}

def LDI8L : RegImmByte<OPC_LDI8L, "ldi8l"> {}

def JMPE : ImmWord<OPC_JMPE, "jmpe"> {}
def JMPNE : ImmWord<OPC_JMPNE, "jmpe"> {}