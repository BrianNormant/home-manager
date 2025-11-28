{pkgs, ... }:
let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
	inherit (pkgs.lib) fakeHash;
in{
	programs.nixvim = {
		extraPlugins = [
			{
				plugin = buildVimPlugin rec {
					pname = "nvim-better-n";
					version = "v0.0.1";
					src = fetchFromGitHub {
						owner = "jonatan-branting";
						repo = "nvim-better-n";
						rev = "95d8ce2";
						hash = "sha256-Y/b7iXXQw9hbZ2uAkcJNuKt30pn2Vdsk/IOjBJ3QjAM=";
					};
				};
				optional = true;
			}
			{
				plugin = buildVimPlugin rec {
					pname = "iswap.nvim";
					version = "e02cc91";
					buildInputs = with pkgs.vimPlugins; [
						nvim-treesitter
					];
					src = fetchFromGitHub {
						owner = "mizlan";
						repo = "iswap.nvim";
						rev = version;
						hash = "sha256-lAYHvz23f9nJ6rb0NIm+1aq0Vr0SwjPVitPuROtUS2A=";
					};
				};
				optional = true;
			}
			{
				plugin = pkgs.vimPlugins.nvim-treesitter-textsubjects;
				optional = true;
			}
		];
		# We want this to run after mini to override the mappings with ours
		extraConfigLuaPost = builtins.readFile ./treesitter.lua;
		highlightOverride = {
			TreesitterContext = { link = "CursorLine"; };
		};
		plugins = {
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
				folding = true;
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
		};
		keymaps = [
			{
				key = "<C-s>";
				action = "<CMD>ISwap<CR>";
				options.desc = "Swap 2 treesitter nodes";
			}
			{
				key = "<C-s>";
				action = "<CMD>ISwapWith<CR>";
				options.desc = "Swap Current TS node with another";
				mode = [ "i" ];
			}
		];
	};
}
