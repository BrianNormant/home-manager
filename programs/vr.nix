{pkgs, ...}: {
	home = {
		file = {
			".config/wlxoverlay/wayvr.conf.d/dashboard.yaml".source = ../config/wlxoverlay/wayvr.conf.d/dashboard.yaml;
		};
		packages = with pkgs; [
			wayvr
		];
	};
}
