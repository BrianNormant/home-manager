{pkgs, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;

in {
	programs.nixvim = {
		plugins = {
			friendly-snippets.enable = true;
			supermaven = {
				enable = true;
				package = pkgs.vimPlugins.supermaven-nvim.overrideAttrs {
					patches = [
						./plugin-patch/supermaven.patch
					];
				};
				settings = {
					log_level = "off";
					keymaps = {
						accept_suggestion = "<C-Space>";
						clear_suggestion = "<C-e>";
						accept_word = "<C-j>";
					};
				};
			};
		};
		extraConfigLuaPre = ''
			_G.friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
		'';
		extraConfigLuaPost = builtins.readFile ./completion.lua;
		keymaps = [
			{
				key = "<leader>c";
				action.__raw = ''function()
					if table:contains(vim.opt.completeopt:get(), "noinsert") then
						vim.opt.completeopt:remove "noinsert"
					else
						vim.opt.completeopt:append "noinsert"
					end
				end'';
				options.desc = "Toogle noinsert on completion";
			}
		];
	};
}
