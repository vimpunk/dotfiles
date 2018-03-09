#!/usr/bin/env bash

# Only create new instance if we don't already have one.
if ! xwininfo -name dropdown-terminal >/dev/null 2>&1; then
    termite --name dropdown-terminal --geometry=1362x370 --config=$XDG_CONFIG_HOME/termite/dropdown-config
fi

