#----------------------
# @author Riza Kaan Ucak
# @date 19.02.2024
#
# Makefile for Bootloader
#----------------------

.PHONY:build
.PHONY:clean

# boot image
BOOT=bootloader.bin

# folders
SRC=src
BUILD=build

# commands
QEMU=qemu-system-i386
QEMU_FLAG=-fda

build:
	cd ${SRC} && make
clean:
	cd ${SRC} && make clean
run:
	${QEMU} ${QEMU_FLAG} ${BUILD}/${BOOT}
