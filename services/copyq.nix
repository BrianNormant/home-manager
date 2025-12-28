{pkgs, ...}: {
	systemd.user.services = {
		copyq = {
			Unit = {
				Description = "copyq";
				After = ["graphical-session-pre.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.copyq}/bin/copyq";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
