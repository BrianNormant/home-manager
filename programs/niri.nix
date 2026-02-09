{hostname, config, lib, pkgs, ...}: {
	home = {
		file = {
			".config/niri/config.kdl".source = ../config/niri/config.kdl;
			".config/script/set-workspace-name.sh" = {
				source = ../script/set-workspace-name.sh;
				executable = true;
			};
		};
	};
	xdg.configFile = {
		"niri".source = ../config/niri;
	};

	home.packages = with pkgs; [
		xwayland-satellite
		swww awww
		hyprpicker

		# fzf based control scripts
		(writeScriptBin "fzf-cmus.sh" (callPackage ../script/fzf-cmus.nix {}) )
		(writeScriptBin "fzf-man.sh"  (callPackage ../script/fzf-man.nix  {}) )
		(writeScriptBin "fzf-niri.sh" (callPackage ../script/fzf-niri.nix {}) )
	];
}
