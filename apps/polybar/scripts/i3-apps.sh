#!/bin/bash 

workspace=$(i3-msg -t get_workspaces |
    jq -r '.[] | select(.focused == true) | .name') 

apps=$(i3-msg -t get_tree |
    jq -r --arg ws "$workspace" '
        recurse(.nodes[]?, .floating_nodes[]?)
        | select(.type == "workspace" and .name == $ws) 
        | recurse(.nodes[]?, .floating_nodes[]?) 
        | select(.window != null) 
        | .window_properties.class 
    ' |
    sort -u |
    sed 's/^Brave-browser$/Brave/;
s/^com.mitchellh.ghostty$/Ghostty/; /^Polybar$/d' 
) 

first=true 

while IFS= read -r app; do
    if [ "$first" = true ]; then
        printf "%s" "$app"
        first=false
    else
        printf " • %s" "$app"
    fi
done <<< "$apps"

printf '\n'
