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

class UImmAsmOperand<int width>
    : AsmOperandClass {
  let Name = "UImm" # width;
  let RenderMethod = "addImmOperands";
  let DiagnosticType = !strconcat("Invalid", Name);
}

def simm8 : Operand<i8> {
  let ParserMatchClass = SImmAsmOperand<8>;
}

def uimm8 : Operand<i8> {
  let ParserMatchClass = UImmAsmOperand<8>;
}

def simm16 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<16>;
}

def uimm16 : Operand<i16> {
  let ParserMatchClass = UImmAsmOperand<16>;
}

//===----------------------------------------------------------------------===//
// Instruction Class Templates
//===----------------------------------------------------------------------===//

let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in
class Basic<ECLairOpcode opcode, string opcodestr>
    : ECLairInstNoReg<opcode, (outs), (ins), opcodestr, "">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RegReg<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs FullWidth:$rd), (ins FullWidth:$src, FullWidth:$rs2),
                opcodestr, "$rd, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullReg<ECLairOpcode opcode, string opcodestr>
    : ECLairInstOneReg<opcode, (outs FullWidth:$rd), (ins FullWidth:$src), opcodestr, "$rd">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLow<ECLairOpcode opcode, string opcodestr>
    : ECLairInstOneReg<opcode, (outs HalfWidthLow:$rd), (ins HalfWidthLow:$src), opcodestr, "$rd">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHigh<ECLairOpcode opcode, string opcodestr>
    : ECLairInstOneReg<opcode, (outs HalfWidthHigh:$rd), (ins HalfWidthHigh:$src), opcodestr, "$rd">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class UImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstImmWord<opcode, (outs), (ins FullWidth:$rd, uimm16:$imm),
                              opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLowImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmByte<opcode, (outs HalfWidthLow:$rd), (ins HalfWidthLow:$src, uimm8:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHighImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmByte<opcode, (outs HalfWidthHigh:$rd), (ins HalfWidthHigh:$src, uimm8:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullRegImmByte<ECLairOpcode opcode, string opcodestr>
      : ECLairInstRegImmByte<opcode, (outs FullWidth:$rd), (ins FullWidth:$src, uimm8:$imm), opcodestr, "$rd, $imm">;

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

def HALT : Basic<OPC_HALT, "halt"> {}
def CIR : Basic<OPC_CIR, "cir"> {}

def ADD16 : RegReg<OPC_ADD16, "add16"> {}
def SHL16 : FullRegImmByte<OPC_SHL16, "shl16"> {}
def SHR16 : FullRegImmByte<OPC_SHR16, "shr16"> {}
def LDI16 : UImmWord<OPC_LDI16, "ldi16"> {}

def INV16 : FullReg<OPC_INV16, "inv"> {}
def INV8L : HalfRegLow<OPC_INV8L, "inv"> {}
def INV8H : HalfRegHigh<OPC_INV8H, "inv"> {}

def LDI8L : HalfRegLowImmByte<OPC_LDI8L, "ldi8l"> {}
def LDI8H : HalfRegHighImmByte<OPC_LDI8H, "ldi8h"> {}

def JMPE : UImmWord<OPC_JMPE, "jmpe"> {}
def JMPNE : UImmWord<OPC_JMPNE, "jmpe"> {}