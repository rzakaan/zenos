DISK=disk.img

# create 2mb disk
dd if=/dev/zero of=${DISK} bs=512K count=8

# put a file system
mformat -F -i ${DISK} ::

# add a file to it
mcopy -i ${DISK} bootloader/build/bootloader.bin ::

# list files
mdir -i ${DISK} 

# extract file
# mcopy -i disk.img ::/example.txt extracted.txt

