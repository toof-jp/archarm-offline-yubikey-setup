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

dd if=/dev/zero of=$DEVICE bs=4M count=1 status=progress

fdisk $DEVICE <<EOF
g
w
EOF

fdisk $DEVICE <<EOF
n


+20M
w
EOF

export LUKS_PASS=$(LC_ALL=C tr -dc "A-Z2-9" < /dev/urandom | \
    tr -d "IOUS5" | \
    fold  -w  ${PASS_GROUPSIZE:-4} | \
    paste -sd ${PASS_DELIMITER:--} - | \
    head  -c  ${PASS_LENGTH:-29})
printf "\n$LUKS_PASS\n\n"

echo $LUKS_PASS | \
    cryptsetup -q luksFormat $DEVICE"1"

echo $LUKS_PASS | \
    cryptsetup -q luksOpen $DEVICE"1" gnupg-secrets

mkfs.ext2 /dev/mapper/gnupg-secrets -L gnupg-$(date +%F)

mkdir -p /mnt/encrypted-storage

mount /dev/mapper/gnupg-secrets /mnt/encrypted-storage

cp -av $GNUPGHOME /mnt/encrypted-storage/

umount /mnt/encrypted-storage

cryptsetup luksClose gnupg-secrets
