#!/usr/bin/env sh
set -ue

user=f

# create user
pacman -S --need --noconfirm sudo zsh git curl bash-completion
sed -Ei '/^# %wheel.*NOPASSWD/s/.*(%wheel.*)/\1/' /etc/sudoers
useradd -m -G wheel -s /bin/zsh $user
echo $user:f | chpasswd

# archlinuxcn
cat >>/etc/pacman.conf <<EOF
[archlinuxcn]
[multilib]
Include = /etc/pacman.d/mirrorlist
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF
pacman -Sy --need --noconfirm archlinuxcn-keyring

# desktop
pacman -Sy --need mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
git config --global user.name etcqez
git config --global user.email etcqez@outlook.com
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/Hyprdots
