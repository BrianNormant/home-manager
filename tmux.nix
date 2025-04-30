{ pkgs, ... }: {
	programs = {
		tmux = {
			enable = true;
			clock24 = true;
			escapeTime = 10;
			keyMode = "vi";
			plugins = with pkgs.tmuxPlugins; [
				gruvbox
				mode-indicator
				(pkgs.tmuxPlugins.mkTmuxPlugin rec {
					pluginName = "tmux-cmus";
					version = "2";
					rtpFilePath = ( builtins.replaceStrings ["_"] ["-"] pluginName ) + ".tmux";
					src = pkgs.fetchFromGitHub {
						owner = "Mpdreamz";
						repo  = "tmux-cmus";
						rev = "df9e6f1";
						hash = "sha256-5VwzlvuhHiVlfSG+wql+enS4MPMU0bYNaZJhEgIeUmo=";
					};
				})
				yank
			];
			terminal = "tmux-256color";
			mouse = true;
			extraConfig = builtins.readFile ./config/tmux.conf;
		};
	};
}
