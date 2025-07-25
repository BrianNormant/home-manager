{pkgs, ...} : {
	systemd.user = {
		services = {
			# hyprpanel = {
			# 	Service.Type = "exec";
			# 	Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			# 	Service.ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
			# 	Service.Restart="always";
			# 	Service.RestartSec="5s";
			# };

			quickshell = {
				Service.Type = "exec";
				Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
				Service.ExecStart = "${pkgs.quickshell}/bin/quickshell";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			nm-applet = {
				Service.Type = "exec";
				Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
				Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			# hyprpaper = {
			# 	Service.Type = "exec";
			# 	Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			# 	Service.ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
			# 	Service.Restart="always";
			# 	Service.RuntimeMaxSec="29min";
			# 	Service.RestartSec="4s";
			# };

			# hypridle = {
			# 	Service.Type = "exec";
			# 	Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			# 	Service.ExecStart = "${pkgs.hypridle}/bin/hypridle";
			# 	Service.Restart="always";
			# 	Service.RestartSec="5s";
			# };

			steam = {
				Service.Type = "exec";
				Service.Environment = [
					"PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin"
					"DISPLAY=:0"
				];
				Service.ExecStart = "/run/current-system/sw/bin/steam -silent";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			discord = {
				Service.Type = "exec";
				Service.Environment = [
					"PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin"
					"DISPLAY=:0"
				];
				Service.ExecStart = "${pkgs.discord}/bin/discord";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			waypaper = {
				Service.Type = "oneshot";
				Service.ExecStart = "${pkgs.waypaper}/bin/waypaper --random";
				Service.Environment = [
					"WAYLAND_DISPLAY=wayland-1"
				];
				Unit.Description = "Randomize the wallpaper";
			};
			
			swww = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.swww}/bin/swww-daemon";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			corectrl = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.corectrl}/bin/corectrl";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			copyq = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.copyq}/bin/copyq";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			# video = {
			# 	Service.Type = "oneshot";
			# 	Service.ExecStart = "/home/brian/.nix-profile/bin/mpvpaper "
			# }

			# cycle-paper =  {
			# 	Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			# 	Service.Type = "oneshot";
			# 	Service.ExecStart = "${pkgs.nushell}/bin/nu /home/brian/.config/hypr/wallpaper.nu";
			# 	Unit.Description = "Cycle through wallpapers";
			# 	Service.Restart="always";
			# };

			switch-playerctl = {
				Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
				Service.ExecStart = "/run/current-system/sw/bin/zsh /home/brian/.config/script/switch-playerctl.zsh";
			};

			polkit-agent = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Unit.After="niri.service";
			};
		};

		timers = {
			# cycle-paper.Timer.OnCalendar = "*-*-* *:*:00";
			waypaper.Timer.OnCalendar = "*:0/1";
		};

		tmpfiles.rules = [ ];
	};
}
