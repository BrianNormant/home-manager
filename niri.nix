{pkgs, config, ...}: {
	xdg.configFile = {
		"niri".source = ./config/niri;

		"systemd/user/niri.service.wants/copyq.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/copyq.service;
		"systemd/user/niri.service.wants/waypaper.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/waypaper.service;
		"systemd/user/niri.service.wants/nm-applet.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/nm-applet.service;
		"systemd/user/niri.service.wants/steam.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/steam.service;
		"systemd/user/niri.service.wants/discord.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/discord.service;
		"systemd/user/niri.service.wants/corectrl.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/corectrl.service;
		"systemd/user/niri.service.wants/swww.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/swww.service;
		"systemd/user/niri.service.wants/quickshell.service".source =
			config.lib.file.mkOutOfStoreSymlink /home/brian/.config/systemd/user/quickshell.service;
	};
	home.packages = with pkgs; [
		xwayland-satellite
		swaybg swww
		waypaper
		overskride
	];

	# TODO fix randomizer wallpaper with waypaper+swaybg
	# TODO set some wallpapers for overview with swww
}
