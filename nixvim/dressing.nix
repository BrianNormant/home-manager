{config, pkgs, ...}: {
	programs.nixvim = {
		plugins.dressing = {
			enable = true;
			lazyLoad.settings = {
				event = [ "DeferredUIEnter" ];
			};
			settings = {
				input = {
					border = "single";
					override = ''
						function(conf)
							conf.col = -1
							conf.row = 0
							return conf
						end
					'';
				};
				select.enabled = true;
			};
		};
		plugins.markview = {
			enable = true;
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
}
