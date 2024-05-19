#!/usr/bin/env sh
set -ue

lvcreate -n lv_arch -L 100G vg_linux
mkfs.btrfs /dev/mapper/vg_linux-lv_arch
mount /dev/mapper/vg_linux-lv_arch /mnt
btrfs su cr /mnt/@
umount -R /mnt
mount -o defaults,noatime,compress=zstd,commit=120,subvol=@ /dev/mapper/vg_linux-lv_arch /mnt
mkdir /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
