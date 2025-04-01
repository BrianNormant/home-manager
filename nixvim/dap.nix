{pkgs, ... }: {
	programs.nixvim = {
		plugins.dap = {
			enable = true;
			adapters = {
				executables = {
					gdb = {
						command = "gdb";
						args = [ "-i" "dap" ];
					};
				};
			};
			configurations = {
				c = [{
					name = "Launch";
					type = "gdb";
					request = "launch";
					# Find the executable somewhere?
					program = "./out/a.out";
					cwd = "\${workspaceFolder}";
				}];
			};
			signs.dapBreakpoint = {
				text   = "🛑";
				texthl = "";
				linehl = "";
				numhl  = "";
			};
		};
		plugins.dap-ui = {
			enable = true;
			lazyLoad.settings = {
				keys = [
					{
						__unkeyed-1 = "<F10>";
						__unkeyed-2.__raw = "require('dap').continue";
					}
					{
						__unkeyed-1 = "<F11>";
						__unkeyed-2.__raw = "require('dap').toggle_breakpoint";
					}
					{
						__unkeyed-1 = "<F12>";
						__unkeyed-2.__raw = "require('dap').step_over";
					}
				];
			};
			settings = {
				layouts = [
					{
						elements = [
							{ id = "breakpoints"; size = 0.25; }
							{ id = "scopes";      size = 0.25; }
							{ id = "watches";     size = 0.5;  }
						];
						position = "left";
						size = 40;
					}
					{
						elements = [
							{ id = "repl";   size = 0.5; }
							{ id = "stacks"; size = 0.5; }
						];
						position = "right";
						size = 60;
					}
				];
			};
		};
	};
}
