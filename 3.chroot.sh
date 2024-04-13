#!/usr/bin/env sh
set -ue

echo Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch >/etc/pacman.d/mirrorlist
pacstrap -K /mnt base base-devel linux-zen linux-zen-headers linux-firmware lvm2 networkmanager vim man btrfs-progs neovim bash-completion
genfstab -U /mnt >>/mnt/etc/fstab
cat /mnt/etc/fstab
cp -rf ../arch-auto-install-with-btrfs-lvm /mnt/root
arch-chroot /mnt
echo chroot succes
