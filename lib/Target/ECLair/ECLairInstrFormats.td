//===-- ECLairInstrFormats.td - ECLair Instruction Formats ---*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

class InstFormat<bits<4> val> {
  bits<4> Value = val;
}

def InstFormatPseudo  : InstFormat<0>;
def InstFormatNoReg   : InstFormat<1>;
def InstFormatOneReg  : InstFormat<2>;
def InstFormatTwoReg  : InstFormat<3>;

class ECLairOpcode<bits<8> val> {
  bits<8> Value = val;
}

def OPC_HALT    : ECLairOpcode<0b11111110>;
def OPC_CIR     : ECLairOpcode<0b10101111>;
def OPC_EI      : ECLairOpcode<0b00010111>;
def OPC_DI      : ECLairOpcode<0b01000010>;
def OPC_WRPTE   : ECLairOpcode<0b01100111>;
def OPC_WRCSE   : ECLairOpcode<0b01011010>;

def OPC_ADD16   : ECLairOpcode<0b00010000>;
def OPC_ADD8L   : ECLairOpcode<0b00011000>;
def OPC_ADD8H   : ECLairOpcode<0b00011001>;

def OPC_SHL16   : ECLairOpcode<0b00001100>;
def OPC_SHL8L   : ECLairOpcode<0b00010011>;
def OPC_SHL8H   : ECLairOpcode<0b00010100>;

def OPC_SHR16   : ECLairOpcode<0b00001111>;
def OPC_SHR8L   : ECLairOpcode<0b00010101>;
def OPC_SHR8H   : ECLairOpcode<0b00010110>;

def OPC_INV16   : ECLairOpcode<0b00110101>;
def OPC_INV8L   : ECLairOpcode<0b00110110>;
def OPC_INV8H   : ECLairOpcode<0b00110111>;

def OPC_SWAB    : ECLairOpcode<0b00100101>;
def OPC_SEX     : ECLairOpcode<0b00110011>;

def OPC_CMP16   : ECLairOpcode<0b00100110>;

def OPC_JMP     : ECLairOpcode<0b01000101>;
def OPC_JMPE    : ECLairOpcode<0b11101111>;
def OPC_JMPNE   : ECLairOpcode<0b11011010>;
def OPC_JMPZ    : ECLairOpcode<0b00011011>;
def OPC_JMPNZ   : ECLairOpcode<0b01111100>;

def OPC_LDI16    : ECLairOpcode<0b00001010>;
def OPC_LDI8L    : ECLairOpcode<0b00001001>;
def OPC_LDI8H    : ECLairOpcode<0b00001011>;
def OPC_LDI16SP  : ECLairOpcode<0b00100111>;
def OPC_LDI16DP  : ECLairOpcode<0b01101100>;
def OPC_LDIFLAGS : ECLairOpcode<0b00100001>;
def OPC_LDIPTB   : ECLairOpcode<0b01000001>;

def OPC_ST16     : ECLairOpcode<0b00111011>;
def OPC_ST8L     : ECLairOpcode<0b00001101>;
def OPC_ST8H     : ECLairOpcode<0b00001110>;

class ECLairInst8<dag outs, dag ins, string opcodestr, string argstr,
             list<dag> pattern, InstFormat format>
    : Instruction {
  field bits<8> Inst;
  let Size = 1;

  bits<8> Opcode = 0;

  let Inst{7-0} = Opcode;

  let Namespace = "ECLair";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;
}

class ECLairInst16<dag outs, dag ins, string opcodestr, string argstr,
             list<dag> pattern, InstFormat format>
    : Instruction {
  field bits<16> Inst;
  let Size = 2;

  bits<8> Opcode = 0;

  let Inst{7-0} = Opcode;

  let Namespace = "ECLair";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;
}

class ECLairInst24<dag outs, dag ins, string opcodestr, string argstr,
             list<dag> pattern, InstFormat format>
    : Instruction {
  field bits<24> Inst;
  let Size = 3;

  bits<8> Opcode = 0;

  let Inst{7-0} = Opcode;

  let Namespace = "ECLair";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;
}


class ECLairInstNoReg<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst8<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {

  let Opcode = opcode.Value;
}

class ECLairInstOneReg<ECLairOpcode opcode, dag outs, dag ins, string opcodestr
, string argstr>
    : ECLairInst8<outs, ins, opcodestr, argstr, [], InstFormatOneReg> {
  bits<4> rd;

  let Opcode = opcode.Value;
  let Inst{7-6} = rd{1-0};
  let Inst{5-0} = opcode.Value{5-0};
}

class ECLairInstTwoReg<ECLairOpcode opcode, dag outs, dag ins, string opcodestr
, string argstr>
    : ECLairInst16<outs, ins, opcodestr, argstr, [], InstFormatTwoReg> {
  bits<4> rd;
  bits<4> rs2;

  let Opcode = opcode.Value;
  let Inst{13-8} = opcode.Value{5-0};
  let Inst{15-14} = rd{1-0};
  let Inst{1-0} = rs2{1-0};
  let Inst{7-2} = 0;
}

// TODO: see if we can collapse FixedReg and Reg together
class ECLairInstRegImmWord<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst24<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {
  bits<4> rd;
  bits<16> imm;
  
  let Opcode = opcode.Value;
  let Inst{23-22} = rd{1-0};
  let Inst{21-16} = opcode.Value{5-0};
  let Inst{15-0} = imm;
}

class ECLairInstFixedRegImmWord<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst24<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {
  bits<16> imm;
  
  let Opcode = opcode.Value;
  let Inst{23-16} = opcode.Value{7-0};
  let Inst{15-0} = imm;
}

class ECLairInstFixedRegImmByte<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst16<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {
  bits<8> imm;
  
  let Opcode = opcode.Value;
  let Inst{15-8} = opcode.Value{7-0};
  let Inst{7-0} = imm;
}

class ECLairInstRegImmByte<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst16<outs, ins, opcodestr, argstr, [], InstFormatOneReg> {
  bits<4> rd;
  bits<8> imm;

  let Opcode = opcode.Value;
  let Inst{15-14} = rd{1-0};
  let Inst{13-8} = opcode.Value{5-0};
  let Inst{7-0} = imm;
}


class ECLairInstImmWord<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst24<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {
      bits<16> imm;

      let Opcode = opcode.Value;
      let Inst{23-16} = opcode.Value{7-0};
      let Inst{15-0} = imm;
}

