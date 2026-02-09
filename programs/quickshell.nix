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
		file = {
			".local/state/caelestia/scheme.json".source = ../config/quickshell-scheme.json;
		};
	};
	fonts.fontconfig = { enable = true; };
}
