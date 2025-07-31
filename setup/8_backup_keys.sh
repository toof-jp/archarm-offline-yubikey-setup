#!/bin/sh
echo "$CERTIFY_PASS" | \
    gpg --output $GNUPGHOME/$KEYID-Certify.key \
        --batch --pinentry-mode=loopback --passphrase-fd 0 \
        --armor --export-secret-keys $KEYID

echo "$CERTIFY_PASS" | \
    gpg --output $GNUPGHOME/$KEYID-Subkeys.key \
        --batch --pinentry-mode=loopback --passphrase-fd 0 \
        --armor --export-secret-subkeys $KEYID

gpg --output $GNUPGHOME/$KEYID-$(date +%F).asc \
    --armor --export $KEYID
