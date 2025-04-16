{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.markview = {
			enable = true;
			lazyLoad.settings = {
				ft = "markdown";
			};
			settings.preview = {
				modes = [ "n" "no" "c" ];
				hybrid_modes = [ "o" "i" ];
				callbacks.on_enable.__raw = ''
					function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "c"
					end
				'';
			};
		};
	};
	# diagram.nvim/
	# markdown-preview
}
