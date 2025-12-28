{pkgs, ...}: {
	programs.firefox = {
		enable = true;
	};
	home = {
		file = {
			".mozilla/native-messaging-hosts/tridactyl.json".text = ''
				{
					"name": "tridactyl",
					"description": "Tridactyl native command handler",
					"path": "${pkgs.tridactyl-native}/bin/native_main",
					"type": "stdio",
					"allowed_extensions": [ "tridactyl.vim@cmcaine.co.uk","tridactyl.vim.betas@cmcaine.co.uk", "tridactyl.vim.betas.nonewtab@cmcaine.co.uk" ]
				}
			'';
			".config/tridactyl/tridactylrc".source = ../config/tridactylrc;
		};
		packages = with pkgs; [
			tridactyl-native
		];
	};
}
