{ config, hostname, ...}: {
	services.unison = {
		enable = hostname == "BrianNixLaptop";
		pairs = {
			"Music" = {
				roots = [
					"/home/brian/Music"
					"ssh://BrianNixDesktopI//home/brian/Music"
				];
				stateDirectory = "${config.xdg.dataHome}/unison/Music";
			};
			"Documents" = {
				roots = [
					"/home/brian/Documents"
					"ssh://BrianNixDesktopI//home/brian/Documents"
				];
				stateDirectory = "${config.xdg.dataHome}/unison/Documents";
			};
			"Wallpapers" = {
				roots = [
					"/home/brian/Wallpapers"
					"ssh://BrianNixDesktopI//home/brian/Wallpapers"
				];
				stateDirectory = "${config.xdg.dataHome}/unison/Wallpapers";
			};
			"Prog" = {
				roots = [
					"/home/brian/Prog"
					"ssh://BrianNixDesktopI//home/brian/Prog"
				];
				stateDirectory = "${config.xdg.dataHome}/unison/Prog";
				commandOptions = {
					ignore = [
						# "Name .git"
						"Name .ccls-cache"
						"Name *log*"
						"Name *bin*"
						"Name *.jar"
						"Name result" # nix build output
						"Name target" # maven build output
						"Name .m2"    # maven repo
					];
					repeat = "watch";
					batch = "true";
					ui = "text";
					auto = "true";
					log = "false";
				};
			};
		};
	};
}
