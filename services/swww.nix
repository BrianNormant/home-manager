{pkgs, config, ...}: {
	home.file = {
		".config/script/random-swww.sh" = {
			source = ../script/random-swww.sh;
			executable = true;
		};
	};
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
		swww-random = {
			Unit = {
				Description = "swww-random";
				After = ["swww.service"];
			};
			Service = {
				Type = "simple";
				ExecStart = "${pkgs.zsh}/bin/zsh ${config.home.homeDirectory}/.config/script/random-swww.sh";
				Restart = "never";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
	systemd.user.timers = {
		swww-random = {
			Unit = {
				Description = "swww-random";
				After = ["swww.service"];
			};
			Timer = {
				OnCalendar = "*-*-* *:0/3";
			};
		};
	};
}
