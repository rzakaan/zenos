
BOOTLOADER=bootloader
KERNEL=zenos

image: bootclean bootloader kernel
	@echo "creating image"

bootloader: bootclean
	cd ${BOOTLOADER} && make

bootclean:
	cd ${BOOTLOADER} && make clean

kernel:
	cd ${KERNEL} && make
