{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
		".config/nvim-simple/init.lua".text = builtins.readFile ./nvim-simple.lua;
	
		".config/hypr/wallpaper.nu".text = builtins.readFile ./wallpaper.nu;
		".config/hypr/wallpaper.nu".executable = true;
		
		".config/hypr/brightness.nu".text = builtins.readFile ./brightness.nu;
		".config/hypr/plugged.nu".text = builtins.readFile ./plugged.nu;
		".config/hypr/volume.nu".text = builtins.readFile ./volume.nu;
			
		".config/script/media.zsh".text = builtins.readFile ./fetch-and-format-media.zsh;
		".config/script/media.zsh".executable = true;

		".config/script/switch-playerctl.zsh".text = builtins.readFile ./switch-controlled-player.sh;
		".config/script/switch-playerctl.zsh".executable = true;
		".config/script/replay.sh".text = builtins.readFile ./replay.sh;
		".config/script/replay.sh".executable = true;

		".config/hypr/hyprlock.conf".text = (import ./hyprlock.nix) (if (builtins.getEnv "HOSTNAME") == "BrianNixDesktop" then "DP-1" else "eDP-1");
		".config/hypr/hypridle.conf".text = builtins.readFile ./hypridle.conf;
  };

	home.pointerCursor = {
		name = "phinger-cursors-dark";
		package = pkgs.phinger-cursors;
		size = 32;
		gtk.enable = true;
	};


	systemd.user = import ./brian-services.nix;

	xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

	gtk = {
		enable = true;
		theme = {
			name = "gruvbox-dark";
			package = pkgs.gruvbox-dark-gtk;
		};
	};

	programs.git = {
		enable = true;
		userName = "BrianNixDesktop";
		userEmail = "briannormant@gmail.com";
	};

	programs.rofi = {
		enable = true;
		package = pkgs.rofi-wayland;
		plugins = let
			build-against-rofi-wayland = plugin: plugin.overrideAttrs ( final: self: {
				version = "wayland";
				buildInputs = with pkgs; [
					rofi-wayland-unwrapped # here we replace rofi by rofi-wayland
					libqalculate
					glib
					cairo
				];
			});

			rofi-wayland-plugins = with pkgs; [
				rofi-calc
				rofi-emoji
			];
		in builtins.map build-against-rofi-wayland rofi-wayland-plugins;
	};

	services.wob.enable = true; # TODO connect wob to script

	programs.firefox.enable = true;

	programs.waybar = (import ./waybar.nix) (builtins.getEnv "HOSTNAME");
	wayland.windowManager.hyprland = (import ./hyprland.nix) (builtins.getEnv "HOSTNAME");

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/et:c/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/brian/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
	FLAKE = "/home/brian/nixos-config";
  };

	services.unison.enable = true;
	services.unison.pairs."Music" = {
		roots = [ "/home/brian/Music"
			"ssh://BrianNixDesktopI//home/brian/Music" ]; };
	services.unison.pairs."Prog" = {
		roots = [ "/home/brian/Prog"
			"ssh://BrianNixDesktopI//home/brian/Prog" ]; };
	services.unison.pairs."Wallpapers" = {
		roots = [ "/home/brian/Wallpapers"
			"ssh://BrianNixDesktopI//home/brian/Wallpapers" ]; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

	# let 
	# 	nvim-treesitter-parsers-http = pkgs.vimPlugins.nvim-treesitter-parsers.http.overrideAttrs  (final: self: {
	# 		version = "test";
	# 		src = pkgs.fetchFromGitHub {
	# 			owner = "rest-nvim";
	# 			repo = "tree-sitter-http";
	# 			rev = "261d78f";
	# 			sha256 = "sha256-Kh5CeVc6wtqRHb/RzFALk3pnnzzC/OR3qkDwIQH+XlA=";
	# 		};
	# 	});
	# in programs.neovim = {
	programs.neovim = {
		enable = true;
		withPython3 = true;
		extraPackages = with pkgs; [
			jdt-language-server
			ccls
			# phpactor
			ripgrep
			fswatch
			fd
			yarn nodePackages_latest.nodejs
			gdb
			lua-language-server
			nil
			oracle-instantclient
			curl
			jq
			html-tidy
			tree-sitter
			vscode-extensions.vscjava.vscode-java-debug
		];

		plugins = with pkgs.vimPlugins; [
			vim-suda
			{ plugin = dressing-nvim;
				config = "lua require(\"dressing\").setup {}"; }
			{ plugin = gruvbox-material;
				config = ''
let g:gruvbox_material_background = 'soft'
colorscheme gruvbox-material'';}
			telescope-fzf-native-nvim
			{ plugin = dropbar-nvim;
				config = ''
hi WinBar   guisp=#665c54 gui=underline guibg=#313131
hi WinBarNC guisp=#665c54 gui=underline guibg=#313131
lua require('dropbar').setup {}''; }

			ccc-nvim
			{ plugin = gitsigns-nvim;
				config = "lua require('gitsigns').setup {}"; }

			{ plugin = lualine-nvim;
				config = (builtins.readFile ./bar.vim);}
			# QOL
			{ plugin = comment-nvim;
				config = "lua require('Comment').setup {}";}
			vim-surround
			vim-repeat
			vim-lastplace
			{ plugin = pkgs.vimUtils.buildVimPlugin {
				pname = "telepath-nvim";
				version = "16-03-24";
				src = pkgs.fetchFromGitHub {
					 owner = "rasulomaroff";
					 repo = "telepath.nvim";
					 rev = "993dd93";
					 hash = "sha256-495jGHbYU0uYV4i8MrMosgOG1nDEtkB1h5k3Ww5LP3o=";
				 };
			};
				config = "lua require('telepath').use_default_mappings()"; }
			{ plugin = leap-nvim;
				config=''
hi LeapBackdrop guifg=#888888
hi LeapLabelPrimary guifg=#FF0000
lua require 'leap'.create_default_mappings()
			'';}
			{ plugin = nvim-autopairs;
				config = "lua require 'nvim-autopairs'.setup {}";}
			{ plugin = boole-nvim;
				config = ''
lua << EOF
require 'boole'.setup {
	mappings = {
		increment = '<C-a>',
		decrement = '<C-x>',
	}
}
EOF
			'';}
			{ plugin = registers-nvim;
				config = "lua require 'registers'.setup {}"; }
			{ plugin = marks-nvim;
				config = "lua require 'marks'.setup {}"; }
			{ plugin = indent-blankline-nvim;
				config = ''
lua << EOF
local highlight = {
		"RainbowRed",
		"RainbowYellow",
		"RainbowBlue",
		"RainbowOrange",
		"RainbowGreen",
		"RainbowViolet",
		"RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { 
	indent = { highlight = highlight }, 
	scope = { enabled=true, highlight = highlight } 
}
EOF

			'';}
			{ plugin = guess-indent-nvim;
				config = "lua require'guess-indent'.setup {}";}
			{ plugin = vim_current_word;
				config = ''
hi CurrentWord gui=underline guibg=#00000000
hi CurrentWordTwings gui=underline,bold
					''; }
			# Features
			telescope-lsp-handlers-nvim
			{ plugin = telescope-nvim;
				config = ''
lua << EOF
local telescope = require "telescope"
telescope.setup {
	defaults = {
		layout_strategy = "flex",
	},
}
telescope.load_extension('lsp_handlers')
EOF
			'';}
			fzf-vim
			{ plugin = pkgs.vimUtils.buildVimPlugin {
				pname = "fzfx.nvim";
				version = "lastest";
				src = pkgs.fetchFromGitHub {
					owner = "linrongbin16";
					repo = "fzfx.nvim";
					rev = "efb8813";
					sha256 = "sha256-gY9P+XQhoraEM8OwHMakTpfBLFthkh99QCdf/JeN+Xo=";
				};
				};
				config = "lua require(\"fzfx\").setup {}";
			}

			{ plugin = true-zen-nvim;
				config = "lua require('true-zen').setup {}";}

			{ plugin = nvim-spectre;
				config = "lua require('spectre').setup {}";}
			vim-wakatime
			{ plugin = nvim-web-devicons;
				config = ''
lua require("nvim-web-devicons").setup {}
			''; }
			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "icon-picker-nvim";
				version = "3-01-24";
				src = pkgs.fetchFromGitHub {
					owner = "ziontee113";
					repo = "icon-picker.nvim";
					rev = "3ee9a0e";
					sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
				};
			} );
				config = "lua require('icon-picker').setup {}";}
			
			# Git
			{ plugin = pkgs.vimUtils.buildVimPlugin {
				pname = "blame.nvim";
				version = "21-03-24";
				src = pkgs.fetchFromGitHub {
						owner = "FabijanZulj";
						repo = "blame.nvim";
						rev = "7cb17b9";
						hash = "sha256-ATSUqLzjwdOtx25Ic+WzLFggw+H+Y/vcFaYo8axdYzY=";
				};};
				config = "lua require ('blame').setup {}";}
			lazygit-nvim
			{ plugin = FTerm-nvim;
				config = "lua require('FTerm').setup {}";}

			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "muren-nvim";
				version = "26-8-23";
				src = pkgs.fetchFromGitHub {
					owner = "AckslD";
					repo = "muren.nvim";
					rev = "b6484a1";
					sha256 = "hv8IfNJ+3O1L1PPIZlPwXc37Oa4u8uZPJmISLnNkBGw=";
				};
				} );
				config = "lua require('muren').setup {}"; }
			{ plugin = oil-nvim;
				config = "lua require('oil').setup {}";}
				# Fold

			{ plugin = pkgs.vimUtils.buildVimPlugin {
				pname = "coq_nvim";
				version = "03-01-24";
				src = pkgs.fetchFromGitHub {
					owner = "ms-jpq";
					repo = "coq_nvim";
					rev = "78bd6e9";
					sha256 = "sha256-VJmHJWafCVTQx+jcN+9C313lIY7ZqDcLZ2x2wp6EGLY=";
				};
			};
				config = ''
lua << EOF
local coq = require 'coq'
vim.g.coq_settings = {
	["xdg"] = true,
	["clients.tabnine.enabled"] = true,
}
EOF
			'';}
			coq-artifacts
			coq-thirdparty

			# LSP
			{ plugin = goto-preview;
				config = "lua require('goto-preview').setup {}";}
			{ plugin = nvim-navbuddy;
				config = ''
lua << EOF
require 'nvim-navbuddy'.setup {
	window = {
		border = "rounded",
		size = "50%",
	},
	lsp = { auto_attach = true },
}
EOF
			''; }
			{ plugin = ( pkgs.vimUtils.buildVimPlugin {
				pname = "boo-nvim";
				version = "8384bc";
				src = pkgs.fetchFromGitHub {
					 owner = "LukasPietzschmann";
					 repo = "boo.nvim";
					 rev = "8384bc";
					 sha256 = "sha256-FSPJHWpvkw8wY1h+h4pdpS9ChyZOO+/XQqmPvm0iKSI=";
				 };
			} );
				config = "lua require ('boo').setup {}";}

			{ plugin = lsp_lines-nvim;
				config = ''
lua << EOF
require 'lsp_lines'.setup {}
vim.diagnostic.config {
	virtual_text = false
}
EOF
			''; }
			{ plugin = actions-preview-nvim;
				config = "lua require 'actions-preview'.setup {}";}
			
			# LSP
			{ plugin = nvim-lspconfig;
				config = ''
lua << EOF
local coq = require 'coq'
local lspconfig = require('lspconfig')
local common_config = {
	coq.lsp_ensure_capabilities(),
}

lspconfig.ccls.setup(common_config)
lspconfig.lua_ls.setup(common_config)
lspconfig.nil_ls.setup(common_config)
lspconfig.phpactor.setup(common_config)
vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(ev)
			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'gR', vim.lsp.buf.rename, opts) -- May confict with virtual replace mode
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		end,
})
EOF
			 '';}
	
			/* { plugin = none-ls-nvim;
				config = ''
lua << EOF
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.diagnostics.eslint,
	null_ls.builtins.completion.spell,
	null_ls.builtins.formatting.tidy,
	null_ls.builtins.formatting.textlint,
	null_ls.builtins.formatting.surface,
	null_ls.builtins.formatting.stylelint,
	null_ls.builtins.formatting.sql_formatter,
	null_ls.builtins.formatting.pretty_php,
	null_ls.builtins.formatting.nixfmt,
	null_ls.builtins.formatting.nimpretty,
	null_ls.builtins.formatting.mix,
	null_ls.builtins.formatting.google_java_format,
	null_ls.builtins.formatting.dfmt,
	null_ls.builtins.formatting.codespell,
	null_ls.builtins.formatting.clang_format,
	null_ls.builtins.diagnostics.zsh,
	null_ls.builtins.diagnostics.vale,
	null_ls.builtins.diagnostics.todo_comments,
	null_ls.builtins.diagnostics.stylelint,
	null_ls.builtins.diagnostics.statix,
	null_ls.builtins.diagnostics.phpstan,
	null_ls.builtins.diagnostics.gccdiag,
	null_ls.builtins.diagnostics.credo,
		},
})

EOF
			'';} */
			{ plugin = pkgs.vimUtils.buildVimPlugin {
				pname = "symbol-usage.nvim";
				version = "4-03-24";
				src = pkgs.fetchFromGitHub {
					 owner = "Wansmer";
					 repo = "symbol-usage.nvim";
					 rev = "4c79eff";
					 hash = "sha256-CPUhvJZcmCKnLUX3NtpV8RE5mIMrN1wURJmTE4tO05k=";
				 };
			};
					config = ''
lua << EOF
local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

local function text_format(symbol)
	local res = {}

	local round_start = { '', 'SymbolUsageRounding' }
	local round_end = { '', 'SymbolUsageRounding' }

	if symbol.references then
		local usage = symbol.references <= 1 and 'usage' or 'usages'
		local num = symbol.references == 0 and 'no' or symbol.references
		table.insert(res, round_start)
		table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
		table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	if symbol.definition then
		if #res > 0 then
			table.insert(res, { ' ', 'NonText' })
		end
		table.insert(res, round_start)
		table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
		table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	if symbol.implementation then
		if #res > 0 then
			table.insert(res, { ' ', 'NonText' })
		end
		table.insert(res, round_start)
		table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
		table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
		table.insert(res, round_end)
	end

	return res
end

require('symbol-usage').setup({
	text_format = text_format,
})
EOF
					'';}
				# Debugger
				nvim-dap
				{ plugin = nvim-dap-ui;
				 config = (builtins.readFile ./dap.vim); }
				{ plugin = ( pkgs.vimUtils.buildVimPlugin {
					pname = "gen-nvim";
					version = "14-03-24";
					src = pkgs.fetchFromGitHub {
						owner = "David-Kunz";
						repo = "gen.nvim";
						rev = "2cb643b";
						sha256 = "aZ/ZMmatoIXnY3qtRjUqJStlpg0VGbJ1XdRjyDMhHqU=";
					};
				} );
					config = "lua require 'gen'.setup { model = 'mistral' }"; }
				{ plugin = nvim-jdtls;
					config = ''
lua << EOF
local jdtls = require 'jdtls'
local config = {
	cmd = {
		'${pkgs.jdt-language-server}/bin/jdtls'
	},
	settings = {
		java = {
			configuration = {
				runtimes = {
					{name = "JavaSE-17", path = "~/.gradle/jdks/eclipse_adoptium-17-amd64-linux/jdk-17.0.10+7/"},
					{name = "JavaSE-21", path = "~/.gradle/jdks/eclipse_adoptium-21-amd64-linux/jdk-21.0.2+13/"},
				}
			}
		},
	},

	root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew'}),

	init_options = {
		bundles = {
			vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1),
		}
	},
}

vim.api.nvim_create_autocmd(
	'BufEnter',
	{ 	pattern = {'*.java'},
		callback = function() 
		jdtls.start_or_attach(config)
		vim.defer_fn(function () require('jdtls.dap').setup_dap_main_class_configs() end, 3000) -- Wait for LSP to start
		end,
	})
EOF
					''; }
				# HTTP
				/*
				{ plugin = ( pkgs.vimUtils.buildVimPlugin {
					pname = "rest.nvim";
					version = "1234";
					src = pkgs.fetchFromGitHub {
						 owner = "rest-nvim";
						 repo = "rest.nvim";
						 rev = "5300ae0";
						 hash = "sha256-EuQ4RCwFRA99QJ4onQKulFDK3s6MOrWA5f55nlDf45w=";
					 };
				} );
					config = with pkgs.luajitPackages; ''

	lua << EOF
	package.path = package.path .. ";${mimetypes}/share/lua/5.1/?.lua" .. ";${mimetypes}/share/lua/5.1/?/init.lua"
	package.path = package.path .. ";${nvim-nio}/share/lua/5.1/?.lua" .. ";${nvim-nio}/share/lua/5.1/?/init.lua"
	package.path = package.path .. ";${lua-curl}/share/lua/5.1/?.lua" .. ";${lua-curl}/share/lua/5.1/?/init.lua"
	package.path = package.path .. ";${xml2lua}/share/lua/5.1/?.lua" .. ";${xml2lua}/share/lua/5.1/?/init.lua"

	require 'rest-nvim'.setup {}
	EOF
				''; } */
				# Elixir
				# DataBase
				vim-dadbod-ui
				{ plugin = vim-dadbod;
					config = ''
lua << EOF
vim.g.db_ui_use_nerd_fonts = 1
vim.g.dbs = {
	['DB Oracle locale'] = "oracle://SYSTEM:welcome123@localhost:1521/FREE"
}
EOF
					''; }
				(pkgs.vimUtils.buildVimPlugin {
					pname = "dbext.vim";
					version = "Jan 3, 2016";
					src = pkgs.fetchFromGitHub {
						owner = "vim-scripts";
						repo = "dbext.vim";
						rev = "14f3d53";
						hash = "sha256-tl64aKJyK8WTJRif8q3LTUb/D/qUV4AiQ5wnZFzGuQ4=";
					};
				})

				# Markdown, CSV,
				markdown-preview-nvim
				{ plugin = legendary-nvim;
					config = ( builtins.readFile ./legend.vim ); }
		

				# Nushell
				{ plugin = nvim-nu;
					config = "lua require'nu'.setup{}";}
				# Compiler and run
				{ plugin = overseer-nvim;
					config = "lua require('overseer').setup {}"; }
				{ plugin = pkgs.vimUtils.buildVimPlugin {
					pname = "compiler.nvim";
					version = "26-03-2024";
					src = pkgs.fetchFromGitHub {
						owner = "Zeioth";
						repo = "compiler.nvim";
						rev = "a0fc34e";
						sha256 = "sha256-KIIQ1rtL9A1tZpjNNKUb5yACXGS97uaLAzCd9AogAqk=";
					};};
					config = "lua require('compiler').setup {}";}
				# Treesitter
				nvim-treesitter
				nvim-treesitter-parsers.java
				nvim-treesitter-parsers.lua
				nvim-treesitter-parsers.c
				nvim-treesitter-parsers.xml
				nvim-treesitter-parsers.json
				nvim-treesitter-parsers.graphql
				nvim-treesitter-parsers.elixir
				nvim-treesitter-parsers.nix
				# nvim-treesitter-parsers-http
			];
			extraLuaConfig = ''
vim.opt.clipboard:append "unnamedplus"
vim.opt.scrolloff = 5

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- set to true to use space instead of tab

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

vim.o.foldenable = true
vim.o.foldmethod = "syntax"

vim.cmd "COQnow"
vim.cmd "set laststatus=3"

vim.cmd [[
function! DiffRegsFunc(...)
		let l:left = a:0 == 2 ? a:1 : "@0"
		let l:right = a:0 == 2 ? a:2 : "@1"

		tabnew
		exe 'put! ='. l:left
		vnew
		exe 'put! ='. l:right

		windo setlocal buftype=nofile
		windo setlocal bufhidden=delete
		windo setlocal noswapfile
		windo diffthis
		winc t
endfunction
com -nargs=* DiffRegs call DiffRegsFunc(<f-args>)
]]
			'';
		};
		
	}
