#----------------------
# @author Riza Kaan Ucak
# @date 19.02.2024
#
# Makefile OS
#----------------------

# folders and files
BOOTLOADER=bootloader
BOOT_BIN=$(BOOTLOADER).bin
KERNEL=zenos
BUILD_DIR=build
FAT_IMAGE=fat32.img

# commands
VIRT=qemu-system-i386
VIRT_FLAG=

floppy: $(BUILD_DIR)/$(FAT_IMAGE)
$(BUILD_DIR)/$(FAT_IMAGE): boot kernel
	dd if=/dev/zero of=$(BUILD_DIR)/$(FAT_IMAGE) bs=512 count=2880 # 512 x 2880 = 1.474.560 = 1.44MB
	mformat -F -i ${BUILD_DIR}/${FAT_IMAGE} ::
	dd if=$(BOOTLOADER)/$(BUILD_DIR)/$(BOOT_BIN) of=$(BUILD_DIR)/$(FAT_IMAGE) conv=notrunc
	mcopy -i ${BUILD_DIR}/${FAT_IMAGE} bootloader/build/bootloader.bin
	mcopy -i ${BUILD_DIR}/${FAT_IMAGE} bootloader/build/kernel.bin

run:
	cd $(BUILD_DIR) && $(VIRT) $(VIRT_FLAG) $(FAT_IMAGE)

list:
	mdir -i ${BUILD_DIR}/${FAT_IMAGE}

boot:
	cd ${BOOTLOADER} && make

bootclean:
	cd ${BOOTLOADER} && make clean

kernel:
	@echo "kernel building"
