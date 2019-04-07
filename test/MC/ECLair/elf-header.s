# RUN: llvm-mc %s -filetype=obj -triple=eclair | llvm-readobj -h \
# RUN:     | FileCheck -check-prefix=eclair %s
# RUN: llvm-mc %s -filetype=obj -triple=eclair | llvm-readobj -h \
# RUN:     | FileCheck -check-prefix=eclair %s

# ECLAIR: Format: ELF32-eclair
# ECLAIR: Arch: eclair
# ECLAIR: AddressSize: 32bit
# ECLAIR: ElfHeader {
# ECLAIR:   Ident {
# ECLAIR:     Magic: (7F 45 4C 46)
# ECLAIR:     Class: 32-bit (0x1)
# ECLAIR:     DataEncoding: LittleEndian (0x1)
# ECLAIR:     FileVersion: 1
# ECLAIR:     OS/ABI: SystemV (0x0)
# ECLAIR:     ABIVersion: 0
# ECLAIR:   }
# ECLAIR:   Type: Relocatable (0x1)
# ECLAIR:   Machine: EM_ECLAIR (0x3419)
# ECLAIR:   Version: 1
# ECLAIR:   Flags [ (0x0)
# ECLAIR:   ]
# ECLAIR: }
