#!/bin/bash
# Rofi-based Wi-Fi picker for the Polybar network module.
# Lists available access points and saved networks, lets you connect or
# disconnect, scan for networks, or turn the Wi-Fi radio off (via nmcli).

set -u

THEME="$HOME/.config/rofi/cyberpunk-red.rasi"
PROMPT="Wi-Fi"

if ! command -v nmcli >/dev/null 2>&1; then
    echo "nmcli not found" >&2
    exit 1
fi

# Make sure the radio is powered (and not soft-blocked).
if command -v rfkill >/dev/null 2>&1; then
    rfkill unblock wifi 2>/dev/null
fi

if [ "$(nmcli -t -f WIFI general 2>/dev/null)" != "enabled" ]; then
    nmcli radio wifi on >/dev/null 2>&1
    sleep 1
fi

declare -a LABELS=()
declare -a ACTIONS=()

add_line() {
    LABELS+=("$1")
    ACTIONS+=("$2")
}

# nmcli escapes ':' inside values as '\:'; undo that for display/selection.
unescape_ssid() {
    printf '%s' "${1//\\:/:}"
}

# Currently connected Wi-Fi network (may be empty).
CURRENT=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null |
    sed -n 's/^yes://p' | head -1)

# --- Available access points (strongest first) ---
# SSID is the last field so any escaped colons land in the same read variable.
declare -A SEEN=()

while IFS=: read -r inuse signal security ssid; do
    [ -z "$ssid" ] && continue
    ssid=$(unescape_ssid "$ssid")
    [ -n "${SEEN[$ssid]:-}" ] && continue
    SEEN[$ssid]=1

    if [ "$signal" -ge 75 ]; then
        icon="󰤨"
    elif [ "$signal" -ge 50 ]; then
        icon="󰤥"
    elif [ "$signal" -ge 25 ]; then
        icon="󰤢"
    else
        icon="󰤟"
    fi

    lock=""
    if [ -n "$security" ] && [ "$security" != "--" ]; then
        lock="󰌾"
    fi

    if [ "$inuse" = "*" ] || [ "$ssid" = "$CURRENT" ]; then
        add_line "$icon  $ssid  ${signal}%  $lock (connected)" "disconnect	$ssid"
    else
        add_line "$icon  $ssid  ${signal}%  $lock" "connect	$ssid	$security"
    fi
done < <(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID dev wifi list --rescan no 2>/dev/null |
    sort -t: -k2 -rn)

# --- Saved networks that are not currently active ---
while IFS=: read -r name type device; do
    [ "$type" = "802-11-wireless" ] || continue
    [ -z "$device" ] || continue
    [ "$name" = "$CURRENT" ] && continue
    add_line "󰌘  $name  (saved)" "up	$name"
done < <(nmcli -t -f NAME,TYPE,DEVICE con show 2>/dev/null)

# --- Actions ---
add_line "󰑓  Scan for networks" "scan"
add_line "󰅙  Turn Wi-Fi off" "poweroff"

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
    connect$'\t'*)
        IFS=$'\t' read -r _ ssid security <<< "$ACTION"
        if nmcli -t -f NAME,TYPE con show 2>/dev/null |
            grep -qxF "$ssid:802-11-wireless"; then
            # Already saved: just bring the profile up.
            nmcli con up id "$ssid" >/dev/null 2>&1
        elif [ -n "$security" ] && [ "$security" != "--" ]; then
            pw=$(rofi -dmenu -password -p "$ssid password" -theme "$THEME")
            [ -z "$pw" ] && exit 0
            nmcli dev wifi connect "$ssid" password "$pw" >/dev/null 2>&1
        else
            nmcli dev wifi connect "$ssid" >/dev/null 2>&1
        fi
        ;;
    disconnect$'\t'*)
        ssid="${ACTION#*$'\t'}"
        nmcli con down id "$ssid" >/dev/null 2>&1
        ;;
    up$'\t'*)
        name="${ACTION#*$'\t'}"
        nmcli con up id "$name" >/dev/null 2>&1
        ;;
    scan)
        nmcli dev wifi rescan >/dev/null 2>&1
        sleep 2
        exec "$0"
        ;;
    poweroff)
        nmcli radio wifi off >/dev/null 2>&1
        ;;
esac
