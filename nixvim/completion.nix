{pkgs, ... }: {
	programs.nixvim = {
		plugins = {
			friendly-snippets.enable = true;
			blink-cmp = {
				enable = true;
				lazyLoad.settings.event = "DeferredUIEnter";
				settings = {
					keymap = {
						preset = "enter";
						"<Tab>"   = [ "select_next" "fallback" ];
						"<S-Tab>" = [ "select_prev" "fallback" ];
						"<C-l>"   = [ "snippet_forward" ];
						"<C-h>"   = [ "snippet_backward" ];
						"<Up>"    = [ "fallback" ];
						"<Down>"   = [ "fallback" ];
					};
					sources = {
						default = [
							"supermaven"
							"lsp"
							"path"
							"snippets"
						];
						providers = {
							supermaven = {
								name = "SuperMaven";
								fallbacks = [ "buffer" ];
								module = "supermaven";
								score_offset = 20;
							};
							lsp = {
								name = "LSP";
								module = "blink.cmp.sources.lsp";
							};
							path = {
								name = "Path";
								module = "blink.cmp.sources.path";
							};
							snippets = {
								name = "Snippets";
								module = "blink.cmp.sources.snippets";
								opts = { friendly_snippets = true; };
							};
							buffer = {
								name = "Buffer";
								module = "blink.cmp.sources.buffer";
							};
						};
					};
					completion = {
						list.selection = {
							preselect = false;
							auto_insert = true;
						};
						menu = {
							border = "rounded";
							draw.columns = [
								["label" "source_name"] ["kind_icon" "kind"]
							];
						};
						documentation.auto_show = true;
					};
					signature.enabled = true;
					cmdline.enabled = false;
				};
			};
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
		];
		extraConfigLua = builtins.readFile ./blink.lua;
		highlightOverride = {
			Pmenu = { link = "Float"; default = false;};
			PmenuSel = { link = "CursorLine"; default = false;};
		};
	};
}
