{pkgs, config, ... }: {
	programs.nixvim = {
		plugins = {
			# avante = {
			# 	enable = true;
			# 	lazyLoad.settings = {
			# 		enable = false;
			# 		cmd = "AvanteAsk";
			# 	};
			# 	settings = {
			# 		provider = "ollama";
			# 		ollama = {
			# 			model = "gemma3:27b";
			# 		};
			# 		vendors = {
			# 			ollama = {
			# 				endpoint = "http://ollama.ggkbrian.com";
			# 			};
			# 		};
			# 	};
			# 	luaConfig.post = ''
			# 		vim.fn.sign_define("AvanteInputPromptSign", { text = "=>" })
			# 	'';
			# };
		};
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
		extraConfigLua = ''
			-- we preload ollama by sending a empty request
			vim.system({"zsh", "-c", "ollama run gemma3:27b \"\" &>/dev/null &!"}, {}, function() end)
			require('lz.n').load { {
				'gen.nvim',
				cmd = "Gen",
				after = function()
					require('gen').setup {
						model = "${config.nixvim.ollama_model}",
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
				key = "<S-F1>";
				action = "<CMD>Gen<CR>";
				options.desc = "Ask Ollama";
				mode = [ "n" "v" ];
			}
			{
				key = "<F1>";
				action = "<CMD>AvanteAsk<CR>";
				options.desc = "Ask Avante";
				mode = [ "n" "v" ];
			}
		];
	};
}
