{pkgs, ... }:
let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
	inherit (pkgs.lib) fakeHash;
in{
	programs.nixvim = {
		extraPlugins = [
			( buildVimPlugin rec {
				pname = "nvim-better-n";
				version = "v0.0.1";
				src = fetchFromGitHub {
					owner = "jonatan-branting";
					repo = "nvim-better-n";
					rev = "73a16d9";
					hash = "sha256-4SjjPNPrPF0kPBiJBd2VMNU5UuEJbYe9YGWB15PPNVQ=";
				};
			})
			( buildVimPlugin rec {
				pname = "iswap-nvim";
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
			})
			pkgs.vimPlugins.nvim-treesitter-textsubjects
		];
		# We want this to run after mini to override the mappings with ours
		extraConfigLuaPost = builtins.readFile ./treesitter.lua;
		highlightOverride = {
			TreesitterContext = { link = "CursorLine"; };
		};
		plugins = {
			treesitter-context = {
				enable = true;
				lazyLoad.settings = { event = [ "DeferredUIEnter" ]; };
			};
			ts-autotag = {
				enable = true;
				lazyLoad.settings = { event = [ "DeferredUIEnter" ]; };
			};
			treesitter = {
				enable = true;
				folding = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
				grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
					markdown
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
					(buildGrammar {
						 language = "nu";
						 version = "2.1.1";
						 src = fetchFromGitHub {
							 owner = "nushell";
							 repo = "tree-sitter-nu";
							 rev = "d5c71a1";
							 hash = "sha256-7Ny3wXa5iE6s7szqTkPqaXWL/NL5yA2MbhdQHylxwE0=";
						};
					})
					(buildGrammar {
						language = "idris";
						version = "alpha";
						src = fetchFromGitHub {
							owner = "kayhide";
							repo = "tree-sitter-idris";
							rev = "c56a25c";
							hash = "sha256-aOAxb0KjhSwlNX/IDvGwEysYvImgUEIDeNDOWRl1qNk=";
						};
					})
				];
				settings = {
					highlight = {
						enable = true;
						additional_vim_regex_highlighting = [
							"idris2"
							"idr"
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
