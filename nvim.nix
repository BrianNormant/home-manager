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
			lemminx # xmp
			# Install dap here
			gdb # c/cpp
			elixir-ls # elixir
			# Install none-ls depencencies (linters/formatter/static analyzer) here
			statix checkstyle cppcheck
			# oracle-instantclient
			# other depencencies for plugins
			vscode-extensions.vscjava.vscode-java-debug
			curl
			jq html-tidy
			tree-sitter
			ripgrep
			fswatch
			fd
			yarn nodePackages_latest.nodejs
			jdk8 jdk17 jdk # 21
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
				(plugin.pname + "config")
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
			(configPlugin {plugin = modicator-nvim;})
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
			lexima-vim
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
			# https://github.com/Wansmer/binary-swap.nvim
			telescope-lsp-handlers-nvim
			(configPlugin {plugin = telescope-nvim;})
			(configPlugin {plugin = true-zen-nvim.overrideAttrs {
				src = pkgs.fetchFromGitHub {
					owner = "mrcapivaro";
					repo = "true-zen.nvim";
					rev = "6aee7f2";
					hash = "sha256-BRmMdjhzCogsNrEU9nz+OYx+m8VNJXo5V2i15z+liag=";
				};
			};})
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
			# TODO Search and replace for all the files.
			 (configPlugin {
				plugin.pname = "muren.nvim";
				src = {
					owner = "AckslD";
					repo = "muren.nvim";
					rev = "b6484a1";
					sha256 = "hv8IfNJ+3O1L1PPIZlPwXc37Oa4u8uZPJmISLnNkBGw=";
				};
			})

			# Mini.nvim plugins
			(configPlugin {plugin = mini-align;})
			(configPlugin {plugin = mini-ai;})
			(configPlugin {plugin = nvim-notify;})
			(configPlugin {plugin = neoscroll-nvim;})
			(configPlugin {plugin = mini-bracketed;})
			(configPlugin {plugin = mini-clue;})
			(configPlugin {plugin = mini-move;})
			(configPlugin {plugin = mini-indentscope;})
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
			# (configPlugin {plugin = diaglist-nvim;})

			# coq-artifacts
			# coq-thirdparty
			# (configPlugin {plugin = coq_nvim;})

			# Snippets
			friendly-snippets
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
			cmp-buffer cmp-spell cmp-nvim-lsp cmp-nvim-lsp-document-symbol cmp-async-path cmp-latex-symbols
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
			(configPlugin {
				plugin.pname = "neodim";
				src = {
					owner = "zbirenbaum";
					repo = "neodim";
					rev = "d874708";
					hash = "sha256-3DHohSXaSt51iBIdIJcUN/YWOEprpq4H5XPQ6TCI4w4=";
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
				plugin = nvim-jdtls.overrideAttrs {
					src = pkgs.fetchFromGitHub {
						owner = "BrianNormant";
						repo  = "nvim-jdtls";
						rev   = "2a2ccec";
						hash  = "sha256-B7WPGkVr/jvBCdtuo3RHCc+ZRmGK8WVzqBMlBUkRpLY=";
					};
				};
				preLua = ''
				local vscodepath = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}"
				'';
			 })

			(configPlugin {plugin = rest-nvim;})
			(configPlugin {plugin = vim-dadbod;})
# DataBase
			vim-dadbod-ui
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
			(nvim-treesitter.withPlugins (_: (
				[nvim-treesitter-parsers.java
				nvim-treesitter-parsers.lua
				nvim-treesitter-parsers.c
				nvim-treesitter-parsers.xml
				nvim-treesitter-parsers.json
				nvim-treesitter-parsers.graphql
				nvim-treesitter-parsers.elixir
				nvim-treesitter-parsers.nix
				nvim-treesitter-parsers.gnuplot
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
		extraLuaConfig = # (builtins.readFile ./ollama-Gen-nvim.lua ) +
				''
				vim.opt.clipboard:append "unnamedplus"
				vim.opt.scrolloff = 5

				vim.opt.tabstop = 4
				vim.opt.shiftwidth = 4
				vim.opt.laststatus = 3
				vim.opt.showtabline = 2
				vim.opt.expandtab = false -- set to true to use space instead of tab


				-- enable spell check
				vim.opt.spelllang = 'en_us'
				vim.opt.spell = true
				--- clear spell check highlights
				vim.cmd [[
				hi clear SpellBad
				hi clear SpellCap
				hi clear SpellRare
				hi clear SpellLocal
				]]

				vim.o.cursorline = true
				vim.o.number = true
				vim.o.relativenumber = true

				vim.o.foldenable = true
				vim.o.foldmethod = "syntax"

				vim.cmd "set listchars=tab:··>,trail:█,nbsp:󱁐"
				vim.cmd "set invlist"

				-- Open help in a new tab
				vim.cmd "cabbrev h tab help"

				-- Open Man in a new tab
				vim.cmd "cabbrev Man tab Man"

				vim.cmd [[
				function! DiffRegsFunc(...)
					let l:left = a:0 == 2 ? a:1 : "@0"
					let l:right = a:0 == 2 ? a:2 : "@1"

					tabnew
					exe 'put! ='. l:left
					vnew
					exe 'put! ='. l:right

					windo setlocal buftype=nofile
					windo setlocal bufhidden=delete
					windo setlocal noswapfile
					windo diffthis
					winc t
					endfunction
					com -nargs=* DiffRegs call DiffRegsFunc(<f-args>)
				]]
				'';
			 }
