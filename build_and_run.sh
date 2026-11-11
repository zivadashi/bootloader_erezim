#!/usr/bin/env bash

# Constants
BOOTLOADER_ASM="boot.asm"
BOOTLOADER_BIN="boot.bin"
DISK_IMAGE="disk.img"

# compiling the bootloader
nasm -f bin "$BOOTLOADER_ASM" -o "$BOOTLOADER_BIN"

# creating an empty image disk
dd if=/dev/zero of="$DISK_IMAGE" bs=1M count=64\

# burning the bootloader to the disk
dd if="$BOOTLOADER_BIN" of="$DISK_IMAGE" bs=512 conv=notrunc

# running qemu on the disk images
qemu-system-x86_64 -drive file="$DISK_IMAGE",format=raw
