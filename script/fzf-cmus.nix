{pkgs}: ''
#!${pkgs.zsh}/bin/zsh

set -e

export var=$(cat << EOF
queue-next
play-now
clear-queue
play-next
play-prev
playlist-play
stop
repeat
shuffle
playlist-create
playlist-append
playlist-delete
EOF
)

# -------------------------------[ Get CMUS data ]--------------------------------

local function list_musics() {
	cmus-remote -C "save -l -"
}

local function list_playlists() {
	${pkgs.coreutils}/bin/ls -1 $XDG_CONFIG_HOME/cmus/playlists
}

# -----------------------------[ Select/Filter Data ]-----------------------------
local select_multi_music() {
	list_musics | fzf --delimiter='/' --with-nth=6 --multi
}

local select_single_music() {
	list_musics | fzf --delimiter='/' --with-nth=6 --no-multi
}

local select_playlist() {
	list_playlists | fzf --no-multi
}

local function handle() {
	local cmd=$1
	if [[ "$cmd" == "queue-next" ]]; then
		# We want to present all music to the user
		# And have him select the one he wants to play NEXT
		# Further, the user can select multiple songs
		# They will all be added to the "play next" queue
		# Then we sent it to cmus
		local musics=$(select_multi_music)
		for music in ''${(f)musics}; do
			cmus-remote -C "add -Q $music"
		done
		return
	fi

	if [[ "$cmd" == "play-now" ]]; then
		# We want to present all music to the user
		# And have him select the one he wants to play IMMEDIATELY
		# Then we sent it to cmus
		local music=$(select_single_music)
		[[ -z "$music" ]] && return
		cmus-remote -C "player-play $music"
		return
	fi

	if [[ "$cmd" == "playlist-play" ]]; then
		# We want to present all playlists to the user
		# And have him select the one he wants to play
		# Then we sent it to cmus
		local playlist=$(select_playlist)
		[[ -z "$playlist" ]] && return
		cmus-remote -C "view 3"
		cmus-remote -C "//$playlist"
		cmus-remote -C "win-activate"
		return
	fi

	if [[ "$cmd" == "playlist-create" ]]; then
		# We want to present all playlists to the user
		# And have him select the one he wants to play
		# Then we sent it to cmus
		local playlist
		vared -p "Playlist name: " playlist
		[[ -z "$playlist" ]] && return
		cmus-remote -C "pl-create $playlist"
		cmus-remote -C "save -p"
		return
	fi

	if [[ "$cmd" == "playlist-append" ]]; then
		# We want to present all music to the user
		# And have him select 1 or more music to to append to the playlist
		# Then we sent it to cmus
		local playlist=$(select_playlist)
		[[ -z "$playlist" ]] && return
		cmus-remote -C "view 3"
		cmus-remote -C "//$playlist"
		cmus-remote -C "win-toggle"
		local musics=$(select_multi_music)
		for music in ''${(f)musics}; do
			cmus-remote -C "add -p $music"
		done
		cmus-remote -C "save -p"
		return
	fi

	if [[ "$cmd" == "playlist-delete" ]]; then
		# We want to present all playlists to the user
		# And have him select the one he wants to play
		# Then we sent it to cmus
		local playlist=$(select_playlist)
		[[ -z "$playlist" ]] && return
		cmus-remote -C "pl-delete $playlist"
		return
	fi

	if [[ "$cmd" == "clear-queue" ]]; then
		# Clear the queue (which was populated from queue-next)
		cmus-remote -C "clear -q"
		return
	fi

	if [[ "$cmd" == "play-next" ]]; then
		cmus-remote -C "player-next"
	fi

	if [[ "$cmd" == "play-prev" ]]; then
		cmus-remote -C "player-prev"
	fi

	if [[ "$cmd" == "stop" ]]; then
		cmus-remote -C "player-stop"
		return
	fi

	if [[ "$cmd" == "repeat" ]]; then
		cmus-remote --repeat-current
		return
	fi

	if [[ "$cmd" == "shuffle" ]]; then
		cmus-remote --shuffle
		return
	fi

	echo "Not implemented yet"
}

local res=$(print $var | \
	fzf --preview='figlet -f slant -c {}' \
	--preview-window=up)
	
handle $res
''

