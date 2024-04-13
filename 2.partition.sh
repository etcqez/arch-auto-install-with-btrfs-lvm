#!/usr/bin/env sh
set -ue
disk=nvme

if [ $disk = nvme ]; then
	fat=nvme0n1p1
	pv=nvme0n1p2
	vg=vg_arch
	dm1=dm_root
	dm2=dm_home
elif [ $disk = sd ]; then
	fat=sda1
	pv=sda4
	vg=system
	dm=sys-arch
fi

echo -e "please confirm \033[31mfat=$fat pv=$pv vg=$vg dm1=$dm1 dm2=$dm2\033[0m"
read confirm
if [ $confirm = yes ]; then
	vgcreate $vg /dev/$pv
	lvcreate -n $dm1 -L 200G $vg
	lvcreate -n $dm2 -l 100%free $vg

	mkfs.vfat /dev/$fat
	mkfs.btrfs /dev/mapper/$vg-$dm1
	mkfs.btrfs /dev/mapper/$vg-$dm2

	mount /dev/mapper/$vg-$dm1 /mnt
	btrfs su cr /mnt/@
	btrfs su cr /mnt/@srv
	btrfs su cr /mnt/@log
	btrfs su cr /mnt/@cache
	btrfs su cr /mnt/@tmp
	btrfs su cr /mnt/@opt
	# btrfs su cr /mnt/@.snapshots
	umount -R /mnt

	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@ /dev/mapper/$vg-$dm1 /mnt
	mkdir /mnt/efi
	mkdir /mnt/home
	mount /dev/$fat /mnt/efi
	mount /dev/mapper/$vg-$dm2 /mnt/home
	btrfs su cr /mnt/home/@
	# btrfs su cr /mnt/home/@.snapshots
	umount -R /mnt/home
	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@ /dev/mapper/$vg-$dm2 /mnt/home
	# mkdir -p /mnt/home/.snapshots
	# mount -o defaults,noatime,compress=zstd,commit=120,subvol=@.snapshots /dev/mapper/$vg-$dm2 /mnt/home/.snapshots
	# mkdir -p /mnt/.snapshots
	mkdir -p /mnt/{srv,var/log,var/cache,tmp,opt}
	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@srv /dev/mapper/$vg-$dm1 /mnt/srv
	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@log /dev/mapper/$vg-$dm1 /mnt/var/log
	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@cache /dev/mapper/$vg-$dm1 /mnt/var/cache
	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@tmp /dev/mapper/$vg-$dm1 /mnt/tmp
	mount -o defaults,noatime,compress=zstd,commit=120,subvol=@opt /dev/mapper/$vg-$dm1 /mnt/opt
	# mount -o defaults,noatime,compress=zstd,commit=120,subvol=@.snapshots /dev/mapper/$vg-$dm1 /mnt/.snapshots

	echo partition succes
else
	echo -e "\033[31mplease input yes\033[0m"
fi
