#!/bin/bash
LAYOUT=$(i3-msg -t get_mode 2>/dev/null | grep -oP '(?<="mode": ")[^"]*' || echo "default")
echo "TILE: ${LAYOUT}"
