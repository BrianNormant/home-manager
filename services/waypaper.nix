{pkgs, ...}: {
	systemd.user = {
		services = {
			waypaper = {
				Unit = {
					Description = "waypaper";
					After = ["graphical-session-pre.target"];
				};
				Service = {
					Type = "simple";
					ExecStart = "${pkgs.waypaper}/bin/waypaper --random";
					Restart = "always";
				};
				Install.WantedBy = ["graphical-session.target"];
			};
		};
		timers = {
			waypaper = {
				Unit = {
					Description = "waypaper";
					After = ["graphical-session-pre.target"];
				};
				Timer = {
					OnCalendar = "*:0/1";
				};
			};
		};
	};
}
