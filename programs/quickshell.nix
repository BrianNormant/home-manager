{pkgs, ...}:
{
	programs.quickshell = {
		enable = true;
	};
	home = {
		packages = with pkgs; [
			material-symbols
			ibm-plex
			lm_sensors
			grim
			swappy
			libqalculate
			nerd-fonts.jetbrains-mono		brightnessctl
			ddcutil
			cava
			app2unit
			aubio
			fish
			gpu-screen-recorder
			swaylock # unlock if the quickshell crashes
			caelestia-shell
		];
	};
	fonts.fontconfig = { enable = true; };
}
