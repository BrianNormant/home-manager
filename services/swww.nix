{pkgs, config, ...}: {
	systemd.user.services = {
		swww = {
			Unit = {
				Description = "swww";
				After = ["graphical-session.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.swww}/bin/swww-daemon";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
		swww-gif = {
			Unit = {
				Description = "swww-gif";
				After = ["swww.service"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.swww}/bin/swww img ${config.home.homeDirectory}/Wallpapers/.Videos/Miata.gif";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
