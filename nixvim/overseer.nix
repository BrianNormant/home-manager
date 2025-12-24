{pkgs, ...}:
let
in {
	programs.nixvim = {
		plugins = {
			overseer = {
				enable = true;
				# if overseer crash after update, lock the input to tag="v1.6.0" in the meantime until fix
				lazyLoad = {
					enable = true;
					settings = {
						cmd = [
							"OverseerRun"
							"OverseerRunLastOrAsk"
							"OverseerToggle"
							"OverseerShell"
						];
					};
				};
				settings = {
					log_level.__raw = "vim.log.levels.DEBUG";
				};
				luaConfig.post = builtins.readFile ./overseer.lua;
			};
		};
		keymaps = [
			{
				key = "<F5>";
				action = "<CMD>OverseerRunLastOrAsk<CR>";
				options.desc = "Overseer: Run Last or show menu";
			}
			{
				key = "<S-F5>";
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
