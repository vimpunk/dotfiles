#!/usr/bin/env bash

screen_width=$(($(xrandr | grep '\bconnected\b' | awk '{ print $3 }' | sed 's/+0+0//g' | cut -d'x' -f 1)-4))

# Only create new instance if we don't already have one.
if ! xwininfo -name dropdown-terminal >/dev/null 2>&1; then
    termite --name dropdown-terminal --geometry=${screen_width}x370 --config=$XDG_CONFIG_HOME/termite/dropdown-config
fi

