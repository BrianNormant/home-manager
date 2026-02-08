{pkgs, ...}:
{
	home = {
		packages = with pkgs; [
			caelestia-shell
			caelestia-qs

			app2unit
			aubio
			brightnessctl
			cava
			ddcutil
			fish
			nerd-fonts.caskaydia-cove
			grim
			libcava
			pipewire
			libqalculate
			lm_sensors
			material-symbols
			networkmanager
			swappy

			swaylock # unlock if the quickshell crashes
		];
	};
	fonts.fontconfig = { enable = true; };
}
