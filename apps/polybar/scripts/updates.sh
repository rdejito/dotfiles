#!/bin/bash

# Check cached APT package lists without running apt update
UPDATES=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)
UPDATES=${UPDATES//[[:space:]]/}

# Hide the module when there are no updates
if [ "$UPDATES" -gt 0 ]; then
    echo "󰏗 $UPDATES"
fi
