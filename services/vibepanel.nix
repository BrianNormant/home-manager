{pkgs, ...}: {
	systemd.user.services = {
		vibepanel = {
			Unit = {
				Description = "vibepanel";
				After = ["graphical-session.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.vibepanel}/bin/vibepanel";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
