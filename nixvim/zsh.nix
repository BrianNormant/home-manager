{pkgs, ...}:
{
	programs.nixvim = {
		plugins = {
			none-ls.sources.diagnostic.zsh = {
				enable = true;
			};
		};
	};
}
