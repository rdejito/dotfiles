#!/usr/bin/env bash

# Configure the dual-monitor layout for i3.
# HDMI-0: primary display on the left.
# eDP-1-1: laptop display on the right.

set -e

if xrandr --query | grep -q '^HDMI-0 connected'; then
    xrandr \
        --output HDMI-0 --primary --auto --pos 0x0 \
        --output eDP-1-1 --auto --right-of HDMI-0
else
    # Fall back to the laptop display if HDMI is disconnected.
    xrandr --output eDP-1-1 --primary --auto
fi