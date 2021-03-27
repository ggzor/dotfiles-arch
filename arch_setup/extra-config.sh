#!/usr/bin/env bash
# Useful optional configuration

set -euo pipefail

print_help() {
	cat <<EOF
Usage: $0 CONFIGURATION_NAME
Apply the configuration with the given name.

Available configurations are:
  enable_touchpad_tap    enable touchpad tap (libinput/xorg)
EOF
}

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

if [[ "$#" == 0 ]]; then
	print_help "$0"
else
	case $1 in
		enable_touchpad_tap)
			enable_touchpad_tap
		;;
		*)
			echo "Unknown configuration: $1"
			print_help
		;;
	esac
fi
