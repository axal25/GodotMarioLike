#!/bin/sh
echo -ne '\033c\033]0;FirstGame\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/FirstGame.x86_64" "$@"
