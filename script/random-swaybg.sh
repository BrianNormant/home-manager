WALLPAPER_DIR=/home/brian/Wallpapers
WALLPAPER_CMD="swaybg -o * -m fill"
# cleanup any existing swaybg instances
pkill swaybg

SELECTED=$(lsd -1 --classic $WALLPAPER_DIR | shuf -n 1)

${=WALLPAPER_CMD} -i "$WALLPAPER_DIR/$SELECTED"
