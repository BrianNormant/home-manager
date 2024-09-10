{	
	services = let
		createService = {command, description ? "noDsc"}:
		{
			Unit.Description = description;
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "/home/brian/.nix-profile/bin/" + command;
			Service.Restart="on-failure";
			Service.RestartSec="5s";
		};
	in {
		waybar = createService {command = "waybar"; description = "start and manager waybar";};

		hyprpaper = createService {command = "hyprpaper";};
		dunst = createService {command = "dunst";};
		steam = createService {command = "steam";};
		cycle-paper =  {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.Type = "oneshot";
			Service.ExecStart = "/home/brian/.nix-profile/bin/nu /home/brian/.config/hypr/wallpaper.nu";
			Unit.Description = "Cycle through wallpapers";
		};
		switch-playerctl = {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "/home/brian/.config/script/switch-playerctl.zsh";
		};
		gpu-screen-recorder = {
			Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
			Service.ExecStart = "/home/brian/.nix-profile/bin/gpu-screen-recorder -w 'DP-1' -f 30 -r 30 -c mp4 -o /home/brian/Videos";
		};
	};

	timers = {
		 cycle-paper.Timer.OnCalendar = "*-*-* *:*:00"; 
	};

	tmpfiles.rules = [ ];
}
