{pkgs, config, ... }: {
	programs.nixvim = {
		plugins = {
			model = {
				enable = true;
				lazyLoad.settings = {
					command = [ "Model" "MChat" ];
					keys = [
						{ __unkeyed-1 = "<F1>"; __unkeyed-2 = "<CMD>Model ask<CR>"; mode = "n"; }
					];
				};
				luaConfig.pre = ''
local model = require('model')
local ollama = require('model.providers.ollama')
local util = require('model.util')
'';
				settings = {
					chats = {
						"default" = {
							provider.__raw = "ollama";
							params = { model = "dolphin3:latest"; };
						};
					};
					prompts = {
						ask = {
							provider.__raw = "ollama";
							params = { model = "dolphin3:latest"; };
							builder.__raw = ''function(input)

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
								end
							'';
						};
					};
				};
			};
		};
	};
}
