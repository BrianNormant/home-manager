{pkgs, ...}:
let
in {
	programs.nixvim = {
		plugins = {
			overseer = {
				enable = true;
				lazyLoad = {
					enable = true;
					settings = {
						cmd = [ "OverseerRun" "OverseerToggle" ];
					};
				};
				settings = {};
				luaConfig.post = builtins.readFile ./overseer.lua;
			};
		};
		keymaps = [
			{
				key = "<F5>";
				action = "<CMD>OverseerRun<CR>";
				options.desc = "Overseer: Run";
			}
			{
				key = "<F6>";
				action = "<CMD>OverseerToggle!<CR>";
				options.desc = "Overseer: Open result buffer";
			}
		];
	};
}
