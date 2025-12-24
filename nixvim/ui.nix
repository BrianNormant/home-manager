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
		};
	};
}
