#!/bin/bash
# Rofi-based Bluetooth picker for the Polybar Bluetooth module.
# Lists known devices (connected first), lets you connect/disconnect,
# scan for new devices, or turn the adapter off.

set -u

THEME="$HOME/.config/rofi/cyberpunk-red.rasi"
PROMPT="Bluetooth"

if ! command -v bluetoothctl >/dev/null 2>&1; then
    echo "bluetoothctl not found" >&2
    exit 1
fi

# Make sure the adapter is powered (and not soft-blocked).
if command -v rfkill >/dev/null 2>&1; then
    rfkill unblock bluetooth 2>/dev/null
fi

if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    bluetoothctl power on >/dev/null 2>&1
    sleep 1
fi

declare -a LABELS=()
declare -a ACTIONS=()

add_line() {
    LABELS+=("$1")
    ACTIONS+=("$2")
}

# --- Known devices (connected first) ---
connected=""
others=""

while read -r _ mac name; do
    [ -z "$mac" ] && continue
    [ -z "$name" ] && name="$mac"

    state=$(bluetoothctl info "$mac" 2>/dev/null |
        sed -n 's/^[[:space:]]*Connected:[[:space:]]*//p')

    if [ "$state" = "yes" ]; then
        connected+="󰂱  ${name}  (connected)	disconnect ${mac}\n"
    else
        others+="󰂯  ${name}	connect ${mac}\n"
    fi
done < <(bluetoothctl devices 2>/dev/null)

while IFS=$'\t' read -r label action; do
    [ -z "$label" ] && continue
    add_line "$label" "$action"
done < <(printf '%b' "$connected$others")

# --- Actions ---
add_line "󰑓  Scan for devices" "scan"
add_line "󰅙  Turn Bluetooth off" "poweroff"

# --- Menu ---
CHOICE=$(printf '%s\n' "${LABELS[@]}" |
    rofi -dmenu -i -p "$PROMPT" -theme "$THEME")
[ -z "$CHOICE" ] && exit 0

ACTION=""
for i in "${!LABELS[@]}"; do
    if [ "${LABELS[$i]}" = "$CHOICE" ]; then
        ACTION="${ACTIONS[$i]}"
        break
    fi
done
[ -z "$ACTION" ] && exit 0

case "$ACTION" in
    connect\ *)
        mac="${ACTION#connect }"
        bluetoothctl trust "$mac" >/dev/null 2>&1
        bluetoothctl pair "$mac" >/dev/null 2>&1
        bluetoothctl connect "$mac" >/dev/null 2>&1
        ;;
    disconnect\ *)
        mac="${ACTION#disconnect }"
        bluetoothctl disconnect "$mac" >/dev/null 2>&1
        ;;
    scan)
        bluetoothctl --timeout 10 scan on >/dev/null 2>&1
        exec "$0"
        ;;
    poweroff)
        bluetoothctl power off >/dev/null 2>&1
        ;;
esac
