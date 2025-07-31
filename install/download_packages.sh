#!/bin/sh

git clone https://aur.archlinux.org/archlinuxarm-keyring.git
cd archlinuxarm-keyring
makepkg -si
cd ..

mkdir -p /tmp/arm-pkgs/var/lib/pacman
mkdir -p /tmp/arm-pkgs/var/cache/pacman/pkg
mkdir -p /tmp/arm-pkgs/etc/pacman.d/gnupg

sudo pacman-key --gpgdir /tmp/arm-pkgs/etc/pacman.d/gnupg --init
sudo pacman-key --gpgdir /tmp/arm-pkgs/etc/pacman.d/gnupg --populate archlinuxarm

sudo pacman -Syw --config=arm_pacman.conf --noconfirm \
  gnupg pcsclite ccid pcsc-tools yubikey-personalization yubikey-manager archlinuxarm-keyring mkinitcpio systemd lvm2 mdadm cryptsetup
