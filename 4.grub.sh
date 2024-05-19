#!/usr/bin/env sh
set -ue

#systemctl enable NetworkManager
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
sed -Ei 's/^#(zh_CN.UTF-8 UTF-8.*)/\1/' /etc/locale.gen
sed -Ei 's/^#(en_US.UTF-8.*)/\1/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >>/etc/locale.conf
echo Arch >>/etc/hostname

sed -Ei '/^(HOOKS)/s/\)$/ systemd btrfs lvm2\)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo root:f | chpasswd

pacman -S --noconfirm grub efibootmgr amd-ucode
sed -Ei '/^(GRUB_CMDLINE_LINUX_DEFAULT)/s/"$/ net.ifnames=0"/' /etc/default/grub
sed -Ei '/^(GRUB_TIMEOUT=)/s/.$/1/' /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
echo grub install succes, please reboot
