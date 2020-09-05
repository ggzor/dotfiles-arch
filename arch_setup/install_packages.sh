#!/usr/bin/env bash

# Load packages from list
PACKAGES=$(cat './packages.txt' | sed '/^$/d' | grep -v '^#' | tr '\n' ' ')

# Install packages
pacman -S --noconfirm $PACKAGES

# Run extra install commands
./packages.sh

