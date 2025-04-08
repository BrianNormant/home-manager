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
			lazyLoad = {
				settings = {
					enabled = true;
					lazy = true;
				};
				enable = true;
			};
		};
		plugins.dap-ui = {
			enable = true;
			lazyLoad.settings = {
				keys = [
					{
						__unkeyed-1 = "<F10>";
						__unkeyed-2.__raw = ''
							function()
								require('dap').continue()
							end
						'';
					}
					{
						__unkeyed-1 = "<F11>";
						__unkeyed-2.__raw = ''
							function()
								require('dap').toggle_breakpoint()
							end
						'';
					}
					{
						__unkeyed-1 = "<F12>";
						__unkeyed-2.__raw = ''
							function()
								require('dap').step_over()
							end
						'';
					}
				];
				ft = "java"; # nvim-java needs dap to be active to be properly configured
				before.__raw = ''
					function()
						require('lz.n').trigger_load('nvim-dap')
					end
				'';
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
