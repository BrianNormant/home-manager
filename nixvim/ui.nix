{pkgs, ...}:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		extraPlugins = with vimPlugins; [
			{
				plugin = floating-input-nvim;
				optional = true;
			}
		];
		extraConfigLua = ''
			require('lz.n').load {
				'floating-input.nvim',
				event = "DeferredUIEnter",
				after = function()
					local ft = require('floating-input').input
					vim.ui.input = function(opts, on_confirm)
						ft(opts, on_confirm, {border = "solid", width = 50})
					end
				end
			}
		'';
	};
}
