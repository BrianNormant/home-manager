require('lz.n').load {
	"nvim-java",
	before = function()
		local lzn = require('lz.n')
		lzn.trigger_load('nvim-dap-ui')
		lzn.trigger_load('nvim-navbuddy')
		lzn.trigger_load('nvim-java-core')
		lzn.trigger_load('nvim-java-refactor')
		lzn.trigger_load('nvim-java-test')
		lzn.trigger_load('nvim-java-dap')
	end,
	ft = "java",
	after = function ()
		require('java').setup {}
		require('lspconfig').jdtls.setup {
			capabilities = {
				textDocument = {
					completion = {
						dataSupport = true,
						enabled = true,
						dynamicRegistration = true,
						completionItem = {
							snippetSupport = true,
							documentationFormat = "markdown",
							resolveSupport = {
								properties = { "documentation", "detail", "additionalTextEdits" },
							},
							labelDetailsSupport = true,
						},
						contextSupport = true,
						completionList = {
							itemDefaults = {
								"data",
								"editRange",
							},
						},
					},
				},
			},
			cmd = {"jdtls"}, -- provided in path thanks to nix
			autostart = true,
			init_options = {
				completion = {
					dynamicRegistration = true,
					dataSupport = true,
				},
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
							{name = "JavaSE-17", path = "/home/brian/.local/share/lib/openjdk-17"},
							{name = "JavaSE-21", path = "/home/brian/.local/share/lib/openjdk-21"},
							{name = "JavaSE-25", path = "/home/brian/.local/share/lib/openjdk-25"},
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
					completion = {
						dataSupport = true,
						enabled = true,
						dynamicRegistration = true,
						completionItem = {
							dataSupport = true,
							snippetSupport = true,
							documentationFormat = "markdown",
							resolveSupport = {
								properties = { "documentation", "detail", "additionalTextEdits" },
							},
							labelDetailsSupport = true,
						},
						contextSupport = true,
						completionList = {
							itemDefaults = {
								"data",
								"editRange",
							},
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
	end,
}
