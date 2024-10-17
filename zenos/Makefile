# -----------------------
# @author Riza Kaan Ucak
# @date 23.02.2024
# Makefile for kernel
# -----------------------

.PHONY:clean

CC=gcc
CXX=c++
CFLAGS=-c
CXXFLAGS=-c

# folders
SRC=src
KERNEL_DIR=${SRC}/kernel
BUILD_DIR=build

kernel:
	$(CC) $(CFLAGS) $(KERNEL_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o

clean:
	cd $(BUILD_DIR) && rm -rf *
