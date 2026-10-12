#!/bin/bash
# Toggle battery/power actions
ACTION="$1"

case "$ACTION" in
    left)
        # Show power statistics
        upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E "percentage|state|voltage"
        ;;
    right)
        # Suspend or handle power
        systemctl suspend
        ;;
    middle)
        # Show power menu
        ~/.config/polybar/scripts/power-menu.sh
        ;;
esac
