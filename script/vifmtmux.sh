kitty tmux new-session vifm $(print "$1" | sed 's/file:\/\/\(.*\)/\1/' ) ~
