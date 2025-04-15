{pkgs, ... }: {
	programs.nixvim = {
		extraPlugins = [
			{
				plugin = pkgs.vimUtils.buildVimPlugin rec {
					pname = "gen.nvim";
					version = "e09a8db";
					src = pkgs.fetchFromGitHub {
						owner = "David-Kunz";
						repo  = "gen.nvim";
						rev = version;
						hash = "sha256-s3Ky2uhRviKAaKF3iCF2uHctzk+kFV7BnqyxAGwqhbo=";
					};
					patches = [
						./plugin-patch/gen-nvim.patch
					];
				};
				optional = true;
			}
		];
		# Maybe avante.nvim https://github.com/yetone/avante.nvim
		extraConfigLua = ''
			require('lz.n').load { {
				'gen.nvim',
				cmd = "Gen",
				after = function()
					require('gen').setup {
						model = 'gemma3:27b',
						display_mode = 'split',
						show_prompt = true,
						show_model = true,
						no_auto_close = true,
						host = "ollama.ggkbrian.com",
						port = 80,
					}
				end,
			} }
		'';
		keymaps = [
			{
				key = "<F1>";
				action = "<CMD>Gen<CR>";
				options.desc = "Ask Ollama";
				mode = [ "n" "v" ];
			}
		];
	};
}
