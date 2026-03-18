#!/usr/bin/env bash
set -euo pipefail

time=$(date +"%I:%M %p")
date_str=$(date +"%a %d/%m")

printf '{"text":"%s  %s"}\n' "$time" "$date_str"
