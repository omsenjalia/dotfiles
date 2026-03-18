#!/usr/bin/env bash
set -euo pipefail

APP_NAME="System"
NOTIFICATION_ICON="joystick"

if hyprctl getoption animations:enabled | grep -q "int: 0"; then
    # gamemode off — restore everything
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 4;\
        keyword general:gaps_out 9;\
        keyword general:border_size 2;\
        keyword decoration:rounding 4"
    notify-send -i "$NOTIFICATION_ICON" "$APP_NAME" "Gamemode deactivated — animations and blur restored."
else
    # gamemode on — strip everything for performance
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:active_opacity 1;\
        keyword decoration:inactive_opacity 1;\
        keyword decoration:rounding 0"
    notify-send -i "$NOTIFICATION_ICON" "$APP_NAME" "Gamemode activated — animations and blur disabled."
fi
