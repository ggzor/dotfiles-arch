#!/usr/bin/env bash

set -euo pipefail

# Extra commands after installing AUR packages

# Install nodejs version and make the default
NODE_VERSION=14.14.0
fnm install $NODE_VERSION \
  && fnm use $NODE_VERSION \
  && fnm default $NODE_VERSION

