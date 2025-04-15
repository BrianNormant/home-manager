{ pkgs, ...}: {
	programs.nixvim = {
		extraPlugins = with pkgs.vimPlugins; [ alpha-nvim ];
		extraConfigLua = ''
			local beta = {}
			-- we set the default dimention of the starter:

			beta.terminal = {
				type = "terminal",
				command = nil,
				width = 100,
				height = 8,
				opts = {
					redraw = true,
					window_config = {},
				},
			}

			beta.section = {}

			-- create a header with figlet
			local get_header_text = function()
				local text = "nixvim"
				local font = "starwars"

				if (vim.env.PROJECT) then text = vim.env.PROJECT end

				local figlet = vim.system({'figlet', '-w', 100, '-c', '-f', font, text }, {text=true}):wait()
				
				local str = figlet.stdout
				local sep = "\n"
				local t = {}
				for w in string.gmatch(str, "[^" .. sep .. "]+") do
					table.insert(t, w)
				end

				return t
			end

			beta.section.header = {
				type = "text",
				val = get_header_text(),
				opts = {
					position = "center",
					hl = "Type",
				},
			}

			local create_button = function(tbl)
				local k = tbl[1]
				if tbl[3] ~= nil then k = "" end
				local opts = {
					position = "center",
					shortcut = k,
					cursor = 3,
					width = 50,
					align_shortcut = "right",
					hl_shortcut = "Keyword",
				}
				return {
					type = "button",
					val = tbl[2],
					opts = opts,
					on_press = function()
						local v = opts.shortcut
						if tbl[3] ~= nil then v = tbl[1] end
						local key = vim.api.nvim_replace_termcodes(v, true, false, true)
						vim.api.nvim_feedkeys(key, "t", false)
					end
				}
			end

			beta.telescope = {
				type = "group",
				val = vim.tbl_map(create_button, {
					{"<leader>ff", "Files"},
					{"<leader>oo", "Oil"},
					{"<leader>ff", "Live grep"},
					{"<cmd>Telescope git_files theme=dropdown<CR>",    "Git Files", 1},
					{"<cmd>Telescope git_commits theme=dropdown<CR>",  "Git Commits", 1},
					{"<cmd>Telescope git_branches theme=dropdown<CR>", "Git Branches", 1},
					{"<cmd>Telescope git_stash theme=dropdown<CR>",    "Git Stashes", 1},
					{"<cmd>Telescope help_tags theme=ivy<CR>",         "Help", 1},
					{"<cmd>lua _G.telescope_keymaps()<CR>",            "Keymaps", 1},
					{"<cmd>Telescope colorscheme theme=ivy<CR>",       "Colorscheme", 1},
					{"<leader>ft", "Telescope Builtins"},
				}),
				opts = { spacing = 1 },
			}

			beta.git = {
				type = "group",
				val = vim.tbl_map(create_button, {
					{"<leader>G", "Git status"},
					{"<leader>fg", "Git log"},
					{"<leader>gc", "Git commit"},
					{"<leader>gp", "Git pull",},
					{"<leader>gP", "Git push",},
					{"<CMD>Git stash<CR>", "Git stash",},
				})
			}

			beta.action = {
				type = "group",
				val = vim.tbl_map(create_button, {
					{":edit ", "Edit new buffer", 1},
					{"ZZ", "Quit Neovim"},
				}),
				opts = { spacing = 1 },
			}
			
			-- Get a cool tip, inspiration from Tip.nvim
			local get_tip = function()
				local obj = vim.system({"curl", "-L", "https://vtip.43z.one"}, {text = true}):wait()
				if obj.code ~= 0 then return "⚠ ERROR" end
				return obj.stdout
			end
			
			beta.section.footer = {
				type = "text",
				val = get_tip,
				opts = {
					position = "center",
					hl = "Number",
				},
			}

			beta.config = {
				layout = {
					{ type = "padding", val = 2 },
					beta.section.header,
					{ type = "padding", val = 2 },
					beta.telescope,
					{ type = "padding", val = 2 },
					beta.git,
					{ type = "padding", val = 2 },
					beta.action,
					beta.section.footer,
				},
				opts = {
					margin = 5,
				},
			}

			require("alpha").setup(beta.config)
		'';
	};
}
