#----------------------
# @author Riza Kaan Ucak
# @date 19.02.2024
#
# Makefile for Bootloader
#----------------------

.PHONY:build
.PHONY:clean

# binaries
BINARY=bootloader.bin

# folders
BUILD=../build

# complier
ASM=nasm
FLAGS=-f bin

build: kernel_entry.o
	$(info Building BootLoader...)
	${ASM} ${FLAGS} -o ${BUILD}/${BINARY} boot.asm

%.o : %.asm
	nasm $< -f elf -o ${BUILD}/$@

clean:
	rm -rf ${BUILD}/*
