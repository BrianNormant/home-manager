{pkgs, config, ...}: {
	home.file = {
		".config/script/random-swaybg.sh" = {
			source = ../script/random-swaybg.sh;
			executable = true;
		};
	};
	systemd.user.services = {
		swaybg-random = {
			Unit = {
				Description = "swaybg";
				After = ["graphical-session-pre.target"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.zsh}/bin/zsh ${config.home.homeDirectory}/.config/script/random-swaybg.sh";
				Restart = "always";
				RuntimeMaxSec = "1min";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
