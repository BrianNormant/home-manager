{pkgs, ... }: {
	programs.nixvim = {
		extraPlugins = [(pkgs.vimUtils.buildVimPlugin rec {
			pname = "gen-nvim";
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
		})];
		extraConfigLua = ''
			require('lz.n').load {
				'gen-nvim',
				keys = {
					{
						"<F1>",
						"<CMD>Gen<CR>",
						mode = {"v", "n" },
					},
				},
				cmd = "Gen",
				after = function()
					require('gen').setup {
						model = 'llama3:latest',
						display_mode = 'split',
						show_prompt = false,
						show_model = false,
						no_auto_close = true,
						host = "ollama.ggkbrian.com",
						port = 80,
					}
				end,
			}
		'';
	};
}
