{pkgs, config, ...}: {
	systemd.user.services = {
		awww = {
			Unit = {
				Description = "awww";
				After = ["graphical-session.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.awww}/bin/awww-daemon";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
		awww-gif = {
			Unit = {
				Description = "awww-gif";
				After = ["awww.service"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.awww}/bin/awww img ${config.home.homeDirectory}/Wallpapers/.Videos/Night_Drive.gif";
			};
		};
	};
}
