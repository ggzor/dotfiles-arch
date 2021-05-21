#!/usr/bin/env bash
# Useful optional configuration

set -euo pipefail

# Enable touchpad tap using configuration file
enable_touchpad_tap() {
  content=\
'Section "InputClass"
	Identifier "touchpad"
	Driver "libinput"
	MatchIsTouchpad "on"
	Option "Tapping" "on"
EndSection'

  echo "Writing configuration file..."
  sudo bash -c "echo '$content' > /etc/X11/xorg.conf.d/30-touchpad.conf"
  echo "Done"
	echo "Restart the X server to finish configuration"
}

refind_custom() {
	REFIND_CONF_DIR='/efi/EFI/refind'
	REFIND_CONF_FILE="${REFIND_CONF_DIR}/refind.conf"
	REFIND_THEME_DIR='arch_setup/extra/refind'

	if [[ ! -d "$REFIND_THEME_DIR" ]]; then
		echo "You must run this script from inside the dotfiles/ dir!"
		exit 1
	fi

	echo "Installing custom refind configuration..."
	if [[ -f "$REFIND_CONF_FILE" ]]; then
		echo "Creating refind.conf.backup..."
		sudo cp "$REFIND_CONF_FILE" "${REFIND_CONF_FILE}.backup"
	fi

	echo "Copying files..."
	sudo cp "${REFIND_THEME_DIR}/refind.conf" "$REFIND_CONF_FILE"
	sudo cp -r "${REFIND_THEME_DIR}/assets" "$REFIND_CONF_DIR"
	echo "Changing files ownership..."
	sudo chown root "$REFIND_CONF_FILE"
	sudo chown -R root "${REFIND_CONF_DIR}/assets"
	echo "Done!"
}

declare -A OPTIONS
OPTIONS=(
	[enable_touchpad_tap]='Enable touchpad tap'
	[refind_custom]='Install custom refind styles'
)

print_help() {
	cat <<EOF
Usage: $0 CONFIGURATION_NAME
Apply the configuration with the given name.

Available configurations are:
EOF

	for configuration in "${!OPTIONS[@]}"; do
		printf '  %-20s %s\n' "$configuration" "${OPTIONS[$configuration]}"
	done

	exit 1
}

if [[ "$#" == 0 ]]; then
	print_help "$0"
else
	if [[ ${OPTIONS[$1]+abc} ]]; then
		"$1"
	else
		echo "Unknown configuration: $1"
		print_help
	fi
fi
