{ pkgs, ... }: {
	programs = {
		tmux = {
			enable = true;
			clock24 = true;
			escapeTime = 10;
			keyMode = "vi";
			plugins = with pkgs.tmuxPlugins; [ yank ];
			terminal = "tmux-256color";
			mouse = true;
			extraConfig = builtins.readFile ../config/tmux.conf;
		};
	};
}
