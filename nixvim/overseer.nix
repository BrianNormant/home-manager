{pkgs, ...}:
let
in {
	programs.nixvim = {
		plugins = {
			compiler = { enable = true; };
			overseer = {
				enable = true;
				package = pkgs.vimPlugins.overseer-nvim;
				# if overseer crash after update, lock the input to tag="v1.6.0" in the meantime until fix
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
