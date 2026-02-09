{pkgs}: ''
#!${pkgs.zsh}/bin/zsh

local function switch_wallpaper() {
	local cmd=$1
	# This command can run for a while, we put it in background
	find $HOME/Wallpapers/.Videos -name "*.gif" -type f \
		| fzf --no-multi -i \
		| xargs $cmd img &!
}

local function main() {
	case $1 in
		switch-wallpaper)
			switch_wallpaper awww
			;;
		switch-wallpaper-overview)
			switch_wallpaper swww
			;;
		pause)
			awww pause
			swww pause
		**)
			echo "Not implemented"
			;;
	esac
}

local cmds=$(cat << EOF
switch-wallpaper
switch-wallpaper-overview
EOF
)

local res=$(print $cmds | fzf --no-multi -i)
main $res

''
