#!/usr/bin/env bash

set -euo pipefail

# Extra commands after installing AUR packages

# Install nodejs version and make the default
fnm install 14.10.1 && fnm default 14.10.1

