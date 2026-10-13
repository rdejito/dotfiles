#!/bin/bash
# Select default audio sink (speaker) using rofi
# Also moves all currently playing audio streams to the selected sink

THEME="$HOME/.config/rofi/cyberpunk-red.rasi"

# Get sinks with friendly descriptions
# Output format: "description|sink_name"
current=$(pactl get-default-sink 2>/dev/null)

mapfile -t lines < <(pactl list sinks short 2>/dev/null)
sinks_list=""

for l in "${lines[@]}"; do
    sink_name=$(echo "$l" | awk '{print $2}')
    [ -z "$sink_name" ] && continue
    
    desc=$(python3 -c "
import subprocess
name='$sink_name'
p=subprocess.run(['pactl','list','sinks'], capture_output=True, text=True)
flag=False
for line in p.stdout.splitlines():
    if line.strip().startswith('Name:') and name in line:
        flag=True; continue
    if flag and line.strip().startswith('Name:'): break
    if flag and 'Description:' in line:
        print(line.split('Description:',1)[1].strip())
        break
" 2>/dev/null)
    
    # Clean up names to be readable
    desc=$(echo "$desc" | sed 's/Analog Stereo/Analog/g; s/Digital Stereo/Digital/g; s/  */ /g')
    
    # Add icon based on sink type
    icon=""
    combined="$sink_name$desc"
    if echo "$combined" | grep -qi bluetooth; then
        icon=""
    elif echo "$combined" | grep -qi hdmi; then
        icon=""
    elif echo "$combined" | grep -qi displayport; then
        icon=""
    elif echo "$combined" | grep -qi usb; then
        icon=""
    elif echo "$combined" | grep -qi headphone\|headset; then
        icon=""
    elif echo "$combined" | grep -qi speaker\|laptop\|internal\|pci; then
        icon=""
    fi
    
    if [ -z "$desc" ]; then
        desc="Audio Output"
    fi
    
    # Mark currently active sink
    if [ "$sink_name" = "$current" ]; then
        sinks_list+=$'● '"$icon $desc|$sink_name"$'\n'
    else
        sinks_list+=$'  '"$icon $desc|$sink_name"$'\n'
    fi
done

[ -z "$sinks_list" ] && exit 0

# Show menu with rofi
res=$(printf "%s" "$sinks_list" | rofi -dmenu -i -p "Select speaker" -theme "$THEME")
choice=$(echo "$res" | awk -F'|' '{print $2}')

[ -z "$choice" ] && exit 0

# Set default sink
pactl set-default-sink "$choice" 2>/dev/null

# Move all current sink inputs (playing streams) to the selected sink
pactl list sink-inputs short 2>/dev/null | while IFS= read -r line; do
    input_id=$(echo "$line" | awk '{print $1}')
    [ -n "$input_id" ] && pactl move-sink-input "$input_id" "$choice" 2>/dev/null
done
