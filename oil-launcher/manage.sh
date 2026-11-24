#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
APPLICATIONS_DIR="$DATA_HOME/applications"
DESKTOP_LINK="$APPLICATIONS_DIR/nvim-oil.desktop"
DBUS_SERVICES_DIR="$DATA_HOME/dbus-1/services"
DBUS_SERVICE="$DBUS_SERVICES_DIR/org.freedesktop.FileManager1.service"

if [ "$1" = "install" ]; then
	mkdir -p "$APPLICATIONS_DIR"
	mkdir -p "$DBUS_SERVICES_DIR"
	sed "s|@OIL_LAUNCHER@|$SCRIPT_DIR/nvim-oil|" "$SCRIPT_DIR/nvim-oil.desktop" > "$DESKTOP_LINK"
	cat > "$DBUS_SERVICE" <<EOF
[D-BUS Service]
Name=org.freedesktop.FileManager1
Exec=/usr/bin/env python3 $SCRIPT_DIR/file-manager.py
EOF
	gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.ReloadConfig >/dev/null
elif [ "$1" = "remove" ]; then
	if [ -f "$DESKTOP_LINK" ] || [ -L "$DESKTOP_LINK" ]; then
		rm "$DESKTOP_LINK"
	fi
	if [ -f "$DBUS_SERVICE" ]; then
		rm "$DBUS_SERVICE"
	fi
	gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.ReloadConfig >/dev/null
else
	echo "Usage: $0 install|remove"
	exit 1
fi
