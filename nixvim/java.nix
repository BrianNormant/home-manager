{pkgs, ... }: {
programs.nixvim = {
		extraPackages = with pkgs; [
			jdt-language-server
		];
		extraPlugins = [
			(pkgs.vimUtils.buildVimPlugin {
				pname = "spring-boot";
				version = "HEAD";
				src = pkgs.fetchFromGitHub {
					owner = "JavaHello";
					repo = "spring-boot.nvim";
					rev = "dff5fc9";
					hash = "sha256-WAgxEtVSAkFzDMNymuO/1p9Wz8bvSbY/oue+1Sl6Oio=";
				};
			})
		];
		plugins = {
			java = {
				enable = true;
				package = pkgs.vimUtils.buildVimPlugin rec {
					pname = "nvim-jdtls";
					version = "v4.0.4";
					src = pkgs.fetchFromGitHub rec {
						owner = "nvim-java";
						repo = owner;
						rev = version;
						hash = "sha256-82iGUxFohf5oEGSQeTCJ/6AHJfuK9Rz4meW66b35HB0=";
					};
					nvimSkipModules = [
						"java"
						"java-dap"
						"java-dap.setup"
						"java-dap.data-adapters"
						"java-dap.runner"
						"java-test.adapters"
						"java-test.reports.junit"
						"java-test.results.execution-status"
						"java-test.results.result-parser"
						"java-test.results.result-parser-factory"
						"java-test.results.result-status"
						"java-test.results.message-id"
						"java-test"
						"java-test.ui.report-viewer"
						"java-test.ui.floating-report-viewer"
						"java-test.api"
						"java-test.utils.string-builder"
						"async.waits.wait_all"
						"async.waits.wait_with_error_handler"
						"async.waits.wait"
						"async.wrap"
						"async.runner"
						"java-core.utils.log2"
						"java-core.utils.lsp"
						"java-core.utils.command"
						"java-core.utils.notify"
						"java-core.utils.file"
						"java-core.utils.system"
						"java-core.utils.event"
						"java-core.utils.error_handler"
						"java.config"
						"java.api.profile_config"
						"java.api.settings"
						"java.api.runner"
						"java.ui.lazy"
						"java.ui.profile"
						"java.ui.utils"
						"java.checks.nvim-version"
						"java.checks.init"
						"java.checks.nvim-jdtls"
						"java.startup.decompile-watcher"
						"java.startup.lsp_setup"
						"java.utils.window"
						"java.utils.config"
						"java-refactor.client-command-handlers"
						"java-core.ls.clients.java-test-client"
						"java-core.ls.clients.jdtls-client"
						"java-core.ls.clients.java-debug-client"
						"java-core.ls.servers.jdtls.filetype"
						"java-core.ls.servers.jdtls.env"
						"java-core.ls.servers.jdtls.cmd"
						"java-core.ls.servers.jdtls.init"
						"java-core.ls.servers.jdtls.root"
						"java-core.ls.servers.jdtls.plugins"
						"java-core.ls.servers.jdtls.conf"
						"java-core.constants.java_version"
						"java-core.types.nvim-types"
						"java-core.types.jdtls-types"
						"java-core.utils.str"
						"java-core.utils.set"
						"java-core.utils.errors"
						"java-core.utils.path"
						"java-core.utils.list"
						"java-core.utils.class"
						"java-core.utils.log"
						"java-core.utils.buffer"
						"pkgm.extractors.powershell"
						"pkgm.extractors.unzip"
						"pkgm.downloaders.factory"
						"pkgm.downloaders.wget"
						"pkgm.downloaders.powershell"
						"pkgm.manager"
						"pkgm.specs.init"
						"pkgm.specs.jdtls-spec.version-map"
						"pkgm.specs.jdtls-spec.init"
						"pkgm.specs.base-spec"
						"pkgm.pkgs.jdtls"
						"java-runner.run"
						"java-runner.run-logger"
						"java-runner.runner"
						"java-refactor.action"
						"java-refactor.refactor"
						"java-refactor"
						"java-refactor.client-command"
						"java-refactor.api.refactor"
						"java-refactor.api.build"
						"java-refactor.utils.instance-factory"
						"java-refactor.utils.error_handler"
						"lazy"
						"pkgm.extractors.factory"
						"pkgm.extractors.tar"
						"pkgm.extractors.uncompressed"
					];
				};
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
