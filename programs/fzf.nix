{...}: {
	programs = {
		fzf = {
			enable = true;
			tmux = {
				enableShellIntegration = true;
				shellIntegrationOptions = [ "-p 80%,35%" ];
			};
			enableZshIntegration = true;
			enableBashIntegration = false;
			enableFishIntegration = false;
			enableNushellIntegration = false;
		};
	};
}
