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
				select.enabled = false;
			};
		};
	};
}
