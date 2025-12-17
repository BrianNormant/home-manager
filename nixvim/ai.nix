{pkgs, config, ... }: {
	programs.nixvim = {
		extraPlugins = [
			{
				plugin = pkgs.vimUtils.buildVimPlugin rec {
					pname = "model-nvim";
					version = "latest";
					src = pkgs.fetchFromGitHub {
						owner = "gsuuon";
						repo = "model.nvim";
						rev = "c4653e9";
						hash = "sha256-gz97C8/tlU4SDKLaQ5Lv2NbQP8zQRsNxiIQWHoHHDJY=";
					};
				};
				optional = true;
			}
		];
		extraConfigLua = ''
			require('lz.n').load {
				"model-nvim",
				event = "DeferredUIEnter",
				command = "Model",
				keys = {
					{
						"<S-F1>", "<CMD>Model ask<CR>",
						mode = {"n", "v"}, desc = "Generate with ollama",
					},
				},
				after = function ()
					local model = require('model')
					local ollama = require('model.providers.ollama')
					local util = require('model.util')

					model.setup {
						prompts = {
							["ask"] = {
								provider = ollama,
								params = {
									model = "dolphin3:latest",
								},
								builder = function(input)

									local prompt = vim.fn.input("Prompt: ")

									local messages = {
										{
											role = "user",
											content = input,
										},
									};

									return {
										messages = messages,
										prompt = prompt,
									}
								end,
							},
						},
					}
				end,
			}
			'';
	};
}
