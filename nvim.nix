{pkgs, ...}: {
		enable = true;
		withPython3 = true;
		extraPackages = with pkgs; [
			# Install lsp here
			jdt-language-server # java
			clang-tools # c/cpp
			phpactor # php
			lua-language-server # lua
			svelte-language-server # svelte
			typescript-language-server # typescript
			nil # nix
			lemminx # xml
			# Install dap here
			gdb # c/cpp
			elixir-ls # elixir
			idris2Packages.idris2Lsp
			# Install none-ls depencencies (linter/formatter/static analyzer) here
			statix checkstyle cppcheck
			# other dependencies for plugins
			vscode-extensions.vscjava.vscode-java-debug
			curl
			jq html-tidy
			tree-sitter
			ripgrep
			fswatch
			fd
			yarn nodePackages_latest.nodejs
			jdk17 jdk # 21
			clang elixir cling
			python312Packages.ipython
		];

		plugins = with pkgs.vimPlugins; let
		configPlugin = {
			plugin,
			src ? null,
			preLua ? "",
			config ? true,
			optional ? true,
		}: {
			inherit optional;
			plugin = if src == null
				then plugin
				else pkgs.vimUtils.buildVimPlugin {
					inherit (plugin) pname;
					version = "${src.rev}";
					src = pkgs.fetchFromGitHub src;
				};
			config = let
			config-file = pkgs.writeText
				("vimconfig-" + plugin.pname)
				( preLua + builtins.readFile (./nvim-plugins-config + ("/" + plugin.pname + ".lua")));
			in if config then "luafile ${config-file}" else "";
		};
		in [
			(configPlugin { plugin = lze; optional = false;})
			vim-repeat
			(configPlugin {plugin = gruvbox-material;})
			(configPlugin {plugin = vim-suda;})
			(configPlugin {plugin = vim-lastplace;})
			(configPlugin {plugin = vim-wakatime;})
			(configPlugin {plugin = vim-fugitive;})
			(configPlugin {plugin = dressing-nvim;})
			(configPlugin {plugin = dropbar-nvim;})
			(configPlugin {plugin = nvim-treesitter-context;})
			(configPlugin {plugin = ccc-nvim;})
			(configPlugin {plugin = gitsigns-nvim;})
			(configPlugin {plugin = diffview-nvim;})
			(configPlugin {plugin = lualine-nvim;})
			(configPlugin {plugin = tabby-nvim;})
			(configPlugin {plugin = comment-nvim;})
			(configPlugin {plugin = nvim-ufo;})
			# leap, telepath and flit are configured at the same place
			(configPlugin {plugin = leap-nvim; optional = false;})
			(configPlugin {
				plugin.pname = "telepath.nvim";
				src = {
					owner = "rasulomaroff";
					repo = "telepath.nvim";
					rev = "2879da0"; # Fri Sep 27 05:01:10 PM EDT 2024
					hash = "sha256-h1NILk/EAbhb9jONHAApFs9Z2f8oZsWy15Ici6+TLxw=";
				};
				config = false; optional = false;
			})
			(configPlugin {
				plugin.pname = "flit.nvim";
				src = {
					owner = "ggandor";
					repo = "flit.nvim";
					rev = "1ef72de"; # Fri Sep 27 05:01:10 PM EDT 2024
					hash = "sha256-lLlad/kbrjwPE8ZdzebJMhA06AqpmEI+PJCWz12LYRM=";
				};
				config = false;
			})

			(configPlugin {plugin = nvim-ts-autotag; config = false;})
			(configPlugin {plugin = nvim-treesitter-endwise; config = false;})
			(configPlugin {plugin = nvim-autopairs;})
			(configPlugin {plugin = codewindow-nvim;})
			(configPlugin {plugin = boole-nvim;})
			(configPlugin {plugin = registers-nvim;})
			(configPlugin {plugin = marks-nvim;})
			(configPlugin {plugin = guess-indent-nvim;})
			(configPlugin rec {
				plugin.pname = "quicker.nvim";
				src = {
					owner = "stevearc";
					repo = plugin.pname;
					rev = "183041a";
					hash = "sha256-vhDXkE33NkiCs8PUB2PIzljaL15V3Ac62FRgnEZs06M=";
				};
			})
			(configPlugin {plugin = nvim-bqf;})
			# (configPlugin {
			# 	plugin.pname = "iswap.nvim";
			# 	src = {
			# 		owner = "mizlan";
			# 		repo = "iswap.nvim";
			# 		rev = "e02cc91";
			# 		hash = "sha256-lAYHvz23f9nJ6rb0NIm+1aq0Vr0SwjPVitPuROtUS2A=";
			# 	};
			# })

			(configPlugin {plugin = telescope-ui-select-nvim; config = false;})
			(configPlugin {plugin = telescope-lsp-handlers-nvim; config = false;})
			(configPlugin {plugin = telescope-nvim;})
			(configPlugin {plugin = no-neck-pain-nvim;})
			(configPlugin {plugin = nvim-web-devicons;})
			(configPlugin {
				plugin.pname = "icon-picker.nvim";
				src = {
					owner = "ziontee113";
					repo = "icon-picker.nvim";
					rev = "3ee9a0e";
					sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
				};
			})
			# (configPlugin {
			# 	plugin.pname = "muren.nvim";
			# 	src = {
			# 		owner = "AckslD";
			# 		repo = "muren.nvim";
			# 		rev = "b6484a1";
			# 		sha256 = "hv8IfNJ+3O1L1PPIZlPwXc37Oa4u8uZPJmISLnNkBGw=";
			# 	};
			# })
			(configPlugin {plugin = persisted-nvim;})

			# Mini.nvim plugins
			(configPlugin {plugin = mini-cursorword;})
			(configPlugin {plugin = mini-align;})
			(configPlugin {plugin = mini-extra;})
			(configPlugin {plugin = mini-ai;})
			# (configPlugin {plugin = nvim-notify;})
			(configPlugin {plugin = mini-bracketed; config = false;})
			(configPlugin {plugin = mini-move;})
			rainbow-delimiters-nvim # Auto load itself
			(configPlugin {plugin = indent-blankline-nvim;})
			(configPlugin {plugin = mini-operators;})
			(configPlugin {plugin = mini-surround;}) # replace vim-surround
			(configPlugin {plugin = nvim-treesitter-textsubjects;})
			(configPlugin {plugin = oil-nvim;})
			(configPlugin {plugin = nvim-navbuddy;})
			(configPlugin {plugin = glance-nvim;})
			(configPlugin {
				plugin.pname = "diagflow.nvim";
				src = {
					owner = "dgagn";
					repo = "diagflow.nvim";
					rev = "fc09d55";
					hash = "sha256-2WNuaIEXcAgUl2Kb/cCHEOrtehw9alaoM96qb4MLArw=";
				};
			})
			
			# LSP
			(configPlugin {plugin = inc-rename-nvim;})
			# (configPlugin {plugin = lsp_signature-nvim;})
			(configPlugin {plugin = actions-preview-nvim;})
			(configPlugin {plugin = fidget-nvim;})
			(configPlugin {plugin = nvim-lspconfig; config = false;})
			# (configPlugin {plugin = nvim-lightbulb;})
			(configPlugin {plugin = lsp-zero-nvim.overrideAttrs {
				src = pkgs.fetchFromGitHub {
					owner = "VonHeikemen";
					repo = "lsp-zero.nvim";
					rev = "b841170";
					hash = "sha256-QEd5UXBLz3Z6NL9TMPlJmfYugs4Ec3zpEUWwei6jPKs=";
				};
			};})
			# Documentation
			(configPlugin {plugin = nvim-docs-view;})
			(configPlugin {plugin = hover-nvim;})
			# Auto Completion
			(configPlugin {plugin = friendly-snippets; config=false;})
			(configPlugin {plugin = vim-snippets; config=false;})
			(configPlugin {plugin = supermaven-nvim; config=false;})
			(configPlugin {
				plugin = pkgs.blink;
				preLua = ''
				local vim_snippets_path = "${vim-snippets}"
				'';
			})

			# (configPlugin {plugin = sniprun;})


			(configPlugin {plugin = goto-preview;})
			(configPlugin {
				plugin.pname = "symbol-usage.nvim";
				src = {
					owner = "Wansmer";
					repo = "symbol-usage.nvim";
					rev = "0f9b3da";
					hash = "sha256-vNVrh8MV7KZoh2MtP+hAr6Uz20qMMMUcbua/W71lRn0=";
				};
			})
# Lint and Format
			(configPlugin {plugin = none-ls-nvim;})
			(configPlugin {plugin = nvim-lint;})
			# (configPlugin {
			# 	plugin.pname = "spellwarn.nvim";
			# 	src = {
			# 		owner = "ravibrock";
			# 		repo  = "spellwarn.nvim";
			# 		rev   = "2f4dbc5";
			# 		hash  = "sha256-BE02RNS2j4TwUvZEWaQQYXfHR5eGj/EuCSue+eeUySI=";
			# 	};
			# })
# Debugger
			(configPlugin {plugin = nvim-dap-ui;})
			(configPlugin {
				 plugin.pname = "gen.nvim";
				 src = {
					owner = "David-Kunz";
					repo  = "gen.nvim";
					rev   = "2ee646f";
					hash  = "sha256-j+FB5wjiWwq5YEHx+CDGN4scMr7+TkUoAX63WHiziaU=";
				 };
			})

			(configPlugin {
				# plugin = nvim-jdtls.overrideAttrs {
				# 	src = pkgs.fetchFromGitHub {
				# 		owner = "BrianNormant";
				# 		repo  = "nvim-jdtls";
				# 		rev   = "HEAD";
				# 		hash = "sha256-LrTFSGls19y2Ikai8UvYPIuyJeVUDwlejh7z4GpgKC8=";
				# 	};
				# };
				plugin = nvim-jdtls;
				preLua = ''
				local java_debug = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}"
				'';
			 })
			(configPlugin {
				plugin.pname = "mdeval.nvim";
				src = {
					owner = "BrianNormant";
					repo = "mdeval.nvim";
					rev = "87fccb2";
					hash = "sha256-BjYl6RScUsTNOZziHDRhBHVeTXjsEwCHiz93rLy0Ycc=";
				};
			})
			(configPlugin {plugin = rest-nvim;})

			(configPlugin {plugin = vim-dadbod-ui; config = false;})
			# (configPlugin {plugin = vim-dadbod-completion; config = false;}) # TODO add completion for blink.cmp
			(configPlugin {plugin = vim-dadbod;})
# Database
			(configPlugin {plugin = idris2-nvim;})
			# (configPlugin {
			# 	plugin.pname = "dbext.vim";
			# 		 src = {
			# 			 owner = "vim-scripts";
			# 			 repo = "dbext.vim";
			# 			 rev = "23.00";
			# 			 hash = "sha256-tl64aKJyK8WTJRif8q3LTUb/D/qUV4AiQ5wnZFzGuQ4=";
			# 		 };
			# 	config = false;
			# 	optional = false;
			# })

# Markdown, CSV,
			(configPlugin {plugin = markdown-preview-nvim;})
			(configPlugin {plugin = markview-nvim.overrideAttrs {
				src = pkgs.fetchFromGitHub {
					owner = "OXY2DEV";
					repo = "markview.nvim";
					rev = "493c054";
					hash = "sha256-x23NtAaOP/p7U460o9lRqYvJdGqzW4/kPgBbUBgV0j4=";
				};
			};})

			(configPlugin {
				plugin.pname = "nvim-better-n";
				src = {
					owner = "jonatan-branting";
					repo = "nvim-better-n";
					rev = "73a16d9";
					hash = "sha256-4SjjPNPrPF0kPBiJBd2VMNU5UuEJbYe9YGWB15PPNVQ=";
				};
			})
# Treesitter
			(configPlugin { plugin = nvim-treesitter;})
			(nvim-treesitter.withPlugins (_: (
				[
				(pkgs.tree-sitter.buildGrammar {
					 language = "nu";
					 version = "8af0aab";
					 src = pkgs.fetchFromGitHub {
						 owner = "nushell";
						 repo = "tree-sitter-nu";
						 rev = "0bb9a60";
						 hash = "sha256-A5GiOpITOv3H0wytCv6t43buQ8IzxEXrk3gTlOrO0K0=";
					};
				})
				(pkgs.tree-sitter.buildGrammar {
					language = "idris";
					version = "alpha";
					src = pkgs.fetchFromGitHub {
						owner = "kayhide";
						repo = "tree-sitter-idris";
						rev = "c56a25c";
						hash = "sha256-aOAxb0KjhSwlNX/IDvGwEysYvImgUEIDeNDOWRl1qNk=";
					};
				})
				] ++ nvim-treesitter.allGrammars
			)))
			(configPlugin {plugin = legendary-nvim;})
			(configPlugin {plugin = which-key-nvim;})
		];
	extraLuaConfig = builtins.readFile ./nvim-extra.lua;
}
