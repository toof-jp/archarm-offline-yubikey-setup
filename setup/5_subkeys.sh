#!/bin/sh
export EXPIRATION=1y

echo "$CERTIFY_PASS" | \
  gpg --batch --pinentry-mode=loopback --passphrase-fd 0 \
    --quick-add-key "$KEYFP" ed25519 sign "$EXPIRATION"

echo "$CERTIFY_PASS" | \
  gpg --batch --pinentry-mode=loopback --passphrase-fd 0 \
    --quick-add-key "$KEYFP" cv25519 encrypt "$EXPIRATION"

echo "$CERTIFY_PASS" | \
  gpg --batch --pinentry-mode=loopback --passphrase-fd 0 \
    --quick-add-key "$KEYFP" ed25519 auth "$EXPIRATION"
