#!/usr/bin/env bash

DEVICE='/dev/nvme0n1'

setfont ter-v32n

nix-env --attr --install nixos.git

parted --script "${DEVICE}" -- mklabel gpt
parted --script "${DEVICE}" -- mkpart esp fat32 8MB 1032MB
parted --script "${DEVICE}" -- mkpart primary 1040MB 100%
parted --script "${DEVICE}" -- set 1 esp on

sleep 3

dd bs=1024 count=4 if=/dev/urandom of=/tmp/crypto_keyfile.bin

echo password | cryptsetup luksFormat --batch-mode --cipher aes-xts-plain64 --hash sha512 --key-size 512 --type luks1 "${DEVICE}p2"
echo password | cryptsetup luksAddKey --batch-mode "${DEVICE}p2" /tmp/crypto_keyfile.bin

cryptsetup open --batch-mode --key-file /tmp/crypto_keyfile.bin --type luks1 "${DEVICE}p2" crypt-nixos

mkfs.fat -n boot -F 32 "${DEVICE}p1"

mkfs.ext4 -L nixos /dev/mapper/crypt-nixos

sleep 3

mount /dev/disk/by-label/nixos /mnt

rm --force --recursive /mnt/lost+found

mkdir --parents /mnt/boot/efi

mount /dev/disk/by-label/boot /mnt/boot/efi

mkdir /mnt/etc

cp /tmp/crypto_keyfile.bin /mnt/etc/

chmod 0000 /mnt/etc/crypto_keyfile.bin

git -C /mnt/etc clone https://github.com/asininemonkey/nixos.git

sed --in-place 's/xxx/vmware-work/' /mnt/etc/nixos/configuration.nix
sed --in-place "s/xxx/$(blkid --match-tag UUID --output value ${DEVICE}p2)/" /mnt/etc/nixos/crypt.nix

nixos-generate-config --show-hardware-config --root /mnt > /mnt/etc/nixos/hardware-configuration.nix

nixos-install --no-root-password

umount /mnt/boot/efi /mnt

cryptsetup close /dev/mapper/crypt-nixos
