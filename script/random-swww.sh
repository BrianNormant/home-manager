WALLPAPER_DIR=/home/brian/Wallpapers
WALLPAPER_CMD="swww img"

SELECTED=$(lsd -1 --classic $WALLPAPER_DIR | shuf -n 1)

${=WALLPAPER_CMD} "$WALLPAPER_DIR/$SELECTED"
