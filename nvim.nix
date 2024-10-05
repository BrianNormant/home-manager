{pkgs, ...}: {
		enable = true;
		withPython3 = true;
		extraPackages = with pkgs; [
			# Install lsp here
			jdt-language-server # java
			clang-tools # c/cpp
			phpactor # php
			idris2Packages.idris2Lsp # idris2
			lua-language-server # lua
			nil # nix
			lemminx # xml
			# Install dap here
			gdb # c/cpp
			elixir-ls # elixir
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
			clang elixir
		];

		plugins = with pkgs.vimPlugins; let
		configPlugin = {
			plugin,
			src ? null,
			preLua ? "",
			config ? true,
		}: {
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
			(configPlugin {plugin = gruvbox-material;})
			(configPlugin {
				plugin.pname = "ts-node-action";
				src = {
					owner = "CKolkey";
					repo = "ts-node-action";
					rev = "6d3b607";
					hash = "sha256-kOXH3r+V+DAxoATSnZepEAekrkO1TezKSkONuQ3Kzu4=";
				};
				config = false;
			})
			vim-suda
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
			vim-repeat
			vim-lastplace
			(configPlugin {plugin = leap-nvim;})
			(configPlugin {
				plugin.pname = "telepath.nvim";
				src = {
					owner = "rasulomaroff";
					repo = "telepath.nvim";
					rev = "2879da0"; # Fri Sep 27 05:01:10 PM EDT 2024
					hash = "sha256-h1NILk/EAbhb9jONHAApFs9Z2f8oZsWy15Ici6+TLxw=";
				};
			})
			nvim-ts-autotag
			(configPlugin {plugin = nvim-autopairs;})
			(configPlugin {plugin = boole-nvim;})
			(configPlugin {plugin = registers-nvim;})
			(configPlugin {plugin = marks-nvim;})
			(configPlugin {plugin = guess-indent-nvim;})
			(configPlugin {plugin = nvim-bqf;})
			(configPlugin {
				plugin.pname = "iswap.nvim";
				src = {
					owner = "mizlan";
					repo = "iswap.nvim";
					rev = "e02cc91";
					hash = "sha256-lAYHvz23f9nJ6rb0NIm+1aq0Vr0SwjPVitPuROtUS2A=";
				};
			})
			telescope-lsp-handlers-nvim
			(configPlugin {plugin = telescope-nvim;})
			no-neck-pain-nvim
			vim-wakatime
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
			lazygit-nvim
			 (configPlugin {
				plugin.pname = "muren.nvim";
				src = {
					owner = "AckslD";
					repo = "muren.nvim";
					rev = "b6484a1";
					sha256 = "hv8IfNJ+3O1L1PPIZlPwXc37Oa4u8uZPJmISLnNkBGw=";
				};
			})
			(configPlugin {plugin = persisted-nvim;})

			# Mini.nvim plugins
			(configPlugin {plugin = mini-align;})
			(configPlugin {plugin = mini-extra;})
			(configPlugin {plugin = mini-ai;})
			(configPlugin {plugin = nvim-notify;})
			(configPlugin {plugin = neoscroll-nvim;})
			(configPlugin {plugin = mini-bracketed;})
			(configPlugin {plugin = mini-clue;})
			(configPlugin {plugin = mini-move;})
			(configPlugin {plugin = mini-indentscope;})
			rainbow-delimiters-nvim # Auto load itself
			(configPlugin {plugin = indent-blankline-nvim;})
			(configPlugin {plugin = mini-operators;})
			(configPlugin {plugin = mini-starter;})
			(configPlugin {plugin = mini-surround;}) # replace vim-surround
			(configPlugin {plugin = nvim-treesitter-textsubjects;})  # Must be loaded after ai to override ; mapping
			(configPlugin {plugin = oil-nvim;})
			(configPlugin {plugin = nvim-navbuddy;})
			(configPlugin {
				plugin.pname = "diagflow.nvim";
				src = {
					owner = "dgagn";
					repo = "diagflow.nvim";
					rev = "fc09d55";
					hash = "sha256-2WNuaIEXcAgUl2Kb/cCHEOrtehw9alaoM96qb4MLArw=";
				};
			})
			(configPlugin {plugin = lsp_signature-nvim;})
			(configPlugin {plugin = actions-preview-nvim;})

			# coq-artifacts
			# coq-thirdparty
			# (configPlugin {plugin = coq_nvim;})

			# Snippets
			friendly-snippets
			(configPlugin {
				plugin.pname = "luasnip-snippers.nvim";
				src = {
					owner = "molleweide";
					repo = "LuaSnip-snippets.nvim";
					rev = "d7e40e4";
					hash = "sha256-iFpk2dmcdF3krwem0Agl044ML2syw61wWPX7ldz4bhg=";
				};
				config = false;
			})
			vim-snippets
			(configPlugin {plugin = luasnip;})


			# LSP
			(configPlugin {plugin = lsp-zero-nvim.overrideAttrs {
				src = pkgs.fetchFromGitHub {
					owner = "VonHeikemen";
					repo = "lsp-zero.nvim";
					rev = "b841170";
					hash = "sha256-QEd5UXBLz3Z6NL9TMPlJmfYugs4Ec3zpEUWwei6jPKs=";
				};
			};})

			# AutoCompletion
			cmp-nvim-lsp cmp-async-path
			supermaven-nvim cmp-treesitter
			(configPlugin {plugin = nvim-cmp;})
			(configPlugin {plugin = lspkind-nvim;})

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
			(configPlugin {
				plugin.pname = "spellwarn.nvim";
				src = {
					owner = "ravibrock";
					repo  = "spellwarn.nvim";
					rev   = "2f4dbc5";
					hash  = "sha256-BE02RNS2j4TwUvZEWaQQYXfHR5eGj/EuCSue+eeUySI=";
				};
			})
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
				local vscodepath = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}"
				'';
			 })
			(configPlugin {
				plugin.pname = "mdeval.nvim";
				src = {
					owner = "jubnzv";
					repo = "mdeval.nvim";
					rev = "79df3e7";
					hash = "sha256-XFnAGMA1kHfqDqdGY2UvXFwxJUT2E+TvwUy8+RShBlM=";
				};
			})
			(configPlugin {plugin = rest-nvim;})
			(configPlugin {plugin = vim-dadbod;})
# Database
			vim-dadbod-ui
			vim-dadbod-completion
			(configPlugin {plugin = idris2-nvim;})
			(configPlugin {
				plugin.pname = "dbext.vim";
					 src = {
						 owner = "vim-scripts";
						 repo = "dbext.vim";
						 rev = "23.00";
						 hash = "sha256-tl64aKJyK8WTJRif8q3LTUb/D/qUV4AiQ5wnZFzGuQ4=";
					 };
				config = false;
			})

# Markdown, CSV,
			markdown-preview-nvim
			(configPlugin {plugin = markview-nvim;})

# Compile and run from vim
			(configPlugin {plugin = compiler-nvim.overrideAttrs {
				 src = pkgs.fetchFromGitHub {
					 owner = "BrianNormant";
					 repo = "compiler.nvim";
					 rev = "353a094";
					 sha256 = "sha256-YItRjdgHlRwoC0jBFLpul/lc5Z75gSA99YObEjePmj8=";
				 };
			 };})

# Treesitter
			nvim-treesitter
			nvim-treesitter-endwise
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
				}) ] ++ nvim-treesitter.allGrammars
			)))
			(configPlugin {plugin = legendary-nvim;})
		];
	extraLuaConfig = builtins.readFile ./nvim-extra.lua;
}
