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
		})];
		extraConfigLua = ''
			require('gen').setup {
				model = 'llama3:latest',
				display_mode = 'float',
				show_prompt = true,
				show_model = true,
				host = "ollama.ggkbrian.com",
				port = 80,
			}
		'';
		keymaps = [
			{
				key = "<F1>";
				action = "<cmd>Gen<cr>";
				mode = [ "n" "v" ];
				options.desc = "Ask to Ollama";
			}
		];
	};
}
