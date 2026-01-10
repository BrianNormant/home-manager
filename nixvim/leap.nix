{config, pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			leap = {
				enable = true;
				luaConfig.post = ''
require('leap.user').set_repeat_keys('<enter>', '<backspace>')
vim.keymap.set({'x', 'o'}, 'R', function()
	require('leap.treesitter').select {
		opts = require('leap.user').with_traversal_keys('R', 'r');
	}
end)
				'';
			};
			flit = {
				enable = true;
				settings = {
					labeled_modes = "nvo";
				};
			};
			telepath = {
				enable = true;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
				luaConfig.post = ''
vim.keymap.set({'x', 'o'}, 'r', function()
	require('telepath').remote {restore = true, recursive = false}
end)
					'';
			};
		};
		highlightOverride = {
			LeapBackdrop = { fg = "#888888"; };
			LeapLabel    = { fg = "#FF0000"; bold = true;};
		};
		keymaps = [
			{
				key = "x";
				action = "<Plug>(leap)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap in window";
			}
			{
				key = "X";
				action = "<Plug>(leap-anywhere)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap anywhere";
			}
		];
	};
}
