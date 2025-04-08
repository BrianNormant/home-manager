{pkgs, ... }: {
	imports = [
		# UI
		./nixvim/colorscheme.nix
		./nixvim/dressing.nix
		./nixvim/dropbar.nix
		./nixvim/lualine.nix
		./nixvim/tabby.nix
		./nixvim/ufo.nix
		./nixvim/indent.nix
		./nixvim/treesitter.nix
		
		# Quality of life
		./nixvim/qol.nix
		./nixvim/mini.nix
		./nixvim/leap.nix
		./nixvim/registers.nix
		./nixvim/quickfix.nix
		./nixvim/oil.nix
		./nixvim/navbuddy.nix
		./nixvim/search-replace.nix
		./nixvim/symbol-picker.nix
		./nixvim/telescope.nix
		./nixvim/terminal.nix
		
		# Languages
		./nixvim/java.nix
		./nixvim/idris2.nix

		# Others
		./nixvim/keymaps.nix
		./nixvim/git.nix
		./nixvim/lsp.nix
		./nixvim/lsp-keymaps.nix
		./nixvim/linter.nix
		./nixvim/completion.nix
		./nixvim/dap.nix
		./nixvim/ai.nix
	];

	programs.nixvim = {
		enable = true;
		luaLoader.enable = true;
		plugins = {
			lz-n.enable = true;
			lz-n.autoLoad = true;
			vim-suda.enable = true;
			repeat.enable = true;
			wakatime.enable = true;
			lastplace.enable = true;
			web-devicons.enable = true;
			marks.enable = true;
			guess-indent.enable = true;
		};
		extraPackages = with pkgs; [
			ripgrep
		];
		extraPlugins = with pkgs.vimPlugins; [
			vim-startuptime
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

			# Spell
			spelllang = "en_us";
			spell = true;
		};
		globals = {
			mapleader = " ";
			maplocalleader = " ";
		};
		highlightOverride = {
			Search    = { link = "Visual"     ; force = true; };
			IncSearch = { link = "ClapSpinner"; force = true; };
			CurSearch = { link = "ClapSpinner"; force = true; };
			Substitute = {
				bg = "#5a5251";
				fg = "#EA3F3F";
			};
		};
		extraConfigLuaPost = ''
			vim.cmd "hi clear SpellBad"
			vim.cmd "hi clear SpellCap"
			vim.cmd "hi clear SpellRare"
			vim.cmd "hi clear SpellLocal"

			require('lz.n').load {
				"mason.nvim",
				enabled = false,
				lazy = true,
				after = function()
					require('mason').setup {
						PATH = "skip",
					}
				end,
			}
			if vim.g.neovide then
				vim.o.guifont = "FiraCode_Nerd_Font_Ret,Flog_Symbols:h14";
				vim.g.neovide_floating_shadow = true;
				vim.g.neovide_floating_z_height = 1.0;
				vim.g.neovide_position_animation_length = 0.10;
				vim.g.neovide_scroll_animation_length = 0;
				vim.g.neovide_scroll_animation_far_lines = 0;
				vim.g.neovide_hide_mouse_when_typing = true;
				vim.g.neovide_refresh_rate = 120;
				vim.g.neovide_cursor_animation_length = 0.13;
				vim.g.neovide_cursor_trail_size = 0;
				vim.g.neovide_cursor_animate_command_line = false
				vim.g.neovide_cursor_smooth_blink = true;
				vim.g.neovide_floating_blur_amount_x = 2.0
				vim.g.neovide_floating_blur_amount_y = 2.0
				vim.keymap.set({ "n",   "v" },   "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
				vim.keymap.set({ "n",   "v" },   "<C-_>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
				vim.keymap.set({ "n",   "v" },   "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
				vim.keymap.set({ "v"        },   "<C-C>", '"+y', { desc = "Copy system clipboard" })
				vim.keymap.set({ "n",       },   "<C-V>", '"+p', { desc = "Paste system clipboard" })
				vim.env.NEOVIDE = 1
			end
		'';
		autoCmd = [
			{
				pattern = [ "*" ];
				event = [ "TextYankPost" ];
				callback.__raw = ''
function() vim.highlight.on_yank { higroup = "Visual", timeout = 200 } end
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
		# ".config/nvim/ftplugin/java.vim".source     = ./extra-nvim-files/java-ftplugin.vim;
		# ".config/nvim/ftplugin/lua.vim".source      = ./extra-nvim-files/lua-ftplugin.vim;

		# syntax (custom syntax for a filetype)
		".config/nvim/syntax/nu.vim".source         = ./extra-nvim-files/nu-syntax.vim;
		".config/nvim/syntax/pep.vim".source        = ./extra-nvim-files/pep-syntax.vim;

		# Others
		".config/nvim/lua/supermaven.lua".source = ./supermaven.lua;
	};
}
