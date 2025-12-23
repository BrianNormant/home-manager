{pkgs, ... }: {
programs.nixvim = {
		extraPackages = with pkgs; [
			jdt-language-server
		];
		extraPlugins = [
			pkgs.vimPlugins.spring-boot
		];
		plugins = {
			java = {
				enable = true;
				package = pkgs.vimPlugins.nvim-java;
				lazyLoad = {
					enable = true;
					settings = {
						ft = "java";
					};
				};
				settings = {
					jdk = { auto_install = false; };
					spring_boot_tools = {
						enable = false;
					};
				};
				luaConfig.post = builtins.readFile ./java.lua;
			};
		};
		keymaps = [
			{
				key = "<A-o>";
				action = "<CMD>JavaTestRunCurrentMethod <Bar> JavaTestViewLastReport<CR>";
				options.desc = "Java: Test with view method";
			}
			{
				key = "<A-O>";
				action = "<CMD>JavaTestDebugCurrentMethod<CR>";
				options.desc = "Java: Debug current test method";
			}
		];
	};
	home.file = {
		".local/share/lib/openjdk-17".source = pkgs.jdk17 + "/lib/openjdk";
		".local/share/lib/openjdk-21".source = pkgs.jdk21 + "/lib/openjdk";
		".local/share/lib/openjdk-25".source = pkgs.jdk25 + "/lib/openjdk";
	};
}
