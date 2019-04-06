set(LLVM_TARGET_DEFINITIONS ECLair.td)

tablegen(LLVM ECLairGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM ECLairGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM ECLairGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM ECLairGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM ECLairGenSubtargetInfo.inc -gen-subtarget)

add_public_tablegen_target(ECLairCommonTableGen)

add_llvm_target(ECLairCodeGen
  ECLairTargetMachine.cpp
)

add_subdirectory(AsmParser)
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)