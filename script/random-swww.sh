#!env zsh

CHANGE_TIMER=180s
NIRI_STOPPED=0

cd /home/brian/Wallpapers

while [[ $NIRI_STOPPED -eq 0 ]]; do
	SELECTED=$(lsd -1 --classic | shuf -n 1)
	swww img "$SELECTED"
	sleep $CHANGE_TIMER
	systemctl --user --quiet is-active niri.service
	NIRI_STOPPED=$?
done
