#!env zsh

local CMD=$1
local lines
local columns
local edge

# Default to 25 lines wide
if [[ -z $2 ]]; then
	lines=25
else
	lines=$2
end

# Default to 80 char wide
if [[ -z $3 ]]; then
	columns=80
else
	columns=$3
end

kitten panel \
	--layer=top \
	--edge=center-sized \
	--focus-policy=on-demand \
	--hide-on-focus-loss=yes \
	--single-instance=yes \
	--toggle-visibility=yes \
	--move-to-active-monitor=yes \
	--lines=$lines \
	--columns=$columns \
	"$CMD"
