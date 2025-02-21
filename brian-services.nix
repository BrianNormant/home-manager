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
		
		hypridle = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.hypridle}/bin/hypridle";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		steam = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.steam}/bin/steam";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		vesktop = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.vesktop}/bin/vesktop";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		waypaper = {
			Service.Type = "oneshot";
			Service.ExecStart = "${pkgs.waypaper}/bin/waypaper --random";
			Unit.Description = "Randomize the wallpaper";
		};

		corectrl = {
			Service.Type = "exec";
			Service.ExecStart = "${pkgs.corectrl}/bin/corectrl";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		copyq = {
			Service.Type = "exec";
			Service.ExecStart = "${pkgs.copyq}/bin/copyq --start-server";
			Service.Restart="always";
			Service.RestartSec="5s";
		};

		# cycle-paper =  {
		# 	Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
		# 	Service.Type = "oneshot";
		# 	Service.ExecStart = "${pkgs.nushell}/bin/nu /home/brian/.config/hypr/wallpaper.nu";
		# 	Unit.Description = "Cycle through wallpapers";
		# 	Service.Restart="always";
		# };

		switch-playerctl = {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "/home/brian/.config/script/switch-playerctl.zsh";
		};
	};

	timers = {
		 # cycle-paper.Timer.OnCalendar = "*-*-* *:*:00";
		 waypaper.Timer.OnCalendar = "*:0/1";
	};

	tmpfiles.rules = [ ];
}
