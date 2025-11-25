{pkgs, lib, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		plugins = {
			navbuddy = {
				enable = true;
				lazyLoad.settings = {
					cmd = "Navbuddy";
				};
				settings = {
					lsp = { auto_attach = true; };
					window = { border = "double"; };
					mappings = {
						"<Up>".__raw    = "require('nvim-navbuddy.actions').previous_sibling()";
						"<Down>".__raw  = "require('nvim-navbuddy.actions').next_sibling()";
						"<Right>".__raw = "require('nvim-navbuddy.actions').children()";
						"<Left>".__raw  = "require('nvim-navbuddy.actions').parent()";
					};
				};
			};
			aerial = {
				enable = true;
				lazyLoad.settings.event = [ "LspAttach" ];
				settings = {
					layout = {
						placement = "edge";
					};
					attach_mode = "global";
				};
			};
		};
		keymaps = [
			{
				key = "L";
				action = "<Cmd>AerialToggle! left<cr>";
				options.desc = "Aerial";
			}
			{
				key = "<C-l>";
				action = "<Cmd>Navbuddy<cr>";
				options.desc = "Navbuddy";
			}
		];
	};
}
