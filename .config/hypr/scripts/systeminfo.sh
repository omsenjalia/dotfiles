#!/usr/bin/env bash
set -euo pipefail
clear
figlet -f smslant "Systeminfo"
echo
setsid hyprctl systeminfo
echo
echo "Press return to exit"
read
