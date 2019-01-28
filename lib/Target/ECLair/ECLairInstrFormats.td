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
def OPC_ADD16   : ECLairOpcode<0b00010000>;
def OPC_JMPE    : ECLairOpcode<0b11101111>;
def OPC_JMPNE   : ECLairOpcode<0b11110011>;
def OPC_LDI8L   : ECLairOpcode<0b00001001>;

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

class ECLairInstNoReg<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst8<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {

  let Opcode = opcode.Value;
}

class ECLairInstTwoReg<ECLairOpcode opcode, dag outs, dag ins, string opcodestr
, string argstr>
    : ECLairInst16<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {

  let Opcode = opcode.Value;
}

// TODO: this is way more than 8 bits wide
class ECLairInstImmWord<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst8<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {

  let Opcode = opcode.Value;
}

class ECLairInstRegImmByte<ECLairOpcode opcode, dag outs, dag ins, string opcodestr, string argstr>
    : ECLairInst16<outs, ins, opcodestr, argstr, [], InstFormatNoReg> {

  let Opcode = opcode.Value;
}
