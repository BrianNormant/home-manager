{pkgs, ...}: {
	systemd.user.services = {
		swww = {
			Unit = {
				Description = "swww";
				After = ["graphical-session-pre.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.swww}/bin/swww-daemon";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
