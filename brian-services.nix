pkgs: {
	services = {
		waybar = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.waybar}/bin/waybar";
			Service.Restart="on-failure";
			Service.RestartSec="5s";
		};

		hyprpaper = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
			Service.Restart="on-failure";
			Service.RestartSec="5s";
		};
		dunst = {
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "${pkgs.dunst}/bin/dunst";
			Service.Restart="on-failure";
			Service.RestartSec="5s";
		};
		cycle-paper =  {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.Type = "oneshot";
			Service.ExecStart = "${pkgs.nushell}/bin/nu /home/brian/.config/hypr/wallpaper.nu";
			Unit.Description = "Cycle through wallpapers";
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
