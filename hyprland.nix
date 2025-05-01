{pkgs, hostname, ...}: {
	home = {
		file = {
			".config/hypr/hyprlock.conf".text = (import ./hyprlock.nix) (if hostname == "BrianNixDesktop" then "DP-1" else "eDP-1");
			".config/hypr/hypridle.conf".source = ./hypridle.conf;
			".config/hyprpanel/config.json".source = ./config/hyprpanel/hyprpanel.json;
			".config/hypr/xdph.conf".text = ''
				screencopy {
					allow_token_by_default = true
				}
			'';

		};
		packages = with pkgs; [
			hyprpicker
			hyprpanel
			hyprpolkitagent
			waypaper mpvpaper
		];
	};
	xdg.portal = {
		extraPortals = with pkgs; [
			xdg-desktop-portal-gnome
			xdg-desktop-portal-hyprland
		];
		xdgOpenUsePortal = true;
	};
	wayland.windowManager.hyprland = {
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
				
				"float, class:(cool-retro-term.)"
				"size 40% 80%, class:(cool-retro-term.)"
				"center, class:(cool-retro-term.)"

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

		extraConfig =
			builtins.readFile ./config/hyprland.conf
			+ ( if hostname == "BrianNixDesktop"
				then ''
			monitor = DP-1,3840x2160@144,auto,1,bitdepth,8
			monitor = DP-2,preferred,auto-left,1,bitdepth,8
			monitor = HDMI-A-1,preferred,auto-right,1,bitdepth,8''
			else "monitor = ,preferred,auto,2" ) ;
	};
}
