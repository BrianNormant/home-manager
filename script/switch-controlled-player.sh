#!env zsh

typeset -A all_players=()

# get all players from playerctl
# and put em in a list
i=1
for p in `env playerctl -l`; do
	all_players[$i]=$p
	i=$(( i + 1 ))
done


if [[ ${#all_players} == 0 ]]; then
	systemctl --user unset-environment CURRENT_PLAYER
	notify-send "No player selected"
    echo "notify"
	exit
fi

eval `systemctl --user show-environment | grep CURRENT_PLAYER`


if [[ -z $CURRENT_PLAYER ]]; then
	CURRENT_PLAYER=$all_players[1]
	notify-send "selected $CURRENT_PLAYER"
    echo "notify"
	systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
	exit;
fi

if [[ ${#all_players} == 1 ]]; then
	CURRENT_PLAYER=$all_players[1]
	notify-send "selected $CURRENT_PLAYER"
    echo "notify"
	systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
	exit;
fi


for i p in ${(kv)all_players}; do
	if [[ $p == $CURRENT_PLAYER ]]; then
		if [[ $i == ${#all_players} ]]; then
			CURRENT_PLAYER=$all_players[1]
			systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
            notify-send "selected $CURRENT_PLAYER"
            echo "notify"
			exit
		else
			i=$(( i + 1 ))
			CURRENT_PLAYER=$all_players[$i]
			systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
            notify-send "selected $current_player"
            echo "notify"
			exit
		fi
	fi
done

CURRENT_PLAYER=$all_players[0]
systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
notify-send "selected $current_player"
echo "notify"
exit;
