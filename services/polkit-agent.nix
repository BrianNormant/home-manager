{pkgs, ...}: {
	systemd.user.services = {
		polkit-agent = {
			Unit = {
				Description = "polkit-agent";
				After = ["graphical-session-pre.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
