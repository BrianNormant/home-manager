pkgs: {
	services = {
		hyprpanel = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.hyprpanel}/bin/hyprpanel";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		nm-applet = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		hyprpaper = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
			Service.Restart="always";
			Service.RestartSec="5s";
		};
		cycle-paper =  {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.Type = "oneshot";
			Service.ExecStart = "${pkgs.nushell}/bin/nu /home/brian/.config/hypr/wallpaper.nu";
			Unit.Description = "Cycle through wallpapers";
			Service.Restart="always";
		};
		switch-playerctl = {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "/home/brian/.config/script/switch-playerctl.zsh";
		};
	};

	timers = {
		 cycle-paper.Timer.OnCalendar = "*-*-* *:*:00";
	};

	tmpfiles.rules = [ ];
}
