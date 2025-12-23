{pkgs, ... }:
let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
	inherit (pkgs.lib) fakeHash;
in{
	programs.nixvim = {
		# We want this to run after mini to override the mappings with ours
		highlightOverride = {
			TreesitterContext = { link = "CursorLine"; };
		};
		plugins = {
			nvim-better-n = {
				enable = true;
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
					before.__raw = '' function()
						require('lz.n').trigger_load("mini.nvim")
						require('lz.n').trigger_load("gitsigns.nvim")
					end'';
				};
				settings = {
					disable_default_mappings = true;
					disable_cmdline_mappings = true;
				};
				luaConfig.post = builtins.readFile ./plugins-post-config/nvim-better-n.lua;
			};
			treesitter-context = {
				enable = true;
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
					before.__raw = '' function()
						require('lz.n').trigger_load("nvim-treesitter")
					end'';
				};
				settings = {
					max_lines = 3;
					min_window_height = 20;
					line_numbers = false;
				};
			};
			ts-autotag = {
				enable = true;
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
					before.__raw = '' function()
						require('lz.n').trigger_load("nvim-treesitter")
					end'';
				};
			};
			treesitter = {
				enable = true;
				# folding = { enable = true;};
				lazyLoad.settings = { event = "DeferredUIEnter"; };
				grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
					markdown markdown_inline latex
					html
					typst
					lua
					json
					make
					vim
					vimdoc
					toml
					xml
					yaml
					nix
					java
					c
					regex
					nu
					idris
					http
				];
				settings = {
					highlight = {
						enable = true;
						disable = [
							"idris2" # use default regex
						];
					};
					indent.enable = true;
				};
			};
			iswap = {
				enable = true;
				lazyLoad.settings = {
					cmd = ["ISwap" "ISwapWith"];
					before.__raw = '' function()
						require('lz.n').trigger_load("nvim-treesitter")
					end'';
					keys = [
						{
							__unkeyed-1 = "<C-s>";
							__unkeyed-2 = "<CMD>ISwap<CR>";
							desc = "Swap 2 treesitter nodes";
						}
						{
							__unkeyed-1 = "<C-s>";
							__unkeyed-2 = "<CMD>ISwapWith<CR>";
							mode = [ "i" ];
							desc = "Swap Current TS node with another";
						}
					];
				};
			};
		};
	};
}
