#!/usr/bin/env bash

# Load packages from list
PACKAGES=$(cat './arch_setup/packages.txt' | sed '/^$/d' | grep -v '^#' | tr '\n' ' ')

# Install packages
pacman -S --noconfirm $PACKAGES

# Run extra install commands
./arch_setup/packages.sh

