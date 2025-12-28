{pkgs}: ''
#!${pkgs.zsh}/bin/zsh

set -e

local function pages() {
	man -k . | fzf \
		--delimiter=' - ' \
		--nth=1 \
		--accept-nth=1 \
		--preview-window=up \
		--preview='echo {1} | xargs man -P ov'
}

local page=$(pages)
[[ -n "$page" ]] && man ''${=page}

''
