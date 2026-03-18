#!/usr/bin/env bash
set -euo pipefail
#     _    _ _  __ _             _
#    / \  | | |/ _| | ___   __ _| |_
#   / _ \ | | | |_| |/ _ \ / _` | __|
#  / ___ \| | |  _| | (_) | (_| | |_
# /_/   \_\_|_|_| |_|\___/ \__,_|\__|
#

hyprctl dispatch workspaceopt allfloat

# Notifications
source "$HOME/.config/ml4w/scripts/ml4w-notification-handler"

notify_user \
        --a "System" \
        --m "Windows on this workspace toggled to floating/tiling"
