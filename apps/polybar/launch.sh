#!/bin/sh

killall -q polybar

while pgrep -u "$UID" -x polybar >/dev/null; do
    sleep 1
done

for monitor in $(polybar --list-monitors | cut -d: -f1); do
    MONITOR="$monitor" polybar main &
done
