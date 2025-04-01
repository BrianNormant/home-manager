{pkgs, ... }:
let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
in{
	programs.nixvim = {
		extraPlugins = [( buildVimPlugin rec {
			pname = "nvim-better-n";
			version = "bddb1c9";
			src = {
				owner = "jonatan-branting";
				repo = "nvim-better-n";
				rev = version;
				hash = pkgs.lib.fakeHash;
			};
		})];
		extraConfigLua = builtins.readFile ./treesitter.lua;
		plugins.treesitter-context = {
			enable = true;
		};
		plugins.ts-autotag = {
			enable = true;
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
						 hash = pkgs.lib.fakeHash;
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
