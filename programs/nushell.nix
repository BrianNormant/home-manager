{pkgs, ...}: {
	programs.nushell = {
		enable = true;
		configFile.source = ../config/nushell/default-config.nu;
		extraConfig = with pkgs.nushellPlugins; ''
			plugin add ${polars}/bin/nu_plugin_polars
			'';
	};
}
