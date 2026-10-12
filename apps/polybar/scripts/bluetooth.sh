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
    MAC=$(echo "$DEVICE" | awk '{print $2}')
    NAME=$(echo "$DEVICE" | sed -E 's/^Device [0-9A-Fa-f:]+ //')

    # BlueZ exposes e.g. "Battery Percentage: 0x3c (60)" when the device
    # reports battery (HID / Battery Service). Not all devices do.
    BATTERY=$(bluetoothctl info "$MAC" 2>/dev/null |
        sed -n 's/.*Battery Percentage: 0x[0-9A-Fa-f]* (\([0-9]*\)).*/\1/p' |
        head -1)

    if [ -n "$BATTERY" ]; then
        BATT_FG="$ON_FG"
        if [ "$BATTERY" -lt 20 ]; then
            BATT_FG="%{F#ff1744}"
        elif [ "$BATTERY" -lt 50 ]; then
            BATT_FG="%{F#ff7144}"
        fi

        # 10-step battery glyph (󰁺 empty -> 󰂄 full)
        case "$BATTERY" in
            9?) ICON="󰂃" ;;
            7?) ICON="󰂂" ;;
            6?) ICON="󰂀" ;;
            5?) ICON="󰁿" ;;
            4?) ICON="󰁾" ;;
            3?) ICON="󰁽" ;;
            2?) ICON="󰁼" ;;
            1?) ICON="󰁻" ;;
            *)  ICON="󰁺" ;;
        esac
        [ "$BATTERY" = "100" ] && ICON="󰂄"

        echo "${ON_FG}󰂱 ${NAME}  ${BATT_FG}${ICON}${BATTERY}%${RESET}"
    else
        echo "${ON_FG}󰂱 ${NAME}${RESET}"
    fi
else
    echo "${ON_FG}󰂯 BT ON${RESET}"
fi
