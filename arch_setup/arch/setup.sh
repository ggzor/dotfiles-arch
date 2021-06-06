#!/usr/bin/env bash

# Better bash defaults
set -euo pipefail

# Install required packages
pacman -S --noconfirm "$KERNEL" "$KERNEL-headers" "$UCODE-ucode" \
                      base-devel linux-firmware git

# Setup user accounts
printf "root:%s" "$ROOT_PASSWD" | chpasswd
useradd -m -G wheel -g users "$USER_NAME"
printf "%s:%s" "$USER_NAME" "$PASSWD" | chpasswd
# Add user to sudoers
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo

# Erase and unset sensible root user information
ROOT_PASSWD=''
unset ROOT_PASSWD
PASSWD=''
unset PASSWD

# Install pacman packages
./arch_setup/pacman/install.sh

# Setup locale and timezone
echo "$LOCALE $ENCODING" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

# Register bootloader
# Assume efi is in first disk partition
mkdir -p /efi
mount "/dev/${DISK}1" /efi || true
# Use refind
pacman -S --noconfirm refind
refind-install

# Update refind configuration
printf "\nextra_kernel_version_strings %s\n" "$KERNEL" >> /efi/EFI/refind/refind.conf

# Get partition uuid assuming root is on third partition
SWAP_PARTUUID=$(lsblk -o NAME,PARTUUID | grep "${DISK}2" | cut -d' ' -f2)
ROOT_PARTUUID=$(lsblk -o NAME,PARTUUID | grep "${DISK}3" | cut -d' ' -f2)

EFI_CONF="rw add_efi_memmap initrd=boot\\${UCODE}-ucode.img initrd=boot\\initramfs-%v.img"
printf "\"Boot with simple configuration\" \"root=PARTUUID=%s resume=PARTUUID=%s %s\"\n" \
       "$ROOT_PARTUUID" "$SWAP_PARTUUID" "$EFI_CONF" \
       > /boot/refind_linux.conf

# Add resume to kernel hooks
{ cat << EOF
MODULES=()
BINARIES=()
FILES=()
HOOKS=(base udev autodetect modconf block filesystems keyboard fsck resume)
EOF
} > /etc/mkinitcpio.conf

# Rebuild initramfs
mkinitcpio -P

# Download dotfiles for user
DOTFILES_PATH="/home/$USER_NAME/dotfiles"
git clone --recursive https://github.com/ggzor/dotfiles "$DOTFILES_PATH"
chown -R "${USER_NAME}:users" "$DOTFILES_PATH"

