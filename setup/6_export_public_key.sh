#!/bin/sh

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

fdisk $DEVICE <<EOF
n


+20M
w
EOF

mkfs.ext2 $DEVICE"2"

mkdir /mnt/public

mount $DEVICE"2" /mnt/public

gpg --armor --export $KEYID | tee /mnt/public/$KEYID-$(date +%F).asc

chmod 0444 /mnt/public/*.asc

umount /mnt/public
