#!/bin/bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

if [[ -f $XDG_CONFIG_HOME/chrome-flags.conf ]]; then
    CHROME_USER_FLAGS="$(grep -v '^#' $XDG_CONFIG_HOME/chrome-flags.conf)"
fi

exec /opt/google/chrome/google-chrome $CHROME_USER_FLAGS "$@"