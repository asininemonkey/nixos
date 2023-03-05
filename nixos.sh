#!/usr/bin/env bash

setfont ter-v32n

while [[ -z "${DEVICE}" ]]
do
    read -n 1 -p $'\nAvailable Devices:\n\n(a) ASRock X570 PC\n(m) MSI Pro PC\n(q) QEMU VM\n(v) VMware VM\n\nWhich Device? '

    case "${REPLY}" in
        a)
            DEVICE='asrock-x570'
            PARTITION='-part'
            STORAGE='/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b45aac797'
            ;;
        m)
            DEVICE='msi-pro'
            PARTITION='-part'
            STORAGE='/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b444a49b31b6a'
            ;;
        q)
            DEVICE='qemu'
            PARTITION=''
            STORAGE='/dev/vda'
            ;;
        v)
            DEVICE='vmware'
            PARTITION='p'
            STORAGE='/dev/nvme0n1'
            ;;
        *)
            unset DEVICE
            ;;
    esac
done

while [[ -z "${PROFILE}" ]]
do
    read -n 1 -p $'\nAvailable Profiles:\n\n(p) Private\n(w) Work\n\nWhich Profile? '

    case "${REPLY}" in
        p)
            PROFILE='private'
            ;;
        w)
            PROFILE='work'
            ;;
        *)
            unset PROFILE
            ;;
    esac
done

nix-env --attr --install 'nixos.git'

case "${DEVICE}" in
    asrock-x570|msi-pro)
        nix-env --attr --install 'nixos.nvme-cli'

        sudo nvme format --force --ses 1 "${STORAGE}"
        ;;
esac

sudo parted --script "${STORAGE}" -- mklabel gpt
sudo parted --script "${STORAGE}" -- mkpart esp fat32 8MB 1032MB
sudo parted --script "${STORAGE}" -- mkpart primary 1040MB 100%
sudo parted --script "${STORAGE}" -- set 1 esp on

sleep 3

dd bs=1024 count=4 if=/dev/urandom of=/tmp/crypto_keyfile.bin

echo password | sudo cryptsetup luksFormat --batch-mode --cipher aes-xts-plain64 --hash sha512 --key-size 512 --type luks1 "${STORAGE}${PARTITION}2"
echo password | sudo cryptsetup luksAddKey --batch-mode "${STORAGE}${PARTITION}2" /tmp/crypto_keyfile.bin

sudo cryptsetup open --batch-mode --key-file /tmp/crypto_keyfile.bin --type luks1 "${STORAGE}${PARTITION}2" crypt-nixos

sudo mkfs.fat -n boot -F 32 "${STORAGE}${PARTITION}1"

sudo mkfs.ext4 -L nixos /dev/mapper/crypt-nixos

sleep 3

sudo mount /dev/disk/by-label/nixos /mnt

sudo rm --force --recursive /mnt/lost+found

sudo mkdir --parents /mnt/boot/efi

sudo mount /dev/disk/by-label/boot /mnt/boot/efi

sudo mkdir /mnt/etc

sudo cp /tmp/crypto_keyfile.bin /mnt/etc/

sudo chmod 0000 /mnt/etc/crypto_keyfile.bin

sudo git -C /mnt/etc clone https://github.com/asininemonkey/nixos.git

sudo sed --in-place "s/xxxdevicexxx/${DEVICE}/" /mnt/etc/nixos/configuration.nix
sudo sed --in-place "s/xxxprofilexxx/${PROFILE}/" /mnt/etc/nixos/configuration.nix

sudo sed --in-place "s/xxxuuidxxx/$(blkid --match-tag UUID --output value ${STORAGE}${PARTITION}2)/" /mnt/etc/nixos/crypt.nix

nixos-generate-config --show-hardware-config --root /mnt | sudo tee /mnt/etc/nixos/hardware-configuration.nix > /dev/null

sudo nixos-install --no-root-password

sudo umount /mnt/boot/efi /mnt

sudo cryptsetup close /dev/mapper/crypt-nixos
