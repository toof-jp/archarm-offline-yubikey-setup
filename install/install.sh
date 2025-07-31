#/bin/bash

if [[ $# -ne 1 ]]; then
  echo "Error: exactly one argument must be provided." >&2
  echo "Usage: $0 DEVICE" >&2
  exit 1
fi

DEVICE="$1"

echo "WARNING: This WILL irreversibly erase ALL data on '$DEVICE'."
read -rp "Type 'y' to proceed, or anything else to abort: " answer

if [[ "$answer" != "y" ]]; then
  echo "Abort: no changes made."
  exit 1
fi

fdisk_command=''
fdisk_command+='o'$'\n' # Create a new empty partition table
fdisk_command+='p'$'\n' # Print the current partition table

fdisk_command+='n'$'\n' # New partition
fdisk_command+='p'$'\n' # Print the current partition table
fdisk_command+='1'$'\n' # First partition
fdisk_command+=$'\n' # ENTER to accept the default first sector
fdisk_command+='+200M'$'\n' # 200MB for the boot partition

fdisk_command+='t'$'\n' # Change the type of the partition
fdisk_command+='c'$'\n' # W95 FAT32 (LBA)

fdisk_command+='n'$'\n' # New partition
fdisk_command+='p'$'\n' # Primary
fdisk_command+='2'$'\n' # Second partition
fdisk_command+=$'\n' # ENTER to accept the default first sector
fdisk_command+=$'\n' # ENTER to accept the default last sector

fdisk_command+='w'$'\n' # Write changes and exit

echo "$fdisk_command" | sudo fdisk "$DEVICE"

bootp="${DEVICE}1"
rootp="${DEVICE}2"

sudo mkfs.vfat "$bootp"
mkdir -p boot
sudo mount "$bootp" boot

sudo mkfs.ext4 "$rootp"
mkdir -p root
sudo mount "$rootp" root

# Download ArchLinuxARM image
ARCHIVE="ArchLinuxARM-rpi-aarch64-latest.tar.gz"
URL="http://os.archlinuxarm.org/os/$ARCHIVE"
if [[ ! -f "$ARCHIVE" ]]; then
  echo "$ARCHIVE not found. Downloading..."
  wget "$URL"
fi

sudo bsdtar -xpf "$ARCHIVE" -C root
sync

sudo mv root/boot/* boot/

sudo cp /tmp/arm-pkgs/var/cache/pacman/pkg/*.pkg.tar.xz root/var/cache/pacman/pkg/
sudo cp /tmp/arm-pkgs/var/cache/pacman/pkg/*.pkg.tar.xz.sig root/var/cache/pacman/pkg/

sudo cp ../setup/* root/root/

sudo umount boot root

echo "Installation complete. You can now boot the device."
