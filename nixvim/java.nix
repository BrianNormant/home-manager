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
						require('lz.n').trigger_load('nvim-navbuddy')
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
				init_options = {
					documentSymbols = {
						dynamicRegistration = false,
						hierarchicalDocumentSymbolSupport = true,
						labelSupport = true,
						symbolKind = {
							valueSet = {
								1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
								11, 12, 13, 14, 15, 16, 17, 18,
								19, 20, 21, 22, 23, 24, 25, 26,
								27, 28, 29, 30, 31,
							},
						},
					},
				},
				settings = {
					java = {
						configuration = {
							runtimes = {
								{name = "JavaSE-17", path = "${pkgs.jdk17}/lib/openjdk"},
								{name = "JavaSE-21", path = "${pkgs.jdk21}/lib/openjdk"},
							}
						},

						-- We want to have access to libraries
						import = {
							gradle = { enabled = true },
							maven  = { enabled = true },
						},

						inlayHints = {
							parameterNames = {
								---@type "none" | "literals" | "all"
								enabled = 'all',
							},
						},

						references = { includeDecompiledSources = true },
						symbols = { includeSourceMethodDeclarations = true },

						implementationsCodeLens = { enabled = true },
						referenceCodeLens = { enabled = true },

						rename = { enabled = true },

						signatureHelp = {
							enabled = true,
							description = { enabled = true },
						},
					},
				},
			}
			'';
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
}
