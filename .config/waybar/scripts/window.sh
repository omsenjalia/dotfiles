#!/usr/bin/env bash
set -euo pipefail

title=$(hyprctl activewindow -j 2>/dev/null | jq -r '.title // ""' 2>/dev/null || echo "")

if [ -z "$title" ] || [ "$title" = "null" ]; then
  printf '{"text":""}\n'
else
  # Truncate to 40 chars
  short="${title:0:40}"
  [ ${#title} -gt 40 ] && short="${short}…"
  printf '{"text":"%s"}\n' "$short"
fi
