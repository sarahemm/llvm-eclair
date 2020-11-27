set(LLVM_TARGET_DEFINITIONS ECLair.td)

tablegen(LLVM ECLairGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM ECLairGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM ECLairGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM ECLairGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM ECLairGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM ECLairGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM ECLairGenDisassemblerTables.inc -gen-disassembler)

add_public_tablegen_target(ECLairCommonTableGen)

add_llvm_target(ECLairCodeGen
  ECLairTargetMachine.cpp
)

add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(InstPrinter)
add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
