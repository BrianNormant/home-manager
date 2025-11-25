{pkgs, ... }: {
programs.nixvim = {
		extraPackages = with pkgs; [
			jdt-language-server
		];
		# my setup is too complex to use nixvim integration.
		extraPlugins = with pkgs.vimPlugins; [
			# {optional = true; plugin = nvim-java-test;}
			{optional = true; plugin = nvim-java-dap;}
			{optional = true; plugin = nvim-java-refactor;}
			{optional = true; plugin = nvim-java-core;}
			{
				plugin = nvim-java.overrideAttrs (p: n: {
					# TODO: update patch for new version
					# patches = [ ./plugin-patch/nvim-java.patch ];
					nvimSkipModules = [
						"java.startup.mason-dep"
						"java.startup.mason-registry-check"
						"java.utils.mason"
					];
				});
				optional = true;
			}
		];
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
		extraConfigLua = builtins.readFile ./java.lua;
	};
	home.file = {
		".local/share/lib/openjdk-17".source = pkgs.jdk17 + "/lib/openjdk";
		".local/share/lib/openjdk-21".source = pkgs.jdk21 + "/lib/openjdk";
	};
}
