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
./arch_setup/arch/install.sh

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
UUID=$(lsblk -o NAME,PARTUUID | grep "${DISK}3" | cut -d' ' -f2)
EFI_CONF="rw add_efi_memmap initrd=boot\\${UCODE}-ucode.img initrd=boot\\initramfs-%v.img"
printf "\"Boot with simple configuration\" \"root=PARTUUID=%s %s\"\n" \
       "$UUID" "$EFI_CONF" \
       > /boot/refind_linux.conf

# Download dotfiles for user
DOTFILES_PATH="/home/$USER_NAME/dotfiles"
git clone https://github.com/ggzor/dotfiles "$DOTFILES_PATH"
chown -R "${USER_NAME}:users" "$DOTFILES_PATH"

