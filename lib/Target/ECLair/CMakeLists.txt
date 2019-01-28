set(LLVM_TARGET_DEFINITIONS ECLair.td)

tablegen(LLVM ECLairGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM ECLairGenInstrInfo.inc -gen-instr-info)

add_public_tablegen_target(RISCVCommonTableGen)

add_llvm_target(ECLairCodeGen
  ECLairTargetMachine.cpp
)

add_subdirectory(TargetInfo)