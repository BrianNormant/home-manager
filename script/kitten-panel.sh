#!/run/current-system/sw/bin/zsh

local CMD=$1
local lines
local columns
local edge

# Default to 25 lines wide
if [[ -z $2 ]]; then
	lines=25
else
	lines=$2
fi

# Default to 80 char wide
if [[ -z $3 ]]; then
	columns=80
else
	columns=$3
fi

kitten panel \
	--layer=top \
	--edge=center-sized \
	--focus-policy=on-demand \
	--hide-on-focus-loss=yes \
	--single-instance=yes \
	--toggle-visibility=yes \
	--move-to-active-monitor=yes \
	--instance-group="$CMD" \
	--lines=$lines \
	--columns=$columns \
	"${=CMD}"
