{pkgs}: ''
#!${pkgs.zsh}/bin/zsh

# -------------------------------[ Get Niri Data ]--------------------------------

local function list_windows() {
	niri msg --json windows | jq -r '.[] | "\(.name) \(.id)"'
}

local function list_workspaces() {
	niri msg --json workspaces | jq -r '.[] | "\(.name) \(.id)"'
}

# -------------------------------[ User Selection ]-------------------------------

local function select_window() {
	list_windows | fzf --no-multi \
		--delimiter ' ' \
		--accept-nth "1" \
		--with-nth "2.."
}

local function handle() {
	local cmd=$1
	if [[ "$cmd" == "screenshot" ]]; then
		niri msg action screenshot
		return
	fi
	if [[ "$cmd" == "fake-fullscreen" ]]; then
		niri msg action toggle-windowed-fullscreen
		return
	fi
	if [[ "$cmd" == "focus-window" ]]; then
		local window_id=$(select_window)
		niri msg action focus-window "$window_id"
		return
	fi
	if [[ "$cmd" == "focus-column-first" ]]; then
		niri msg action focus-column-first
		return
	fi

	if [[ "$cmd" == "focus-column-last" ]]; then
		niri msg action focus-column-last
		return
	fi

	if [[ "$cmd" == "move-column-to-first" ]]; then
		niri msg action move-column-to-first
		return
	fi

	if [[ "$cmd" == "move-column-to-last" ]]; then
		niri msg action move-column-to-last
		return
	fi

	if [[ "$cmd" == "toggle-column-tabbed-display" ]]; then
		niri msg action toggle-column-tabbed-display
		return
	fi
	
	if [[ "$cmd" == "set-workspace-name" ]]; then
		local 
		local workspace_name=$(select_workspace)
		niri msg action set-workspace-name "$workspace_name"
		return
	fi
	
}

#   move-window-to-workspace
#           Move the focused window to a workspace by reference (index or name)
#   move-column-to-workspace
#           Move the focused column to a workspace by reference (index or name)
#   move-workspace-down
#           Move the focused workspace down
#   move-workspace-up
#           Move the focused workspace up
#   move-workspace-to-index
#           Move the focused workspace to a specific index on its monitor
#   set-workspace-name
#           Set the name of the focused workspace
#   unset-workspace-name
#           Unset the name of the focused workspace
#   focus-monitor-left
#           Focus the monitor to the left
#   focus-monitor-right
#           Focus the monitor to the right
#   focus-monitor-down
#           Focus the monitor below
#   focus-monitor-up
#           Focus the monitor above
#   focus-monitor-previous
#           Focus the previous monitor
#   focus-monitor-next
#           Focus the next monitor
#   focus-monitor
#           Focus a monitor by name
#   move-window-to-monitor-left
#           Move the focused window to the monitor to the left
#   move-window-to-monitor-right
#           Move the focused window to the monitor to the right
#   move-window-to-monitor-down
#           Move the focused window to the monitor below
#   move-window-to-monitor-up
#           Move the focused window to the monitor above
#   move-window-to-monitor-previous
#           Move the focused window to the previous monitor
#   move-window-to-monitor-next
#           Move the focused window to the next monitor
#   move-window-to-monitor
#           Move the focused window to a specific monitor
#   move-column-to-monitor-left
#           Move the focused column to the monitor to the left
#   move-column-to-monitor-right
#           Move the focused column to the monitor to the right
#   move-column-to-monitor-down
#           Move the focused column to the monitor below
#   move-column-to-monitor-up
#           Move the focused column to the monitor above
#   move-column-to-monitor-previous
#           Move the focused column to the previous monitor
#   move-column-to-monitor-next
#           Move the focused column to the next monitor
#   move-column-to-monitor
#           Move the focused column to a specific monitor
#   set-window-width
#           Change the width of the focused window
#   set-window-height
#           Change the height of the focused window
#   reset-window-height
#           Reset the height of the focused window back to automatic
#   switch-preset-column-width
#           Switch between preset column widths
#   switch-preset-column-width-back
#           Switch between preset column widths backwards
#   switch-preset-window-width
#           Switch between preset window widths
#   switch-preset-window-width-back
#           Switch between preset window widths backwards
#   switch-preset-window-height
#           Switch between preset window heights
#   switch-preset-window-height-back
#           Switch between preset window heights backwards
#   maximize-column
#           Toggle the maximized state of the focused column
#   maximize-window-to-edges
#           Toggle the maximized-to-edges state of the focused window
#   set-column-width
#           Change the width of the focused column
#   expand-column-to-available-width
#           Expand the focused column to space not taken up by other fully visible columns
#   switch-layout
#           Switch between keyboard layouts
#   show-hotkey-overlay
#           Show the hotkey overlay
#   move-workspace-to-monitor-left
#           Move the focused workspace to the monitor to the left
#   move-workspace-to-monitor-right
#           Move the focused workspace to the monitor to the right
#   move-workspace-to-monitor-down
#           Move the focused workspace to the monitor below
#   move-workspace-to-monitor-up
#           Move the focused workspace to the monitor above
#   move-workspace-to-monitor-previous
#           Move the focused workspace to the previous monitor
#   move-workspace-to-monitor-next
#           Move the focused workspace to the next monitor
#   move-workspace-to-monitor
#           Move the focused workspace to a specific monitor
#   toggle-debug-tint
#           Toggle a debug tint on windows
#   debug-toggle-opaque-regions
#           Toggle visualization of render element opaque regions
#   debug-toggle-damage
#           Toggle visualization of output damage
#   toggle-window-floating
#           Move the focused window between the floating and the tiling layout
#   move-window-to-floating
#           Move the focused window to the floating layout
#   move-window-to-tiling
#           Move the focused window to the tiling layout
#   focus-floating
#           Switches focus to the floating layout
#   focus-tiling
#           Switches focus to the tiling layout
#   switch-focus-between-floating-and-tiling
#           Toggles the focus between the floating and the tiling layout
#   move-floating-window
#           Move the floating window on screen
#   toggle-window-rule-opacity
#           Toggle the opacity of the focused window
#   set-dynamic-cast-window
#           Set the dynamic cast target to the focused window
#   set-dynamic-cast-monitor
#           Set the dynamic cast target to the focused monitor
#   clear-dynamic-cast-target
#           Clear the dynamic cast target, making it show nothing
#   toggle-overview
#           Toggle (open/close) the Overview
#   open-overview
#           Open the Overview
#   close-overview
#           Close the Overview
#   toggle-window-urgent
#           Toggle urgent status of a window
#   set-window-urgent
#           Set urgent status of a window
#   unset-window-urgent
#           Unset urgent status of a window
#   load-config-file
#           Reload the config file
#   help
#           Print this message or the help of the given subcommand(s)
#
# Options:
#   -h, --help  Print help
#
# ''
