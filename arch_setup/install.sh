#!/usr/bin/env bash

# Better defaults
set -euo pipefail

declare -A REQUIRED_VARS
REQUIRED_VARS=(
  [DISK]="WARNING: All device data will be deleted. Be sure to backup your data.
Example: sda"
  [SWAP]="The amount of swap space in GiB. You should omit the GiB unit. Example: 4"
  [KERNEL]="It should be set to either linux or linux-lts"
  [UCODE]="It should be set to either amd or intel"
  [ROOT_PASSWD]="This is the root password.
Setting root password in a variable is safe as long as you set it inside archiso.
It will be erased after root password is changed."
  [USER_NAME]="This is the main user name"
  [PASSWD]="This is the main user password. As with ROOT_PASSWD, setting the variable is
 safe inside archiso"
  [LOCALE]="The system locale. Available locales are listed in /etc/locale.gen
Example: en_US.UTF-8"
  [ENCODING]="The system encoding. Example: UTF-8"
  [TIMEZONE]="The system time zone. Available timezones are listed in /usr/share/zoneinfo
Example: America/Mexico_City"
  [KEYMAP]="The keyboard layout. All keyboards layouts can be found in /usr/share/kbd/keymaps
Examples: us, la-latin1"
)

# Check existence of each variable
for VAR in "${!REQUIRED_VARS[@]}"; do
  if [ ! -v "$VAR" ]; then
    echo "$VAR variable is not set. ${REQUIRED_VARS[$VAR]}"
    exit 1
  fi
done

# Calculated variables
export DEVICE="/dev/$DISK"
export SWAP_POSITION="$( echo "$SWAP + 0.5" | bc )"

# Create partitions on given disks
parted --script $DEVICE \
  mklabel gpt \
  mkpart efi fat32 1MiB 513MiB \
  mkpart swap ext4 513MiB "${SWAP_POSITION}GiB" \
  mkpart root ext4 "${SWAP_POSITION}GiB" "100%" \
  set 1 esp on \
  print

# Create file systems without asking for confirmation
yes |  mkfs.fat -F32 "${DEVICE}1" \
    && mkfs.ext4 "${DEVICE}2" \
    && mkfs.ext4 "${DEVICE}3" \
    && mkswap "${DEVICE}2"

# Mount root partition
mount "${DEVICE}3" /mnt

# Install only base package
pacstrap /mnt base

# Generate fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Copy dotfiles
cp -R dotfiles "/mnt"

# Run setup
arch-chroot /mnt bash -c "
  chown -R '$USER_NAME:users' dotfiles
  cd dotfiles
  ./arch_setup/setup.sh
  cd ..
  mv dotfiles '/home/$USER_NAME/'"

echo "Installation completed. You can reboot now."

