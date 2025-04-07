{pkgs, ... }:
let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
in{
	programs.nixvim = {
		extraPlugins = [( buildVimPlugin rec {
			pname = "nvim-better-n";
			version = "v0.0.1";
			src = fetchFromGitHub {
				owner = "jonatan-branting";
				repo = "nvim-better-n";
				rev = "73a16d9";
				hash = "sha256-4SjjPNPrPF0kPBiJBd2VMNU5UuEJbYe9YGWB15PPNVQ=";
			};
		})];
		# We want this to run after mini to override the mappings with ours
		extraConfigLuaPost = builtins.readFile ./treesitter.lua;
		plugins.treesitter-context = {
			enable = true;
		};
		highlightOverride = {
			TreesitterContext = { link = "CursorLine"; };
		};
		plugins.ts-autotag = {
			enable = true;
			lazyLoad.settings = {
				event = [ "DeferredUIEnter" ];
			};
		};
		plugins.treesitter = {
			enable = true;
			folding = true;

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
		};
	};
}
