{config, pkgs, ...}: {
	imports = [
		# Add configuration from ./nixvim/*.nix
		./nixvim/keymaps.nix
		./nixvim/colorscheme.nix
		./nixvim/boole.nix
		./nixvim/mini.nix
		./nixvim/dressing.nix
		./nixvim/dropbar.nix
		./nixvim/git.nix
		./nixvim/startuptime.nix
		./nixvim/lualine.nix
		./nixvim/tabby.nix
		./nixvim/ufo.nix
		./nixvim/leap.nix
		./nixvim/registers.nix
		./nixvim/quicklist.nix
		./nixvim/indent-bl.nix
		./nixvim/oil.nix
		./nixvim/navbuddy.nix
		./nixvim/treesitter.nix
		./nixvim/lsp.nix
		./nixvim/lsp-keymaps.nix
		./nixvim/linter.nix
		./nixvim/blink.nix
		./nixvim/muren.nix
		# ./nixvim/symbol-picker.nix
		./nixvim/dap.nix
		./nixvim/ai.nix
		./nixvim/jdtls.nix
		./nixvim/idris2.nix
		./nixvim/telescope.nix
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
				event = [ "VimLeavePre" ];
				command = "!rm /tmp/nvim-startuptime";
			}
		];
	};
	home.file.".config/nvim/syntax/nu.vim".source   = ./custom-syntax-vim/nu-syntax.vim;
	home.file.".config/nvim/ftdetect/nu.vim".source = ./custom-syntax-vim/nu-ftdetect.vim;
	home.file.".config/nvim/syntax/pep.vim".source   = ./custom-syntax-vim/pep-syntax.vim;
	home.file.".config/nvim/ftdetect/pep.vim".source = ./custom-syntax-vim/pep-ftdetect.vim;
	home.file.".config/nvim/ftdetect/http.vim".source = ./custom-syntax-vim/http-ftdetect.vim;
	home.file.".config/nvim/ftdetect/idr.vim".source = ./custom-syntax-vim/idr-ftdetect.vim;
	home.file.".config/nvim/lua/supermaven.lua".source = ./supermaven.lua;
}
