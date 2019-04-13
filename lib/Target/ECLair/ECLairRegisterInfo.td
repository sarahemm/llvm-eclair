//===-- ECLairRegisterInfo.td - ECLair Register defs --------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the ECLair register files
//===----------------------------------------------------------------------===//

let Namespace = "ECLair" in {
  class ECLairReg<bits<4> Enc, string name> : Register<name> {
    let HWEncoding{3-0} = Enc;
  }

  class ECLairRegWithSubregs<bits<4> Enc, string name, list<Register> subregs>: RegisterWithSubRegs<name, subregs> {
    let HWEncoding{3-0} = Enc;
  }
  
  // TODO: what is XLen the length of?
  //def XLenVT : i16;

  def subreg_8bit_lo    : SubRegIndex<8>;
  def subreg_8bit_hi    : SubRegIndex<8>;
  
  // CPU registers
  def AL : ECLairReg<0, "al">;
  def AH : ECLairReg<0, "ah">;
  def BL : ECLairReg<1, "bl">;
  def BH : ECLairReg<1, "bh">;
  def CL : ECLairReg<2, "cl">;
  def CH : ECLairReg<2, "ch">;
  def DL : ECLairReg<3, "dl">;
  def DH : ECLairReg<3, "dh">;

  def SP : ECLairReg<9, "sp">;
  def DP : ECLairReg<10, "dp">;

  let SubRegIndices = [subreg_8bit_lo, subreg_8bit_hi] in {    
    def A : ECLairRegWithSubregs<0, "a", [AL, AH]>;
    def B : ECLairRegWithSubregs<1, "b", [BL, BH]>;
    def C : ECLairRegWithSubregs<2, "c", [CL, CH]>;
    def D : ECLairRegWithSubregs<3, "d", [DL, DH]>;
  }

  def FullWidthSP : RegisterClass<"ECLair", [i16], 16, (add SP)>;

  def FullWidthDP : RegisterClass<"ECLair", [i16], 16, (add DP)>;

  def FullWidth : RegisterClass<"ECLair", [i16], 16, (add A, B, C, D, SP)>;
  def HalfWidth : RegisterClass<"ECLair", [i8],  8,  (add AL, AH, BL, BH, CL, CH, DL, DH)>;
  def HalfWidthLow : RegisterClass<"ECLair", [i8],  8,  (add AL, BL, CL, DL)>;
  def HalfWidthHigh : RegisterClass<"ECLair", [i8],  8,  (add AH, BH, CH, DH)>;
}
