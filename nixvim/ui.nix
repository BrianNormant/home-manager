{pkgs, ...}:
let
	inherit (pkgs) vimPlugins;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;
in {
	programs.nixvim = {
		extraPlugins = with vimPlugins; [
			{
				plugin = floating-input-nvim;
				optional = true;
			}
			{
				plugin = buildVimPlugin rec {
					pname = "ui.nvim";
					version = "fc4052a";
					src = fetchFromGitHub {
						owner = "OXY2DEV";
						repo = pname;
						rev = version;
						hash = "sha256-C6JUsnbW5qFgdLKCEg67o8s8vsPd3Mq/AgWjzJ/I8XQ=";
					};
					# patches = [
					# 	./plugin-patch/ui.nvim.patch
					# ];
				};
				optional = false;
			}
		];
		extraConfigLua = ''
			require('lz.n').load {
				'floating-input.nvim',
				event = "DeferredUIEnter",
				after = function()
					local ft = require('floating-input').input
					vim.ui.input = function(opts, on_confirm)
						ft(opts, on_confirm, {border = "solid", width = 50})
					end
				end
			}
			require('ui').setup {
				popupmenu = { enable = false },
				cmdline = { enable = false },
			}
			vim.cmd "set incsearch"
			vim.cmd "set cmdheight=1"
		'';
	};
}
