{pkgs, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;

in {
	programs.nixvim = {
		plugins = {
			friendly-snippets.enable = true;
		};
		extraPlugins = with pkgs.vimPlugins; [
			{
				plugin = supermaven-nvim.overrideAttrs {
					patches = [
						./plugin-patch/supermaven.patch
					];
				};
				optional = true;
			}
			{
				plugin = buildVimPlugin {
					pname = "compl.nvim";
					version = "3fe5dd7";
					src = ./plugin-src/compl.nvim;
				};
				optional = true;
			}
		];
		extraConfigLuaPre = ''
			_G.friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
			_G.auto_trigger_completion = true
		'';
		extraConfigLuaPost = builtins.readFile ./completion.lua;
		keymaps = [
			{
				key = "<leader>c";
				action.__raw = ''function()
					if _G.auto_trigger_completion then
						_G.auto_trigger_completion = false
						vim.opt.shortmess:remove "c"
						vim.notify("Auto-completion is disabled")
					else
						_G.auto_trigger_completion = true
						vim.opt.shortmess:append "c"
						vim.notify("Auto-completion is enabled")
					end
				end'';
				options.desc = "Toggle completion auto-triggering";
			}
		];
	};
}
