#!env zsh

CHANGE_TIMER=30s
NIRI_STOPPED=0

while [[ $NIRI_STOPPED -eq 0 ]]; do
	waypaper --random &> /dev/null
	sleep $CHANGE_TIMER
	systemctl --user --quiet is-active niri.service
	NIRI_STOPPED=$?
done
