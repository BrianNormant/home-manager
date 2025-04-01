{config, pkgs, ...}: {
	imports = [
		# Add configuration from ./nixvim/*.nix
		./nixvim/colorscheme.nix
		./nixvim/boole.nix
		./nixvim/mini.nix
		./nixvim/dressing.nix
		./nixvim/dropbar.nix
		./nixvim/gitsigns.nix
		./nixvim/startuptime.nix
		./nixvim/diffview.nix
		./nixvim/lualine.nix
		./nixvim/tabby.nix
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
			fugitive.enable = true;
			web-devicons.enable = true;
		};
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
			mapleader = "<space>";
			maplocalleader = "<space>";
		};
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
}
