{pkgs, lib, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;
in {
	programs.nixvim = {
		diagnostic.settings = {
			virtual_text = false;
		};
		plugins = {
			lspkind = {
				enable = true;
				lazyLoad.settings = { event = [ "LspAttach" ]; };
				cmp.enable = false;
			};
			actions-preview = {
				enable = true;
				settings = {
					highlight_command.__raw = ''{
						require("actions-preview.highlight").delta()
					}'';
					backend = [ "telescope" ];
				};
				lazyLoad.settings = { event = "LspAttach"; };
			};
			goto-preview = {
				enable = true;
				lazyLoad.settings = { event = "LspAttach"; };
				settings = {
					border = "rounded";
				};
			};
			lsp = {
				enable = true;
				preConfig = ''
					require('lz.n').trigger_load("blink.cmp")
					require('lz.n').trigger_load("nvim-navbuddy")
				'';
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
				inlayHints = true;
				lazyLoad.settings = {
					ft = [
						"c"
						"lua"
						"nix"
						"xml"
						"nu"
						"svelte"
						"typescript"
						"elixir"
						"php"
						"java"
					];
				};
			};
			hover = {
				enable = true;
				lazyLoad.settings = {
					event = "LspAttach";
				};
				settings = {
					init.__raw = ''function()
						require('hover.providers.lsp')
						require('hover.providers.dap')
						require('hover.providers.diagnostic')
						require('hover.providers.man')
						require('hover.providers.dictionary')
					end'';
				};
			};
			outline = {
				enable = true;
				lazyLoad.settings = {
					cmd = "Outline";
					keys = [
						{ __unkeyed-1 = "L"; __unkeyed-2 = "<Cmd>Outline<cr>"; }
					];
				};
				settings = {
					outline_window = {
						position = "left";
						focus_on_open = false;
					};
				};
			};
		};
		keymaps = [
			{
				key = "grr";
				action = "<CMD>Telescope lsp_references theme=cursor<CR>";
				options.desc = "Telescope lsp_references";
			}
			{
				key = "gri";
				action = "<CMD>Telescope lsp_implementations theme=cursor<CR>";
				options.desc = "Telescope lsp_implementations";
			}
			{
				key = "gO";
				action = "<CMD>Telescope lsp_document_symbols theme=dropdown<CR>";
				options.desc = "Telescope lsp_document_symbols";
			}
			{
				key = "grg";
				action = "<CMD>Telescope lsp_workspace_symbols theme=dropdown<CR>";
				options.desc = "Telescope lsp_workspace_symbols";
			}
			{
				key = "grs";
				action = "<CMD>Telescope lsp_dynamic_workspace_symbols theme=dropdown<CR>";
				options.desc = "Telescope lsp_dynamic_workspace_symbols";
			}
			{
				key = "gro";
				action = "<CMD>Telescope lsp_outgoing_calls theme=dropdown<CR>";
				options.desc = "Telescope lsp_outgoing_calls";
			}
			{
				key = "grc";
				action = "<CMD>Telescope lsp_incoming_calls theme=dropdown<CR>";
				options.desc = "Telescope lsp_incoming_calls";
			}
		];
	};
}
