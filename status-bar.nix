{pkgs, ...}: {
	home.packages = with pkgs; [
		quickshell
		material-symbols
		ibm-plex
		lm_sensors
		grim
		swappy
		libqalculate
		nerd-fonts.jetbrains-mono
		brightnessctl
		ddcutil
		cava
		# app2unit
		aubio
		fish
	];
	home.file = {
		".config/quickshell".source = ./config/quickshell;
	};
	fonts.fontconfig = { enable = true; };
}
