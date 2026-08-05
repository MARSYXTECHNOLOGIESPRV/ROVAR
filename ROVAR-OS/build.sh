#!/bin/bash

set -e

echo "=============================="
echo " Building ROVAR OS"
echo "=============================="


mkdir -p build


echo "[1/10] Building Boot0..."

nasm -f bin boot/boot0.asm -o build/boot0.bin


echo "[2/10] Building Boot1..."

nasm -f bin boot/boot1.asm -o build/boot1.bin


echo "[3/10] Building Kernel Entry..."

nasm -f elf32 kernel/entry.asm -o build/kernel_entry.o


echo "[4/10] Building Kernel..."

gcc \
-m32 \
-ffreestanding \
-fno-pie \
-fno-stack-protector \
-c kernel/kernel.c \
-o build/kernel.o


echo "[5/10] Building VGA Driver..."

gcc \
-m32 \
-ffreestanding \
-fno-pie \
-fno-stack-protector \
-c kernel/drivers/vga.c \
-o build/vga.o


echo "[6/10] Linking Kernel..."

ld \
-m elf_i386 \
-e kernel_start \
-Ttext 0x10000 \
-o build/kernel.elf \
build/kernel_entry.o \
build/kernel.o \
build/vga.o


echo "[7/10] Creating Kernel Binary..."

objcopy \
-O binary \
build/kernel.elf \
build/kernel.bin


echo "[8/10] Creating Disk Image..."

dd \
if=/dev/zero \
of=build/rovar.img \
bs=512 \
count=2880 \
status=none


echo "[9/10] Writing Boot Files..."

dd \
if=build/boot0.bin \
of=build/rovar.img \
conv=notrunc \
status=none


dd \
if=build/boot1.bin \
of=build/rovar.img \
bs=512 \
seek=1 \
conv=notrunc \
status=none


echo "[10/10] Writing Kernel..."

dd \
if=build/kernel.bin \
of=build/rovar.img \
bs=512 \
seek=5 \
conv=notrunc \
status=none


echo ""
echo "=============================="
echo " Build Complete!"
echo "=============================="
echo ""

echo "Boot0:   $(stat -c "%s" build/boot0.bin) bytes"
echo "Boot1:   $(stat -c "%s" build/boot1.bin) bytes"
echo "Kernel:  $(stat -c "%s" build/kernel.bin) bytes"

echo ""
echo "Run:"
echo "qemu-system-i386 -fda build/rovar.img"
