#!/usr/bin/env bash

set -euo pipefail

# Extra commands after installing AUR packages

# Fresh install doesn't have this folder
mkdir -p "$HOME/.config"

# Install nodejs version and make the default
fnm install 14.10.1 && fnm default 14.10.1

