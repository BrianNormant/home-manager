{pkgs, ... }: {
	programs.nixvim = {
		# plugins.idris2 = {
		# 	enable = true;
		# 	settings = {
		# 		code_action_post_hook.__raw = ''
		# 		function(_)
		# 			vim.cmd "silent write"
		# 		end
		# 		'';
		# 	};
		# 	lazyLoad.enable = true;
		# 	lazyLoad.settings = {
		# 		ft = [ "idris2" ];
		# 	};
		# };
		extraPlugins = with pkgs.vimPlugins; [ idris2-nvim ];
		extraConfigLua = ''
			require('lz.n').load { {
				'idris2-nvim',
				ft = "idris2",
				after = function()
					require("idris2").setup {
						code_action_post_hook = function(_)
							vim.cmd "silent write"
						end
					}
				end
			} }
		'';
	};
}
