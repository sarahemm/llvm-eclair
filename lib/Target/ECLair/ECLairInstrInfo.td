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
class FullRegFullReg<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs FullWidth:$rd), (ins FullWidth:$src, FullWidth:$rs2),
                opcodestr, "$rd, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLowHalfRegLow<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs HalfWidthLow:$rd), (ins HalfWidthLow:$src, HalfWidthLow:$rs2), opcodestr, "$rd, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHighHalfRegHigh<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs HalfWidthHigh:$rd), (ins HalfWidthHigh:$src, HalfWidthHigh:$rs2), opcodestr, "$rd, $rs2">;

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
class ImmWord<ECLairOpcode opcode, string opcodestr>
      : ECLairInstImmWord<opcode, (outs), (ins uimm16:$imm), opcodestr, "$imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullRegImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmWord<opcode, (outs FullWidth:$rd), (ins FullWidth:$src, uimm16:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class SPRegImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstFixedRegImmWord<opcode, (outs FullWidthSP:$rd), (ins FullWidthSP:$src, uimm16:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class DPRegImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstFixedRegImmWord<opcode, (outs FullWidthDP:$rd), (ins FullWidthDP:$src, uimm16:$imm), opcodestr, "$rd, $imm">;

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

def HALT  : Basic<OPC_HALT, "halt"> {}
def CIR   : Basic<OPC_CIR,  "cir"> {}
def EI    : Basic<OPC_EI,   "ei"> {}
def DI    : Basic<OPC_DI,   "di"> {}
 
def ADD16 : FullRegFullReg<OPC_ADD16, "add"> {}
def ADD8L : HalfRegLowHalfRegLow<OPC_ADD8L, "add"> {}
def ADD8H : HalfRegHighHalfRegHigh<OPC_ADD8H, "add"> {}

def SHL16 : FullRegImmByte<OPC_SHL16, "shl"> {}
def SHL8L : HalfRegLowImmByte<OPC_SHL8L, "shl"> {}
def SHL8H : HalfRegHighImmByte<OPC_SHL8H, "shl"> {}

def SHR16 : FullRegImmByte<OPC_SHR16, "shr"> {}
def SHR8L : HalfRegLowImmByte<OPC_SHR8L, "shr"> {}
def SHR8H : HalfRegHighImmByte<OPC_SHR8H, "shr"> {}

def INV16 : FullReg<OPC_INV16, "inv"> {}
def INV8L : HalfRegLow<OPC_INV8L, "inv"> {}
def INV8H : HalfRegHigh<OPC_INV8H, "inv"> {}

def SWAB  : FullReg<OPC_SWAB, "swab"> {}
def SEX   : FullReg<OPC_SEX,  "sex"> {}

def LDI16 : FullRegImmWord<OPC_LDI16, "ldi"> {}
def LDI16SP : SPRegImmWord<OPC_LDI16SP, "ldi"> {}
def LDI16DP : DPRegImmWord<OPC_LDI16DP, "ldi"> {}
def LDI8L : HalfRegLowImmByte<OPC_LDI8L, "ldi"> {}
def LDI8H : HalfRegHighImmByte<OPC_LDI8H, "ldi"> {}

def JMPE : ImmWord<OPC_JMPE, "jmpe"> {}
def JMPNE : ImmWord<OPC_JMPNE, "jmpne"> {}