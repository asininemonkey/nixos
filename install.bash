#!/usr/bin/env bash

set -e

FLAKE='github:asininemonkey/nixos'

if [ -z ${1} ];
then
    echo 'NixOS configuration name not specified.'
    exit
fi

sudo nix run --experimental-features 'flakes nix-command' \
    'github:nix-community/disko' -- \
        --flake "${FLAKE}#${1}" \
        --mode 'destroy,format,mount' \
        --yes-wipe-all-disks

sudo nixos-install \
    --flake "${FLAKE}#${1}" \
    --no-root-passwd \
    --root /mnt
