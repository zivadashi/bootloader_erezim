#!/usr/bin/env bash

# Constants
BOOTLOADER_ASM="boot.asm"
BOOTLOADER_BIN="boot.bin"
KERNEL_ASM="kernel.asm"
KERNEL_BIN="kernel.bin"
DISK_IMAGE="disk.img"

# compiling the bootloader
nasm -f bin "$BOOTLOADER_ASM" -o "$BOOTLOADER_BIN"

# compiling the kernel
nasm -f bin "$KERNEL_ASM" -o "$KERNEL_BIN"

# creating an empty image disk
dd if=/dev/zero of="$DISK_IMAGE" bs=1M count=64\

# burning the bootloader to the disk
dd if="$BOOTLOADER_BIN" of="$DISK_IMAGE" bs=512 conv=notrunc

# burning the kernel to the disk
dd if="$KERNEL_BIN" of="$DISK_IMAGE" bs=512 seek=16 conv=notrunc

# running qemu on the disk images
qemu-system-x86_64 -drive file="$DISK_IMAGE",format=raw
