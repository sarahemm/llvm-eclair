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
  let DecoderMethod = "decodeSImmOperand<8>";
}

def uimm8 : Operand<i8> {
  let ParserMatchClass = UImmAsmOperand<8>;
  let DecoderMethod = "decodeUImmOperand<8>";
}

def simm16 : Operand<i16> {
  let ParserMatchClass = SImmAsmOperand<16>;
  let DecoderMethod = "decodeSImmOperand<16>";
}

def uimm16 : Operand<i16> {
  let ParserMatchClass = UImmAsmOperand<16>;
  let DecoderMethod = "decodeUImmOperand<16>";
}

//===----------------------------------------------------------------------===//
// Instruction Class Templates
//===----------------------------------------------------------------------===//

let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in
class Basic<ECLairOpcode opcode, string opcodestr>
    : ECLairInstNoReg<opcode, (outs), (ins), opcodestr, "">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullRegFullReg<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs), (ins FullWidth:$rd, FullWidth:$rs2),
                opcodestr, "$rd, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLowHalfRegLow<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs), (ins HalfWidthLow:$rd, HalfWidthLow:$rs2), opcodestr, "$rd, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHighHalfRegHigh<ECLairOpcode opcode, string opcodestr>
    : ECLairInstTwoReg<opcode, (outs), (ins HalfWidthHigh:$rd, HalfWidthHigh:$rs2), opcodestr, "$rd, $rs2">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullReg<ECLairOpcode opcode, string opcodestr>
    : ECLairInstOneReg<opcode, (outs), (ins FullWidth:$rd), opcodestr, "$rd">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLow<ECLairOpcode opcode, string opcodestr>
    : ECLairInstOneReg<opcode, (outs), (ins HalfWidthLow:$rd), opcodestr, "$rd">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHigh<ECLairOpcode opcode, string opcodestr>
    : ECLairInstOneReg<opcode, (outs), (ins HalfWidthHigh:$rd), opcodestr, "$rd">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class ImmByte<ECLairOpcode opcode, string opcodestr>
      : ECLairInstImmByte<opcode, (outs), (ins uimm8:$imm), opcodestr, "$imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class ImmWord<ECLairOpcode opcode, string opcodestr>
      : ECLairInstImmWord<opcode, (outs), (ins uimm16:$imm), opcodestr, "$imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class SImmWord<ECLairOpcode opcode, string opcodestr>
      : ECLairInstImmWord<opcode, (outs), (ins simm16:$imm), opcodestr, "$imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullRegImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmWord<opcode, (outs), (ins FullWidth:$rd, uimm16:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [SP] in
class SPRegImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstFixedRegImmWord<opcode, (outs), (ins uimm16:$imm), opcodestr, "sp, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [FLAGS] in
class FlagsImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstFixedRegImmByte<opcode, (outs), (ins uimm8:$imm), opcodestr, "flags, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [PTB] in
class PTBImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstFixedRegImmByte<opcode, (outs), (ins uimm8:$imm), opcodestr, "ptb, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [DP] in
class DPRegImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstFixedRegImmWord<opcode, (outs), (ins uimm16:$imm), opcodestr, "dp, $imm">;


let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Defs = [PC] in
class PCOnly<ECLairOpcode opcode, string opcodestr>
    : ECLairInstNoReg<opcode, (outs), (ins), opcodestr, "pc">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLowImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmByte<opcode, (outs), (ins HalfWidthLow:$rd, uimm8:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHighImmByte<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmByte<opcode, (outs), (ins HalfWidthHigh:$rd, uimm8:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegLowImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmWord<opcode, (outs), (ins HalfWidthLow:$rd, uimm16:$imm), opcodestr, "$rd, $imm">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class HalfRegHighImmWord<ECLairOpcode opcode, string opcodestr>
    : ECLairInstRegImmWord<opcode, (outs), (ins HalfWidthHigh:$rd, uimm16:$imm), opcodestr, "$rd, $imm">;
      
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class FullRegImmByte<ECLairOpcode opcode, string opcodestr>
      : ECLairInstRegImmByte<opcode, (outs), (ins FullWidth:$rd, uimm8:$imm), opcodestr, "$rd, $imm">;

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

def HALT  : Basic<OPC_HALT,  "halt"> {}
def CIR   : Basic<OPC_CIR,   "cir"> {}
def EI    : Basic<OPC_EI,    "ei"> {}
def DI    : Basic<OPC_DI,    "di"> {}
def WRPTE : Basic<OPC_WRPTE, "wrpte"> {}
def WRCSE : Basic<OPC_WRCSE, "wrcse"> {}

def ADD16 : FullRegFullReg<OPC_ADD16, "add"> {}
def ADD8L : HalfRegLowHalfRegLow<OPC_ADD8L, "add"> {}
def ADD8H : HalfRegHighHalfRegHigh<OPC_ADD8H, "add"> {}

def SUB16 : FullRegFullReg<OPC_SUB16, "sub"> {}
def SUB8L : HalfRegLowHalfRegLow<OPC_SUB8L, "sub"> {}
def SUB8H : HalfRegHighHalfRegHigh<OPC_SUB8H, "sub"> {}

def SHL16 : FullRegImmByte<OPC_SHL16, "shl"> {}
def SHL8L : HalfRegLowImmByte<OPC_SHL8L, "shl"> {}
def SHL8H : HalfRegHighImmByte<OPC_SHL8H, "shl"> {}

def SHR16 : FullRegImmByte<OPC_SHR16, "shr"> {}
def SHR8L : HalfRegLowImmByte<OPC_SHR8L, "shr"> {}
def SHR8H : HalfRegHighImmByte<OPC_SHR8H, "shr"> {}

def INV16 : FullReg<OPC_INV16, "inv"> {}
def INV8L : HalfRegLow<OPC_INV8L, "inv"> {}
def INV8H : HalfRegHigh<OPC_INV8H, "inv"> {}

def AND16 : FullRegFullReg<OPC_AND16, "and"> {}
def AND8L : HalfRegLowHalfRegLow<OPC_AND8L, "and"> {}
def AND8H : HalfRegHighHalfRegHigh<OPC_AND8H, "and"> {}

def OR16  : FullRegFullReg<OPC_OR16, "or"> {}
def OR8L  : HalfRegLowHalfRegLow<OPC_OR8L, "or"> {}
def OR8H  : HalfRegHighHalfRegHigh<OPC_OR8H, "or"> {}

def XOR16 : FullRegFullReg<OPC_XOR16, "xor"> {}
def XOR8L : HalfRegLowHalfRegLow<OPC_XOR8L, "xor"> {}
def XOR8H : HalfRegHighHalfRegHigh<OPC_XOR8H, "xor"> {}

def SWAB  : FullReg<OPC_SWAB, "swab"> {}
def SEX   : FullReg<OPC_SEX,  "sex"> {}

def CMP16 : FullRegFullReg<OPC_CMP16, "cmp"> {}
def CMP8L : HalfRegLowHalfRegLow<OPC_CMP8L, "cmp"> {}
def CMP8H : HalfRegHighHalfRegHigh<OPC_CMP8H, "cmp"> {}

def LDI16    : FullRegImmWord<OPC_LDI16, "ldi"> {}
def LDI16SP  : SPRegImmWord<OPC_LDI16SP, "ldi"> {}
def LDI16DP  : DPRegImmWord<OPC_LDI16DP, "ldi"> {}
def LDI8L    : HalfRegLowImmByte<OPC_LDI8L, "ldi"> {}
def LDI8H    : HalfRegHighImmByte<OPC_LDI8H, "ldi"> {}
def LDIFLAGS : FlagsImmByte<OPC_LDIFLAGS, "ldi"> {}
def LDIPTB   : PTBImmByte<OPC_LDIPTB, "ldi"> {}

def LD16     : FullRegImmWord<OPC_LD16, "ld"> {}
def LD8L     : HalfRegLowImmWord<OPC_LD8L, "ld"> {}
def LD8H     : HalfRegHighImmWord<OPC_LD8H, "ld"> {}

def ST16     : FullRegImmWord<OPC_ST16, "st"> {}
def ST8L     : HalfRegLowImmWord<OPC_ST8L, "st"> {}
def ST8H     : HalfRegHighImmWord<OPC_ST8H, "st"> {}

def JMP   : SImmWord<OPC_JMP,   "jmp"> {}
def JMPE  : SImmWord<OPC_JMPE,  "jmpe"> {}
def JMPNE : SImmWord<OPC_JMPNE, "jmpne"> {}
def JMPZ  : SImmWord<OPC_JMPZ,  "jmpz"> {}
def JMPNZ : SImmWord<OPC_JMPNZ, "jmpnz"> {}
def JMPO  : SImmWord<OPC_JMPO,  "jmpo"> {}
def JMPNO : SImmWord<OPC_JMPNO, "jmpno"> {}
def CALL  : ImmWord<OPC_CALL,  "call"> {}
def RETI  : Basic<OPC_RETI,    "reti"> {}

def PUSH16I : ImmWord<OPC_PUSH16I, "push16i"> {}
def PUSH8I  : ImmByte<OPC_PUSH8I, "push8i"> {}
def PUSHPC  : PCOnly<OPC_PUSHPC, "push"> {}
def PUSH16  : FullReg<OPC_PUSH16, "push"> {}
def PUSH8L  : HalfRegLow<OPC_PUSH8L, "push"> {}
def PUSH8H  : HalfRegHigh<OPC_PUSH8H, "push"> {}
def POP16   : FullReg<OPC_POP16, "pop"> {}
def POP8L   : HalfRegLow<OPC_POP8L, "pop"> {}
def POP8H   : HalfRegHigh<OPC_POP8H, "pop"> {}
def RET     : Basic<OPC_POPPC, "ret"> {}
def : InstAlias<"pop pc", (RET)>;