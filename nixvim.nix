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
		./nixvim/boole.nix
		./nixvim/mini.nix
		./nixvim/leap.nix
		./nixvim/registers.nix
		./nixvim/quickfix.nix
		./nixvim/oil.nix
		./nixvim/navbuddy.nix
		./nixvim/search-replace.nix
		./nixvim/symbol-picker.nix
		./nixvim/telescope.nix
		
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

			require('mason').setup {
				PATH = "skip",
			}
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
		".config/nvim/ftdetect/http.vim".source = ./custom-syntax-vim/http-ftdetect.vim;
		".config/nvim/ftdetect/idr.vim".source = ./custom-syntax-vim/idr-ftdetect.vim;
		".config/nvim/ftdetect/nu.vim".source = ./custom-syntax-vim/nu-ftdetect.vim;
		".config/nvim/ftdetect/pep.vim".source = ./custom-syntax-vim/pep-ftdetect.vim;

		# ftplugin (special command for a filetype)
		".config/nvim/ftplugin/git.vim".source = ./custom-syntax-vim/git-ftplugin.vim;
		".config/nvim/ftplugin/fugitive.vim".source = ./custom-syntax-vim/fugitive-ftplugin.vim;
		".config/nvim/ftplugin/qf.vim".source = ./custom-syntax-vim/qf-ftplugin.vim;

		# syntax (custom syntax for a filetype)
		".config/nvim/syntax/nu.vim".source   = ./custom-syntax-vim/nu-syntax.vim;
		".config/nvim/syntax/pep.vim".source   = ./custom-syntax-vim/pep-syntax.vim;

		# Others
		".config/nvim/lua/supermaven.lua".source = ./supermaven.lua;
	};
}
