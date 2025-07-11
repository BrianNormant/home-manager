LOG_FILE=$XDG_STATE_HOME/instant-replay.log

timedatectl >> $LOG_FILE
exec gpu-screen-recorder \
	-w DP-1 \
	-c mp4 \
	-q high \
	-cursor yes \
	-a "app-inverse:Firefox|device:default_input" \
	-a "device:default_output|device:default_input" \
	-a "app-inverse:Firefox" \
	-a "device:default_output" \
	-a "device:default_input" \
	-r 60 \
	-restart-replay-on-save yes \
	-df yes \
	-sc /home/brian/.config/script/replay.sh \
	-v no \
	-o /home/brian/Videos \
	&>> $LOG_FILE
