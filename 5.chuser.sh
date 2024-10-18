#!/usr/bin/env sh
set -ue

user=f

# create user
pacman -S --need --noconfirm sudo git zsh
useradd -m -G wheel $user
echo $user:f | chpasswd

# archlinuxcn
cat >>/etc/pacman.conf <<EOF
[multilib]
Include = /etc/pacman.d/mirrorlist
[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF
pacman-key --lsign-key farseerfc@archlinux.org
pacman -Sy --need --noconfirm archlinuxcn-keyring


# driver
#pacman -Sy --need mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
pacman -Sy --need mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver mesa-vdpau

# config
sed -Ei '/^# %wheel.*NOPASSWD/s/.*(%wheel.*)/\1/' /etc/sudoers
mv ../arch-auto-install-with-btrfs-lvm /home/$user/
su - $user
