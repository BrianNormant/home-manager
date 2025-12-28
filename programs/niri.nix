{hostname, config, lib, pkgs, ...}: {
	# Niri is enabled from the nixos-configuration
	# We just have to configure it here
	# TODO fix randomizer wallpaper with waypaper+swaybg
	# TODO set some wallpapers for overview with swww
	home = {
		file = {
			".config/niri/config.kdl".source = ../config/niri/config.kdl;
			".config/script/set-workspace-name.sh" = {
				source = ../script/set-workspace-name.sh;
				executable = true;
			};
			# wallpaper
			".config/script/random-swww.sh" = {
				source = ../script/random-swww.sh;
				executable = true;
			};
			".config/script/random-waypaper.sh" = {
				source = ../script/random-waypaper.sh;
				executable = true;
			};
		};
	};
	xdg.configFile = {
		"niri".source = ../config/niri;
	};

	home.packages = with pkgs; [
		xwayland-satellite
		swaybg swww
		waypaper
		hyprpicker

		# fzf based control scripts
		(writeScriptBin "fzf-cmus.sh" (callPackage ../script/fzf-cmus.nix {}) )
	];
}
