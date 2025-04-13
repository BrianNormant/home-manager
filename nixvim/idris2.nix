{pkgs, ... }: {
	programs.nixvim = {
		extraPlugins = with pkgs.vimPlugins; [
			{
				plugin = idris2-nvim;
				optional = true;
			}
		];
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
