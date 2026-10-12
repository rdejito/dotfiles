#!/bin/bash
discord_check=$(i3-msg -t get_tree 2>/dev/null | grep -i "discord" | head -1)
if [ -n "$discord_check" ]; then
    echo "APPS: DC"
else
    echo "APPS: -"
fi
