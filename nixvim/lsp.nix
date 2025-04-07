{pkgs, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;
in {
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
			glance = {
				enable = true;
				settings.border = { enable = true; };
				settings.mappings.list.__raw = ''
				{
					['j']         = require('glance').actions.next, -- Next item
					['k']         = require('glance').actions.previous, -- Previous item
					['<Down>']    = require('glance').actions.next,
					['<Up>']      = require('glance').actions.previous,
					['<Tab>']     = require('glance').actions.next_location, -- Next location (skips groups, cycles)
					['<S-Tab>']   = require('glance').actions.previous_location, -- Previous location (skips groups, cycles)
					['<C-u>']     = require('glance').actions.preview_scroll_win(5), -- Scroll up the preview window
					['<C-d>']     = require('glance').actions.preview_scroll_win(-5), -- Scroll down the preview window
					['v']         = require('glance').actions.jump_vsplit, -- Open location in vertical split
					['s']         = require('glance').actions.jump_split, -- Open location in horizontal split
					['t']         = require('glance').actions.jump_tab, -- Open in new tab
					['<CR>']      = require('glance').actions.jump, -- Jump to location
					['o']         = require('glance').actions.jump,
					['l']         = require('glance').actions.open_fold,
					['h']         = require('glance').actions.close_fold,
					['<leader>l'] = require('glance').actions.enter_win('preview'), -- Focus preview window
					['q']         = require('glance').actions.close, -- Closes Glance window
					['Q']         = require('glance').actions.close,
					['<Esc>']     = require('glance').actions.close,
					['<C-q>']     = require('glance').actions.quickfix, -- Send all locations to quickfix list
					['g?']        = function()
						${builtins.readFile ./glance-help-fn.lua}
					end,
				}
				'';
				settings.mappings.preview.__raw = ''
				{
					['Q']         = require('glance').actions.close,
					['<Tab>']     = require('glance').actions.next_location, -- Next location (skips groups, cycles)
					['<S-Tab>']   = require('glance').actions.previous_location, -- Previous location (skips groups, cycles)
					['<leader>l'] = require('glance').actions.enter_win('list'), -- Focus list window
					['g?']        = function()
						${builtins.readFile ./glance-help-preview-fn.lua}
					end,
				},
				'';
			};
			inc-rename = {
				enable = true;
				settings = {
					cmd_name = "IncRename";
					input_buffer_type = "dressing";
				};
			};
			fidget = {
				enable = true;
				lazyLoad.settings = { event = ["LspAttach"]; };
			};
		};
		extraPlugins = with pkgs.vimPlugins; [
			actions-preview-nvim
			hover-nvim
			nvim-docs-view
			goto-preview
			(buildVimPlugin rec {
				pname = "action-hints-nvim";
				version = "ab10fef";
				src = fetchFromGitHub {
					owner = "roobert";
					repo = "action-hints.nvim";
					rev = version;
					hash = "sha256-BTXmb1uGbXKkORnf1hbEa8jEmpPpzjMaerdldo5tkxs=";
				};
			})
			(buildVimPlugin rec {
				pname = "symbol-usage-nvim";
				version = "0f9b3da";
				src = fetchFromGitHub {
					owner = "Wansmer";
					repo = "symbol-usage.nvim";
					rev = version;
					hash = "sha256-vNVrh8MV7KZoh2MtP+hAr6Uz20qMMMUcbua/W71lRn0=";
				};
			})
		];
		extraConfigLua = builtins.readFile ./lsp.lua;
	};
}
