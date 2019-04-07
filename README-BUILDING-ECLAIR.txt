To build the ECLair backend:
1. Create a directory "build" under this directory.
2. Change into the new directory.
3. Run this to set up the build tree. This enables both the ECLair and the RISCV targets, as I've found it useful to have a known-good target to compare against when things break. Removing 'RISCV' below will slightly speed up the initial build, if you don't need that.

cmake -G Ninja -DCMAKE_BUILD_TYPE="Debug" \
  -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
  -DLLVM_OPTIMIZED_TABLEGEN=True \
  -DLLVM_BUILD_TESTS=True \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_TARGETS_TO_BUILD="" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="ECLair;RISCV" ../

4. Run this each time you need to build the tree.
cmake --build .
