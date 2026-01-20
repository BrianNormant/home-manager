{pkgs, ...}:
let
	inherit (pkgs) vimPlugins;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;
in {
	programs.nixvim = {
		plugins = {
			floating-input = {
				enable = true;
				package = pkgs.vimPlugins.floating-input-nvim.overrideAttrs {
					patches = [
						./plugin-patch/floating-input.patch
					];
				};
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
				luaConfig.post = ''
					local ft = require('floating-input').input
					vim.ui.input = function(opts, on_confirm)
						ft(opts, on_confirm, {border = "solid", width = 50})
					end
					'';
			};
			undo-glow = {
				enable = false;
				lazyLoad.settings = {
					event = "DeferredUIEnter";
				};
				settings = {
					animation = {
						enabled = true;
						duration = 300;
						animation_type = "slide";
						fps = 120;
						window_scoped = true;
					};
					highlights = {
						undo = { hl_color = { bg = "#693232"; }; };
						redo = { hl_color = { bg = "#2F4640"; }; };
						yank = { hl_color = { bg = "#7A683A"; }; };
						paste = { hl_color = { bg = "#325B5B"; }; };
					};
				};
				luaConfig.post = ''
vim.keymap.set("n", "u", function()
	require("undo-glow").undo()
end)
vim.keymap.set("n", "U", function()
	require("undo-glow").redo()
end)
vim.keymap.set("n", "<C-r>", function()
	require("undo-glow").redo()
end)
vim.keymap.set("n", "p", function()
	require("undo-glow").paste_below()
end)
vim.keymap.set("n", "P", function()
	require("undo-glow").paste_above()
end)
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		require("undo-glow").yank()
	end,
})
				'';
			};
		};
	};
}
