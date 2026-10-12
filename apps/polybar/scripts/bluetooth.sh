#!/bin/bash
# Polybar Bluetooth label: icon + adapter state / connected device.

OFF_FG="%{F#8f737b}"
ON_FG="%{F#00FFFF}"
RESET="%{F-}"

if ! command -v bluetoothctl >/dev/null 2>&1; then
    echo "${OFF_FG}󰂲 N/A${RESET}"
    exit 0
fi

POWERED=$(bluetoothctl show 2>/dev/null |
    sed -n 's/^[[:space:]]*Powered:[[:space:]]*//p')

if [ "$POWERED" != "yes" ]; then
    echo "${OFF_FG}󰂲 BT OFF${RESET}"
    exit 0
fi

DEVICE=$(bluetoothctl devices Connected 2>/dev/null | head -1)

if [ -n "$DEVICE" ]; then
    NAME=$(echo "$DEVICE" | sed -E 's/^Device [0-9A-Fa-f:]+ //')
    echo "${ON_FG}󰂱 ${NAME}${RESET}"
else
    echo "${ON_FG}󰂯 BT ON${RESET}"
fi
