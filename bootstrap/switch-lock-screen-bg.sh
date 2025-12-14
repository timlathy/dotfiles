#!/usr/bin/env sh

# Requires https://github.com/sunwxg/gnome-shell-extension-unlockDialogBackground

# Example usage:
# crontab -e
# */15 * * * * /path/to/switch-lock-screen-bg.sh

WALLPAPER_DIR=~/Pictures/Wallpapers
LRU_WALLPAPER="$WALLPAPER_DIR/$(ls -tr $WALLPAPER_DIR | grep -E "(png|jpg)$" | head -n 1)"
BGEXT_SCHEMADIR=~/.local/share/gnome-shell/extensions/unlockDialogBackground@sun.wxg@gmail.com/schemas

touch "$LRU_WALLPAPER"

gsettings set org.gnome.desktop.screensaver picture-uri "$LRU_WALLPAPER"
gsettings --schemadir $BGEXT_SCHEMADIR \
  set org.gnome.shell.extensions.unlockDialogBackground picture-uri "$LRU_WALLPAPER"
