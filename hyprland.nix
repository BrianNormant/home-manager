{pkgs, hostname}: {
	enable = true;
	systemd.enable = true;
	systemd.extraCommands = [ ];

	plugins = with pkgs.hyprlandPlugins; [
		hyprscroller
		hyprexpo
	];
	settings = {

		exec-once = [
			"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
			"systemctl --user start hyprpolkitagent.service"
			"systemctl --user start hyprpanel.service"
			"systemctl --user start copyq.service"
			"systemctl --user start hyprpaper.service"
			"systemctl --user start nm-applet.service"
			"systemctl --user start waypaper.timer"
			"systemctl --user start hypridle.service"
			"systemctl --user start steam.service"
			"systemctl --user start discord.service"
			"systemctl --user start corectrl.service"
			"gpu-screen-recorder -a $(wpctl inspect @DEFAULT_AUDIO_SINK@ | grep \"node.name\" | sed -E 's/\\s*\\*?\\s*node.name = \"([A-Za-z0-9_.-]+)\"/\\1/').monitor -w DP-1 -f 60 -r 30 -c mp4 -o /home/brian/Videos -sc ~/.config/script/replay.sh &> /dev/null"
		];
		input = {
			kb_layout = "us,us";
			kb_variant = ",intl";
			kb_options = "grp:shifts_toggle";
			# scroll_button = 274;
			follow_mouse = 1;

			touchpad.tap-and-drag = 0;
			touchpad.natural_scroll = false;

			numlock_by_default = true;
		};

		general = {
			layout = "scroller";
			gaps_in = 3;
			gaps_out = 5;
			border_size = 2;
			allow_tearing = false;

			"col.active_border" = "rgb(d80032)";
			"col.inactive_border" = "rgb(8d99ae)";
		};

		# decoration = {
		# 	rounding = 10;
		# 	blur = {
		# 		enabled = true;
		# 		size = 3;
		# 		passes = 1;
		# 		special = false;
		# 	};
		#
		# 	drop_shadow = true;
		# 	shadow_range = 4;
		# 	shadow_render_power = 3;
		# 	"col.shadow" = "rgba(1a1a1aee)";
		# };
		#

		windowrulev2 = [
			"float, class:(ProcessManager)"
			"size 70% 70%, class:(ProcessManager)"
			"center, class:(ProcessManager)"

			"float, class:(Explorer)"
			"size 75% 60%, class:(Explorer)"
			"center, class:(Explorer)"

			"float, class:(PopUp)"
			"size 40% 80%, class:(PopUp)"
			"center, class:(PopUp)"

			"float, class:(com.github.hluk.copyq)"
			"size 20% 20%, class:(com.github.hluk.copyq)"
			"move 71% 5%, class:(com.github.hluk.copyq)"

			"float, title:(Picture-in-Picture)"
			"move 73% 4%, title:(Picture-in-Picture)"
			"keepaspectratio, title:(Picture-in-Picture)"
			"pin, title:(Picture-in-Picture)"

			"float, title:(reStream)"
			"keepaspectratio, title:(reStream)"
			"size 90% 90%, title:(reStream)"
			"center, title:(reStream)"

			"idleinhibit fullscreen, fullscreen:1"
			"immediate, class:(gamescope)"
		];
	};


	extraConfig = ''
env = QT_QPA_PLATFORMTHEME,lxqt
env = QT_PLATFORM_PLUGIN,lxqt
env = XDG_MENU_PREFIX,lxqt-

#animations {
#	enabled = true
#	bezier = myBezier, 0.05, 0.9, 0.1, 1.05
#
#	animation = windows, 1, 7, myBezier # Open window
#	animation = windowsOut, 1, 7, default, popin 50% # close window
#	animation = border, 1, 10, default # ?
#	animation = borderangle, 1, 8, default # ?
#	animation = fade, 1, 7, default # ?
#	animation = workspaces, 1, 6, default, slide
#	animation = specialWorkspace, 1, 6, default, slidevert
#}

misc {
	mouse_move_enables_dpms = true
	key_press_enables_dpms = true
}


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
# ------------------------ System Navigation
bind = $mainMod, Q, killactive,
bind = $mainMod SHIFT, Q, exit
bind = $mainMod, Space, togglefloating # Set floating/layout
bind = $mainMod, F, fullscreen

# Resize window
bind = $mainMod ALT, left, resizeactive, -5% 0%
bind = $mainMod ALT, up, resizeactive, 0% -5%
bind = $mainMod ALT, right, resizeactive, 5% 0%
bind = $mainMod ALT, down, resizeactive, 0% 5%

# Scratchpad
bind = $mainMod, N, movetoworkspacesilent, special
bind = $mainMod ALT, N, togglespecialworkspace

# Layout manipulation
bind = $mainMod, p, scroller:pin
bind = $mainMod, r, scroller:cyclesize, next
bind = $mainMod, z, scroller:setmode, r
bind = $mainMod, x, scroller:setmode, c
bind = $mainMod, c, scroller:alignwindow, center
bind = $mainMod SHIFT, X, scroller:alignwindow, r
bind = $mainMod SHIFT, Z, scroller:alignwindow, l
bind = $mainMod, bracketleft, scroller:admitwindow
bind = $mainMod, bracketright, scroller:expelwindow
# Move focus with mainMod + arrow keys
bind = $mainMod, left, scroller:movefocus, l
bind = $mainMod, right, scroller:movefocus, r
bind = $mainMod, mouse_up, scroller:movefocus, l
bind = $mainMod, mouse_down, scroller:movefocus, r
bind = $mainMod, up, scroller:movefocus, u
bind = $mainMod, down, scroller:movefocus, d
# Move current window with mainMod + arrow keys
bind = $mainMod SHIFT, left, scroller:movewindow, l
bind = $mainMod SHIFT, right, scroller:movewindow, r
bind = $mainMod SHIFT, up, scroller:movewindow, u
bind = $mainMod SHIFT, down, scroller:movewindow, d
bind = $mainMod SHIFT, grave, scroller:fitsize, visible

# Move between workspace
bind = $mainMod, Next, workspace, +1
bind = $mainMod, Prior, workspace, -1

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10
# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10
# Move active window to workspace silent
bind = $mainMod CONTROL, 1, movetoworkspacesilent, 1
bind = $mainMod CONTROL, 2, movetoworkspacesilent, 2
bind = $mainMod CONTROL, 3, movetoworkspacesilent, 3
bind = $mainMod CONTROL, 4, movetoworkspacesilent, 4
bind = $mainMod CONTROL, 5, movetoworkspacesilent, 5
bind = $mainMod CONTROL, 6, movetoworkspacesilent, 6
bind = $mainMod CONTROL, 7, movetoworkspacesilent, 7
bind = $mainMod CONTROL, 8, movetoworkspacesilent, 8
bind = $mainMod CONTROL, 9, movetoworkspacesilent, 9
bind = $mainMod CONTROL, 0, movetoworkspacesilent, 10
# Pin active window to a workspace with mainMod + ALT + [0-9]
bind = $mainMod ALT, 1, scroller:setsize, 0
bind = $mainMod ALT, 2, scroller:setsize, 1
bind = $mainMod ALT, 3, scroller:setsize, 2
bind = $mainMod ALT, 4, scroller:setsize, 3

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# ------------------------ Main Applications/Utilities
bind = $mainMod ALT, V, exec, ~/.config/hypr/toggle_video_bg.nu

bind = $mainMod, Return, exec, kitty zsh ~/.config/tmux.zsh # Open Terminal
bind = $mainMod, T, exec, kitty --class PopUp zsh ~/.config/tmux.zsh # Terminal PopUp
bind = $mainMod ALT, Return, exec, zutty # Alternative, simpler terminal
bind = $mainMod, E, exec, kitty --class Explorer vifm ~ ~# File Explorer
bind = $mainMod ALT, E, exec, thunar
bind = $mainMod, V, exec, copyq toggle
bind = $mainMod, I, exec, firefox # Web Browser
bind = $mainMod SHIFT, I, exec, firefox -private-window # Alternative Web Browser
bind = $mainMod ALT, I, exec, $HOME/.config/rofi/applets/bin/quicklinks.sh

# Runners
# bind = $mainMod, D, exec, $HOME/.config/rofi/scripts/launcher_t3
bind = $mainMod, D, exec, walker
# bind = $mainMod, R, exec, $HOME/.config/rofi/applets/bin/apps.sh
bind = $mainMod, Escape, exec, $HOME/.config/rofi/scripts/powermenu_t1
bind = $mainMod, grave, exec, rofi -show calc # Calculator
bind = $mainMod SHIFT, Tab, hyprexpo:expo, toggle
bind = $mainMod ALT, Tab, scroller:toggleoverview
bind = $mainMod, Tab, scroller:jump
bind = $mainMod, semicolon, exec, rofi -show emoji
bind = $mainMod, S, exec, /home/brian/.config/home-manager/script/rofi-systemd.sh
bind = $mainMod SHIFT, semicolon, exec, /home/brian/.config/home-manager/script/rofi-bluetooth.sh

# Screenshot
bind = $mainMod SHIFT, S, exec, $HOME/.config/rofi/applets/bin/screenshot.sh
bind = ,Print, exec, hyprshot -c -m output -o ~/Screenshots
bind = ,XF86Calculator, exec, kitty --class PopUp bc # calculator
bind = CONTROL SHIFT, Escape, exec, kitty --class ProcessManager btop
bind = ALT, X, exec, pkill -SIGUSR1 gpu-screen-reco

#Special keys # Media Control Keys
bind = ,XF86AudioPlay, exec, playerctl --player $(systemctl --user show-environment | grep CURRENT_PLAYER | sed 's/.*\=//') play-pause
bind = ,XF86AudioPause, exec,playerctl --player $(systemctl --user show-environment | grep CURRENT_PLAYER | sed 's/.*\=//') play-pause
bind = ,XF86AudioStop, exec, playerctl --player $(systemctl --user show-environment | grep CURRENT_PLAYER | sed 's/.*\=//') pause
bind = ,XF86AudioNext, exec, playerctl --player $(systemctl --user show-environment | grep CURRENT_PLAYER | sed 's/.*\=//') next
bind = ,XF86AudioPrev, exec, playerctl --player $(systemctl --user show-environment | grep CURRENT_PLAYER | sed 's/.*\=//') previous
bind = ,XF86AudioRaiseVolume, exec, nu ~/.config/hypr/volume.nu +5
bind = ,XF86AudioLowerVolume, exec, nu ~/.config/hypr/volume.nu -5
bind = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle
bind = ,XF86AudioMute, exec, nu ~/.config/hypr/volume.nu 0
bind = ,XF86MonBrightnessDown, exec, nu ~/.config/hypr/brightness.nu -5
bind = ,XF86MonBrightnessUp, exec, nu ~/.config/hypr/brightness.nu 5
bind = ,XF86Messenger, exec, discord

binds:window_direction_monitor_fallback = false

plugin {
	scroller {
		column_default_width = onehalf
		focus_wrap = false
	}
}

	'' + (  if hostname == "BrianNixDesktop"
		then ''
		monitor = DP-1,3840x2160@144,auto,1,bitdepth,8
		monitor = DP-2,preferred,auto-left,1,bitdepth,8
		monitor = HDMI-A-1,preferred,auto-right,1,bitdepth,8''
		else "monitor = ,preferred,auto,2" ) ;
}
