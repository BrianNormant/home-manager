WALLPAPER_DIR=/home/brian/Wallpapers
WALLPAPER_CMD="swaybg -o * -m fill"

SELECTED=$(lsd -1 --classic $WALLPAPER_DIR | shuf -n 1)

${=WALLPAPER_CMD} -i "$WALLPAPER_DIR/$SELECTED"
