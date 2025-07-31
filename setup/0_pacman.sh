#!/bin/sh

pacman-key --init
pacman-key --populate archlinuxarm
pacman -U /var/cache/pacman/pkg/archlinuxarm-keyring-*.pkg.tar.xz
pacman -U /var/cache/pacman/pkg/*.pkg.tar.xz
