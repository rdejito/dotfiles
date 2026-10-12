#!/bin/bash
STATUS=$(playerctl status 2>/dev/null)

if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then
    ARTIST=$(playerctl artist 2>/dev/null | head -c 15)
    TITLE=$(playerctl title 2>/dev/null | head -c 25)
    if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        echo "MUSIC: ${ARTIST}"
    elif [ -n "$TITLE" ]; then
        echo "MUSIC: ${TITLE}"
    else
        echo "MUSIC: PLAY"
    fi
else
    echo "MUSIC: IDLE"
fi
