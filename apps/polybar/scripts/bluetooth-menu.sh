#!/bin/bash
# Rofi-based Bluetooth picker for the Polybar Bluetooth module.
# Lists known devices (connected first) with a short MAC suffix so
# duplicate names are distinguishable, lets you connect/disconnect,
# rename a device's local alias, scan for new devices, or turn the
# adapter off.
#
# Note: renaming changes the *local* BlueZ alias only (the name this
# machine shows). The name a device broadcasts to everyone is set by
# its own firmware and cannot be changed from here.

set -u

THEME="$HOME/.config/rofi/cyberpunk-red.rasi"
PROMPT="Bluetooth"

if ! command -v bluetoothctl >/dev/null 2>&1; then
    echo "bluetoothctl not found" >&2
    exit 1
fi

# Desktop notification helper (dunst preferred, then notify-send).
if command -v dunstify >/dev/null 2>&1; then
    notify() { dunstify -a Bluetooth "$@"; }
elif command -v notify-send >/dev/null 2>&1; then
    notify() { notify-send -a Bluetooth "$@"; }
else
    notify() { :; }
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
declare -A DNAME=()   # mac -> display name (name + short MAC)
declare -A RALIAS=()  # mac -> raw alias (the editable name)

add_line() {
    LABELS+=("$1")
    ACTIONS+=("$2")
}

# Last two octets of a MAC ("41:42:B9:87:70:4D" -> "70:4D"), used to
# tell devices with identical names apart.
short_mac() {
    printf '%s' "${1: -5}"
}

# Human label for a device row: name plus short MAC.
display_name() {
    printf '%s  %s' "$2" "$(short_mac "$1")"
}

# Set the local alias (name) of a paired device over D-Bus.
set_alias() {
    local mac="$1" new="$2" path
    path=$(busctl tree org.bluez 2>/dev/null |
        grep -oE "/org/bluez/hci[0-9]+/dev_${mac//:/_}" | head -1)
    [ -z "$path" ] && return 1

    dbus-send --system --print-reply --dest=org.bluez "$path" \
        org.freedesktop.DBus.Properties.Set \
        string:org.bluez.Device1 string:Alias \
        variant:string:"$new" >/dev/null 2>&1
}

# --- Known devices (connected first) ---
declare -a C_LABEL=() C_ACTION=() O_LABEL=() O_ACTION=()

while read -r _ mac name; do
    [ -z "$mac" ] && continue
    [ -z "$name" ] && name="$mac"

    DNAME["$mac"]="$(display_name "$mac" "$name")"
    RALIAS["$mac"]="$name"

    state=$(bluetoothctl info "$mac" 2>/dev/null |
        sed -n 's/^[[:space:]]*Connected:[[:space:]]*//p')

    if [ "$state" = "yes" ]; then
        C_LABEL+=("󰂱  $(display_name "$mac" "$name")  ▸ connected")
        C_ACTION+=("disconnect $mac")
    else
        O_LABEL+=("󰂯  $(display_name "$mac" "$name")")
        O_ACTION+=("connect $mac")
    fi
done < <(bluetoothctl devices 2>/dev/null)

for i in "${!C_LABEL[@]}"; do add_line "${C_LABEL[$i]}" "${C_ACTION[$i]}"; done
for i in "${!O_LABEL[@]}"; do add_line "${O_LABEL[$i]}" "${O_ACTION[$i]}"; done

# --- Actions ---
add_line "󰏫  Rename a device…" "renamepick"
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
        name="${DNAME[$mac]:-$mac}"
        # -r 997 lets the result replace the "Connecting…" toast.
        notify -r 997 -u low "Connecting to ${name}…"
        bluetoothctl trust "$mac" >/dev/null 2>&1
        bluetoothctl pair "$mac" >/dev/null 2>&1
        bluetoothctl connect "$mac" >/dev/null 2>&1
        if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
            notify -r 997 -u normal "Connected to ${name}"
        else
            notify -r 997 -u critical "Failed to connect to ${name}"
        fi
        sleep 1
        exec "$0"
        ;;
    disconnect\ *)
        mac="${ACTION#disconnect }"
        name="${DNAME[$mac]:-$mac}"
        bluetoothctl disconnect "$mac" >/dev/null 2>&1
        notify -u normal "Disconnected ${name}"
        sleep 1
        exec "$0"
        ;;
    renamepick)
        pick=$(printf '%s\n' "${DNAME[@]}" |
            rofi -dmenu -i -p "Rename device" -theme "$THEME")
        [ -z "$pick" ] && exit 0

        mac=""
        for m in "${!DNAME[@]}"; do
            [ "${DNAME[$m]}" = "$pick" ] && mac="$m" && break
        done
        [ -z "$mac" ] && exit 0

        name="${DNAME[$mac]:-$mac}"
        # Label reads as a header and the input is its own field. Scoped to
        # this prompt only; the theme's listview (lines: 8) is collapsed so
        # the dialog fits a single-line input instead of an empty 8-row list.
        new=$(rofi -dmenu -p "New name for ${name}" \
            -theme "$THEME" \
            -theme-str 'listview { lines: 0; }
                inputbar { orientation: vertical; spacing: 10px; background-color: transparent; border: 0px; padding: 0px; }
                entry { background-color: #120b0e; border: 1px; border-color: #3a101b; padding: 10px; placeholder: "New name…"; }' \
            -filter "${RALIAS[$mac]:-}")
        [ -z "$new" ] && exit 0

        if set_alias "$mac" "$new"; then
            notify -u normal "Renamed ${name} to ${new}"
        else
            notify -u critical "Rename failed"
        fi
        sleep 1
        exec "$0"
        ;;
    scan)
        notify -u low -t 10000 "Scanning for devices (10s)…"
        bluetoothctl --timeout 10 scan on >/dev/null 2>&1
        exec "$0"
        ;;
    poweroff)
        bluetoothctl power off >/dev/null 2>&1
        ;;
esac
