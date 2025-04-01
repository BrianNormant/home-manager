{pkgs, ... }: {
programs.nixvim = {
		plugins.nvim-jdtls = {
			enable = true;
			cmd = [ "jdtls" ];
			settings = {
				java = {
					configuration.runtimes = [
						{name = "JavaSE-21"; path = "~/.java/home/jdk-21"; }
						{name = "JavaSE-17"; path = "~/.java/home/jdk-17"; }
					];
					references.includeDecompiledSources = true;
				};
			};
			initOptions = {
				# bundles.__raw = "{vim.fn.glob(${pkgs.vscode-extensions.vscjava.vscode-java-debug} .. \"/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar\", true)}";
			};
		};
		keymaps = [
			{
				key = "<A-o>";
				action = "require('jdtls').organize_imports";
				options.desc = "JDTLS: Organize Imports";
			}
		];
		# extraConfigLua = builtins.readFile ./jdtls.lua;
	};
}
