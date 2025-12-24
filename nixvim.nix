{config, pkgs, lib, ... }:
let
	inherit (pkgs) vimPlugins;
	customNixVimModules = with pkgs.lib;
		builtins.readDir ./nixvim/plugins |>
		filterAttrs (n: v: v == "regular") |>
		mapAttrsToList (n: v: ./nixvim/plugins/${n});
in {

	options.nixvim = {
		colorscheme = lib.mkOption {
			type = lib.types.enum [ "gruvbox" "cuddlefish" "melange"];
		};
		ollama_model = lib.mkOption {
			type = lib.types.str;
		};
	};
	imports = [
		# UI
		./nixvim/colorscheme.nix
		./nixvim/dropbar.nix
		./nixvim/tabline.nix
		./nixvim/fold.nix
		./nixvim/indent.nix
		./nixvim/treesitter.nix
		./nixvim/starter.nix
		./nixvim/ui.nix

		# Quality of life
		./nixvim/qol.nix
		./nixvim/mini.nix
		./nixvim/leap.nix
		./nixvim/registers.nix
		./nixvim/quickfix.nix
		./nixvim/oil.nix
		./nixvim/search-replace.nix
		./nixvim/symbol-picker.nix
		./nixvim/telescope.nix
		./nixvim/terminal.nix
		
		# Languages
		./nixvim/java.nix
		./nixvim/idris2.nix
		./nixvim/markdown.nix
		./nixvim/help.nix
		./nixvim/nix.nix
		./nixvim/rest.nix

		# Others
		./nixvim/keymaps.nix
		./nixvim/git.nix
		./nixvim/lsp.nix
		./nixvim/lsp-keymaps.nix
		./nixvim/linter.nix
		./nixvim/completion.nix
		./nixvim/dap.nix
		./nixvim/ai.nix
		./nixvim/others.nix
		./nixvim/overseer.nix
	];

	config = {

		nixvim = {
			colorscheme = "melange";
			ollama_model = "gemma3:27b";
		};

		home.packages = with pkgs; [
			vim-startuptime
			neovide
		];

		programs.nixvim = {
			enable = true;
			# without global packages, nixvim will not find packages from overlays
			nixpkgs.useGlobalPackages = true;
			imports = customNixVimModules;
			performance = {
				byteCompileLua = {
					enable = true;
					configs = true;
					initLua = true;
					nvimRuntime = true;
					plugins = true;
				};
				combinePlugins = {
					enable = true;
					standalonePlugins = [
						"nvim-treesitter"
						"mini.nvim"
						"friendly-snippets"
					];
				};
			};
			extraPlugins = with pkgs.vimPlugins; [
				vim-tridactyl
			];
			plugins = {
				lz-n.enable = true;
				lz-n.autoLoad = true;
				vim-suda.enable = true;
				repeat.enable = true;
				lastplace.enable = true;
				guess-indent.enable = true;
				neotest.enable = false;
			};
			extraPackages = with pkgs; [
				ripgrep
				wkhtmltopdf
			];
			clipboard.register = "unnamedplus";
			globalOpts = {
				# UI
				laststatus = 3;
				showmode = false;
				showtabline = 2;
				cmdheight = 1;
				scrolloff = 5;
				cursorline = true;
				number = true;
				relativenumber = true;
				list = true;
				listchars = {
					tab = "··>";
					trail = "█";
					nbsp = "󱁐";
				};

				# Fold
				foldenable = true;
				foldmethod = "syntax";

				# default indent settings
				tabstop = 4;
				shiftwidth = 4;
				expandtab = false;

				# Others
				updatetime = 200;
				splitbelow = true;
				splitright = true;
				ignorecase = true;
				smartcase = true;
				allowrevins = true;

				# Spell
				spelllang = "en_us";
				spell = true;
				spellcapcheck = ""; # ignore capitalization

				# Session options
				sessionoptions = "buffers,curdir,folds,help,tabpages,winsize";
			};
			globals = {
				mapleader = " ";
				maplocalleader = " ";
			};
			highlightOverride = {
				# Search    = { bg = "#45403d"; };
				# IncSearch = { bg = "#196F3D"; };
				# CurSearch = { bg = "#7B241C"; };
				Substitute = {
					bg = "#5a5251";
					fg = "#EA3F3F";
				};
			};
			extraConfigLuaPre =
				''
					_G.blink_enabled = true
				'' + (
				if config.nixvim.colorscheme == "gruvbox" then
					''
						_G.gruvbox_contrast = "medium"
						_G.colorscheme_name = "gruvbox"
						_G.get_colors = function()
							local g_colors = require("gruvbox-material.colors")
							local colors = g_colors.get(vim.o.background, _G.gruvbox_contrast)
							return colors
						end
						_G.get_lualine_theme = function()
							return require('gruvbox-material.lualine').theme(_G.gruvbox_contrast)
						end
						_G.get_lualine_name = function()
							return "gruvbox-material"
						end
					''
				else if config.nixvim.colorscheme == "cuddlefish" then
					''
						_G.get_lualine_theme = function()
							return require('lualine.themes.cuddlefish')
						end
						_G.colorscheme_name = "cuddlefish"
						_G.get_colors = function()
							return require('cuddlefish').colors()
						end
						_G.get_lualine_name = function()
							return "cuddlefish"
						end
					''
				else if config.nixvim.colorscheme == "melange" then
					''
						_G.get_lualine_theme = function()
							return require('lualine.themes.melange')
						end
						_G.colorscheme_name = "melange"
						_G.get_colors = function()
							return require('melange.palettes.dark')
						end
						_G.get_lualine_name = function()
							return "melange"
						end
					''
				else abort "${config.nixvim.colorscheme} is not a valid colorscheme"
				);
			extraConfigLuaPost = ''
				vim.cmd "hi clear SpellBad"
				vim.cmd "hi clear SpellCap"
				vim.cmd "hi clear SpellRare"
				vim.cmd "hi clear SpellLocal"

				if vim.g.neovide then
					-- vim.o.guifont = "FiraCode_Nerd_Font_Ret,Flog_Symbols:h14";
					vim.o.guifont = "Victor_Mono,Flog_Symbols:h14";
					vim.g.neovide_floating_shadow = true;
					vim.g.neovide_floating_z_height = 1.0;
					vim.g.neovide_position_animation_length = 0.10;
					vim.g.neovide_scroll_animation_length = 0.1;
					vim.g.neovide_scroll_animation_far_lines = 9999;
					vim.g.neovide_hide_mouse_when_typing = true;
					vim.g.neovide_refresh_rate = 120;
					vim.g.neovide_cursor_animation_length = 0.13;
					vim.g.neovide_cursor_trail_size = 0.1;
					vim.g.neovide_cursor_animate_command_line = false
					vim.g.neovide_cursor_smooth_blink = true;
					vim.g.neovide_floating_blur_amount_x = 2.0
					vim.g.neovide_floating_blur_amount_y = 2.0
					vim.g.neovide_floating_border_radius = 0.5
					vim.keymap.set({ "n",   "v" },   "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
					vim.keymap.set({ "n",   "v" },   "<C-_>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
					vim.keymap.set({ "n",   "v" },   "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
					vim.keymap.set({ "v",   "v" },   "<C-S-C>", '"+y', { desc = "Copy system clipboard" })
					vim.keymap.set({ "n",   "v" },   "<C-S-V>", '"+p', { desc = "Paste system clipboard" })
					vim.env.NEOVIDE = 1
				end

				-- for mini session
				vim.opt.sessionoptions:remove("terminal")
				vim.opt.sessionoptions:remove("buffers")
				vim.opt.sessionoptions:append("help")
				vim.opt.sessionoptions:append("tabpages")

				${builtins.readFile ./extra-nvim-files/mkheader.lua}
			'';
			autoCmd = [
				{
					pattern = [ "*" ];
					event = [ "TextYankPost" ];
					callback.__raw = ''
	function() vim.highlight.on_yank { higroup = "Visual", timeout = 200 } end
					'';
				}
				{
					pattern = [ "*" ];
					event = [ "FileType" ];
					callback.__raw = ''
						function()
							if vim.bo.filetype == "idris2" then
								vim.cmd "TSBufDisable highlight"
							end
						end
					'';
				}
			];
		};
		home.file = {
			# ftdetect (add a new filetype)
			".config/nvim/ftdetect/http.vim".source     = ./extra-nvim-files/http-ftdetect.vim;
			".config/nvim/ftdetect/idr.vim".source      = ./extra-nvim-files/idr-ftdetect.vim;
			".config/nvim/ftdetect/nu.vim".source       = ./extra-nvim-files/nu-ftdetect.vim;
			".config/nvim/ftdetect/pep.vim".source      = ./extra-nvim-files/pep-ftdetect.vim;

			# ftplugin (special command for a filetype)
			".config/nvim/ftplugin/git.vim".source      = ./extra-nvim-files/git-ftplugin.vim;
			".config/nvim/ftplugin/fugitive.vim".source = ./extra-nvim-files/fugitive-ftplugin.vim;
			".config/nvim/ftplugin/qf.vim".source       = ./extra-nvim-files/qf-ftplugin.vim;

			# syntax (custom syntax for a filetype)
			".config/nvim/syntax/nu.vim".source         = ./extra-nvim-files/nu-syntax.vim;
			".config/nvim/syntax/pep.vim".source        = ./extra-nvim-files/pep-syntax.vim;
		};
	};
}
