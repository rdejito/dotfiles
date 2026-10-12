#!/bin/bash

# Auto-detect the Wi-Fi interface reported by NetworkManager, falling back
# to a sane default if detection fails.
INTERFACE=$(nmcli -t -f DEVICE,TYPE device 2>/dev/null |
    sed -n 's/^\([^:]*\):wifi$/\1/p' | head -1)
[ -n "$INTERFACE" ] || INTERFACE="wlan0"

CACHE="/tmp/polybar-network-$INTERFACE"

# Get connection name from NetworkManager
SSID=$(nmcli -t -f GENERAL.CONNECTION device show "$INTERFACE" |
    sed 's/^GENERAL.CONNECTION://')

# Get Wi-Fi information from iwconfig
INFO=$(iwconfig "$INTERFACE" 2>/dev/null)

# Signal percentage
QUALITY=$(echo "$INFO" |
    sed -n 's/.*Link Quality=\([0-9]*\)\/\([0-9]*\).*/\1 \2/p')

if [ -n "$QUALITY" ]; then
    read CURRENT MAX <<< "$QUALITY"
    SIGNAL=$((CURRENT * 100 / MAX))
else
    SIGNAL=0
fi

# Link speed
SPEED=$(echo "$INFO" |
    sed -n 's/.*Bit Rate=\([0-9.]*\) \([^ ]*\).*/\1\2/p')

# Convert link speed to compact format
SPEED=$(echo "$SPEED" | sed 's/Mb\/s/M/;s/Mbit\/s/M/')

# Network traffic counters
RX_FILE="/sys/class/net/$INTERFACE/statistics/rx_bytes"
TX_FILE="/sys/class/net/$INTERFACE/statistics/tx_bytes"

RX=$(cat "$RX_FILE" 2>/dev/null || echo 0)
TX=$(cat "$TX_FILE" 2>/dev/null || echo 0)
NOW=$(date +%s%N)

if [ -f "$CACHE" ]; then
    read OLD_RX OLD_TX OLD_TIME < "$CACHE"
else
    OLD_RX=$RX
    OLD_TX=$TX
    OLD_TIME=$NOW
fi

ELAPSED=$(awk "BEGIN {print ($NOW - $OLD_TIME) / 1000000000}")

if awk "BEGIN {exit !($ELAPSED > 0)}"; then
    RX_RATE=$(awk "BEGIN {printf \"%.0f\", ($RX - $OLD_RX) / $ELAPSED}")
    TX_RATE=$(awk "BEGIN {printf \"%.0f\", ($TX - $OLD_TX) / $ELAPSED}")
else
    RX_RATE=0
    TX_RATE=0
fi

echo "$RX $TX $NOW" > "$CACHE"

# Format traffic speed
format_speed() {
    local SPEED=$1

    if [ "$SPEED" -ge 1048576 ]; then
        awk "BEGIN {printf \"%.1fM\", $SPEED / 1048576}"
    elif [ "$SPEED" -ge 1024 ]; then
        awk "BEGIN {printf \"%.0fK\", $SPEED / 1024}"
    else
        echo "${SPEED}B"
    fi
}

RX_DISPLAY=$(format_speed "$RX_RATE")
TX_DISPLAY=$(format_speed "$TX_RATE")

# Wi-Fi icon
if [ "$SIGNAL" -ge 80 ]; then
    ICON="󰤨"
elif [ "$SIGNAL" -ge 60 ]; then
    ICON="󰤥"
elif [ "$SIGNAL" -ge 40 ]; then
    ICON="󰤢"
elif [ "$SIGNAL" -ge 20 ]; then
    ICON="󰤟"
elif [ "$SIGNAL" -gt 0 ]; then
    ICON="󰤯"
else
    ICON="󰤮"
fi

# Shorten SSID
if [ ${#SSID} -gt 4 ]; then
    SSID="${SSID:0:4}…"
fi

# Output
if [ -z "$SSID" ] || [ "$SSID" = "--" ]; then
    echo "󰤮 Disconnected"
else
    echo "$ICON $SSID $SPEED ↓$RX_DISPLAY ↑$TX_DISPLAY"
fi
