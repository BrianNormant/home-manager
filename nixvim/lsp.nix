{pkgs, ... }: {
	programs.nixvim = {
		diagnostics = {
			virtual_text = false;
		};
		plugins = {
			lsp = {
				enable = true;
				servers = {
					clangd.enable   = true;
					lua_ls.enable   = true;
					nixd.enable     = true;
					lemminx.enable  = true;
					phpactor.enable = true;
					nushell.enable  = true;
					svelte.enable   = true;
					ts_ls.enable    = true;
					elixirls.enable = true;
				};
				onAttach = builtins.readFile ./lsp-attach.lua;
			};
			glance = {
				enable = true;
				settings.border = { enable = true; };
			};
			inc-rename = {
				enable = true;
				settings = {
					cmd_name = "IncRename";
					input_buffer_type = "dressing";
				};
			};
			fidget.enable = true;
		};
		extraPlugins = with pkgs.vimPlugins; [
			actions-preview-nvim
			hover-nvim
			nvim-docs-view
			goto-preview
		];
		extraConfigLua = builtins.readFile ./lsp.lua;
	};
}
