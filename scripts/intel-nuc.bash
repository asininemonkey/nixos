#!/usr/bin/env bash

STORAGE='/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b444a4658cbbe'

# sudo nvme format --force --ses 1 "${STORAGE}"

sudo parted --script "${STORAGE}" -- mklabel gpt
sudo parted --script "${STORAGE}" -- mkpart esp fat32 8MB 1032MB
sudo parted --script "${STORAGE}" -- mkpart primary 1040MB 100%
sudo parted --script "${STORAGE}" -- set 1 esp on

sleep 3

sudo mkfs.fat -n 'boot' -F 32 "${STORAGE}-part1"

sudo mkfs.ext4 -L 'nixos' "${STORAGE}-part2"

sleep 3

sudo mount '/dev/disk/by-label/nixos' '/mnt'

sudo rm --force --recursive '/mnt/lost+found'

sudo mkdir --parents '/mnt/boot' '/mnt/data' '/mnt/etc/nixos'

sudo mount '/dev/disk/by-label/boot' '/mnt/boot'

sudo mount '/dev/disk/by-uuid/c1bb8dc2-5e17-4568-9d4f-979539881f09' '/mnt/data'
sudo mount '/dev/disk/by-uuid/023acd3b-ec61-4e83-9eb9-7ed2f31d3307' '/mnt/data/rips'

curl --location --silent 'https://raw.githubusercontent.com/asininemonkey/nixos/main/devices/intel-nuc.nix' | sudo tee '/mnt/etc/nixos/configuration.nix' > '/dev/null'

nixos-generate-config --show-hardware-config --root '/mnt' | sudo tee '/mnt/etc/nixos/hardware-configuration.nix' > '/dev/null'

sudo nixos-install --no-root-password

sudo umount '/mnt/boot' '/mnt/data' '/mnt'
