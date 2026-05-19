{pkgs, config, ...}: {
	systemd.user.services = {
		swww = {
			Unit = {
				Description = "swww";
				After = ["graphical-session.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.awww}/bin/awww-daemon --namespace bg";
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
				ExecStart = "${pkgs.awww}/bin/awww img --namespace bg ${config.home.homeDirectory}/Wallpapers/.Videos/Miata.gif";
			};
		};
	};
}
