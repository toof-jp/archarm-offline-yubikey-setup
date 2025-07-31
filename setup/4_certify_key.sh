#!/bin/sh
export KEY_TYPE=nistp521
echo "$CERTIFY_PASS" | \
  gpg --batch --passphrase-fd 0 \
    --quick-generate-key "$IDENTITY" "$KEY_TYPE" cert never

export KEYID=$(gpg -k --with-colons "$IDENTITY" | \
  awk -F: '/^pub:/ { print $5; exit }')

export KEYFP=$(gpg -k --with-colons "$IDENTITY" | \
  awk -F: '/^fpr:/ { print $10; exit }')

printf "\nKey ID/Fingerprint: %20s\n%s\n\n" "$KEYID" "$KEYFP"

