#!/bin/bash
# Toggle monitor/panel actions for cpu/memory clicks
ACTION="$1"

case "$ACTION" in
    left)
        # Focus previous workspace or launch task manager
        i3-msg "focus prev"
        ;;
    right)
        # Focus next workspace or launch system monitor
        i3-msg "focus next"
        ;;
    middle)
        # Launch htop for system monitoring
        kitty htop &
        ;;
esac
