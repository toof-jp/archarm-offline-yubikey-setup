#!/bin/sh
export CERTIFY_PASS=$(LC_ALL=C tr -dc 'A-Z2-9' < /dev/urandom \
  | tr -d 'IOUS5' \
  | fold -w 4 \
  | paste -sd '-' - \
  | head -c 29)

printf '\n%s\n\n' "$CERTIFY_PASS"
