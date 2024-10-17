#!/usr/bin/env bash

setfont ter-v32n

while [[ -z "${DEVICE}" ]]
do
    clear

    read -n 1 -p $'Available Devices:\n\n(a) ASRock X570 PC\n(m) MacBook Pro\n(p) MSI Pro PC\n(q) QEMU VM\n(z) ASUS Zenbook Laptop\n\nWhich Device? ' -s

    case "${REPLY}" in
        a)
            DEVICE='asrock-x570'
            PARTITION='-part'
            STORAGE='/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b45aac797'
            ;;
        m)
            DEVICE='macbook-pro'
            PARTITION='p'
            STORAGE='/dev/nvme0n1'
            ;;
        p)
            DEVICE='msi-pro'
            PARTITION='-part'
            STORAGE='/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b444a49b31b6a'
            ;;
        q)
            DEVICE='qemu'
            PARTITION=''
            STORAGE='/dev/vda'
            ;;
        z)
            DEVICE='asus-zenbook'
            PARTITION='-part'
            STORAGE='/dev/disk/by-id/nvme-eui.000000000000000100a075223cdfbdc9'
            ;;
        *)
            unset DEVICE
            ;;
    esac
done

while [[ -z "${PROFILE}" ]]
do
    clear

    read -n 1 -p $'Available Profiles:\n\n(p) Personal\n(w) Work\n\nWhich Profile? ' -s

    case "${REPLY}" in
        p)
            PROFILE='personal'
            HOSTNAME="${DEVICE}"
            ;;
        w)
            PROFILE='work'
            HOSTNAME="${DEVICE}-${PROFILE}"
            ;;
        *)
            unset PROFILE
            ;;
    esac
done

case "${DEVICE}" in
    qemu)
        while [[ -z "${HOST}" ]]
        do
            clear

            read -n 1 -p $'Available Hosts:\n\n(m) Mac Mini\n(p) MacBook Pro\n\nWhich Host? ' -s

            case "${REPLY}" in
                m)
                    HOST="mac-mini"
                    ;;
                p)
                    HOST="macbook-pro"
                    ;;
                *)
                    unset HOST
                    ;;
            esac
        done

        HOSTNAME="${HOSTNAME}-${HOST}"
        ;;
esac

clear

while [[ -z "${ENCRYPT}" ]]
do
    clear

    read -n 1 -p $'Encrypt Disk? (y/n) ' -s

    case "${REPLY}" in
        n)
            ENCRYPT=false
            ;;
        y)
            ENCRYPT=true
            ;;
        *)
            unset ENCRYPT
            ;;
    esac
done

clear

case "${DEVICE}" in
    asrock-x570|asus-zenbook|msi-pro)
        sudo nvme format --force --ses 1 "${STORAGE}"
        ;;
esac

sudo parted --script "${STORAGE}" -- mklabel gpt
sudo parted --script "${STORAGE}" -- mkpart esp fat32 8MB 1032MB
sudo parted --script "${STORAGE}" -- mkpart primary 1040MB 100%
sudo parted --script "${STORAGE}" -- set 1 esp on

sleep 3

nix-env --attr --install 'nixos.git'

if ${ENCRYPT}
then
    dd bs=1024 count=4 if='/dev/urandom' of='/tmp/crypto_keyfile.bin'
fi

clear

if ${ENCRYPT}
then
    read -p $'Disk Encryption Password: ' -s PASSWORD

    echo -n 'Encrypting Disk...'

    echo "${PASSWORD}" | sudo cryptsetup luksFormat --batch-mode --cipher 'aes-xts-plain64' --hash 'sha512' --iter-time 1 --key-size 512 --type 'luks1' "${STORAGE}${PARTITION}2"
    echo "${PASSWORD}" | sudo cryptsetup luksAddKey --batch-mode "${STORAGE}${PARTITION}2" '/tmp/crypto_keyfile.bin'

    sudo cryptsetup open --batch-mode --key-file '/tmp/crypto_keyfile.bin' --type 'luks1' "${STORAGE}${PARTITION}2" 'crypt-nixos'

    echo -n 'Encrypted.'
fi

sudo mkfs.fat -n 'boot' -F 32 "${STORAGE}${PARTITION}1"

if ${ENCRYPT}
then
    sudo mkfs.ext4 -L 'nixos' '/dev/mapper/crypt-nixos'
else
    sudo mkfs.ext4 -L 'nixos' "${STORAGE}${PARTITION}2"
fi

sleep 3

sudo mount '/dev/disk/by-label/nixos' '/mnt'

sudo rm --force --recursive '/mnt/lost+found'

sudo mkdir --parents '/mnt/boot/efi' '/mnt/etc'

sudo mount '/dev/disk/by-label/boot' '/mnt/boot/efi'

if ${ENCRYPT}
then
    sudo cp '/tmp/crypto_keyfile.bin' '/mnt/etc/'
    sudo chmod 0000 '/mnt/etc/crypto_keyfile.bin'
fi

case "${DEVICE}" in
    macbook-pro)
        sudo mkdir --parents '/mnt/lib/firmware'
        sudo cp --recursive '/lib/firmware/brcm' '/mnt/lib/firmware/'
        ;;
esac

sudo git -C '/mnt/etc' clone --branch main --single-branch 'https://github.com/asininemonkey/nixos.git'

sudo tee '/mnt/etc/nixos/device-configuration.nix' > '/dev/null' << EOF
{
  config,
  ...
}:

{
  imports = [
    ./devices/${DEVICE}.nix
    ./profiles/${PROFILE}.nix
  ];

  networking.hostName = "${HOSTNAME}";
}
EOF

nixos-generate-config --show-hardware-config --root '/mnt' | sudo tee '/mnt/etc/nixos/hardware-configuration.nix' > '/dev/null'

sudo nixos-install --no-root-password

sudo umount '/mnt/boot/efi' '/mnt'

if ${ENCRYPT}
then
    sudo cryptsetup close '/dev/mapper/crypt-nixos'
fi
