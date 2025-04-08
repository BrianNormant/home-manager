{pkgs, ... }: {
programs.nixvim = {
		extraPackages = with pkgs; [
			jdt-language-server
		];
		plugins.java = {
			enable = true;
			lazyLoad.settings = {
				ft = "java";
				before.__raw = ''
					function()
						require('lz.n').trigger_load('nvim-dap-ui')
					end
				'';
			};
			settings = {
				jdk.auto_install = false;
				spring_boot_tools.enable = false;
				mason = {
					PATH = "skip";
				};
			};
			luaConfig.post = ''
			require('lspconfig').jdtls.setup {
				cmd = {"${pkgs.jdt-language-server}/bin/jdtls"},
				autostart = true,
				settings = {
					java = {
						configuration = {
							runtimes = {
								{name = "JavaSE-17", path = "${pkgs.jdk17}/lib/openjdk"},
								{name = "JavaSE-21", path = "${pkgs.jdk21}/lib/openjdk"},
							}
						}
					}
				},
			}
			'';
		};
		keymaps = [
			# {
			# 	key = "<A-o>";
			# 	action.__raw = "require('jdtls').organize_imports";
			# 	options.desc = "JDTLS: Organize Imports";
			# }
		];
		# extraConfigLua = builtins.readFile ./jdtls.lua;
	};
}
