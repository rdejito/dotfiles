#!/usr/bin/env bash
#
# Adjust the laptop backlight without needing root or membership in `video`.
#
# Strategy:
#   1. Try `brightnessctl` (works when the user is in the `video` group).
#   2. Fall back to systemd-logind's SetBrightness over D-Bus, which is
#      authorised for the active session.
#
# Usage: brightness.sh up|down [percent]

set -euo pipefail

STEP="${2:-5}"

dev=""
for d in /sys/class/backlight/*; do
    [ -e "$d/brightness" ] || continue
    dev="${d##*/}"
    break
done
[ -n "$dev" ] || { echo "brightness.sh: no backlight device found" >&2; exit 1; }

max=$(cat "/sys/class/backlight/$dev/max_brightness")
cur=$(cat "/sys/class/backlight/$dev/brightness")
delta=$(( max * STEP / 100 ))
[ "$delta" -lt 1 ] && delta=1

case "${1:-}" in
    up)   new=$(( cur + delta )) ;;
    down) new=$(( cur - delta )) ;;
    *)    echo "usage: $0 up|down [percent]" >&2; exit 2 ;;
esac

[ "$new" -lt 1 ] && new=1
[ "$new" -gt "$max" ] && new="$max"

# 1) brightnessctl (needs write access to sysfs, i.e. membership in `video`).
if command -v brightnessctl >/dev/null 2>&1 && brightnessctl set "$new" >/dev/null 2>&1; then
    exit 0
fi

# 2) systemd-logind (authorised for the active session).
busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto \
    org.freedesktop.login1.Session SetBrightness \
    ssu backlight "$dev" "$new" >/dev/null
