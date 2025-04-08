local lualine = require('lualine')

local contrast = _G.gruvbox_contrast

local theme = require('gruvbox-material.lualine').theme(contrast)
local g_colors = require("gruvbox-material.colors")
local colors = g_colors.get(vim.o.background, contrast)


local function mode_text()
	local equtbl = {
		--- see :help mode()
		--- Normal
		["n"]    = "      Normal     ",
		--- Insert
		["i"]    = "      Insert     ",
		["ix"]   = "   InsertCompl   ",
		["ic"]   = "    OmniCompl    ",
		--- Replace
		["R"]    = "     Replace     ",
		["Rx"]   = "   ReplaceCompl  ",
		["Rc"]   = "   ReplaceOmni   ",
		--- Virtual Replace
		["Rv"]   = "   VirtReplace   ",
		["Rvx"]  = " VirtReplaceCompl",
		["Rvc"]  = " VirtReplaceOmni ",
		--- Visual
		["v"]    = "      Visual     ",
		["V"]    = "    VisualLine   ",
		[""]   = "   VisualBlock   ",
		--- Select
		["s"]    = "      Select     ",
		["S"]    = "    SelectLine   ",
		[""]   = "   SelectBlock   ",
		--- Terminal
		["t"]    = "     Terminal    ",
		["nt"]   = "    NTerminal    ", -- Ctrl-\_Ctrl-N
		--- _CTRL-O
		["vs"]   = "   VisualSelect  ",
		["Vs"]   = " VisualSelectLine",
		["s"]  = "VisualSelectBlock",
		["niI"]  = "    C-OInsert    ",
		["niR"]  = "    C-OReplace   ",
		["niV"]  = " C-OVirtReplace  ",
		["ntT"]  = "   C-OTerminal   ",
		--- Operator Pending
		["no"]   = "     Operator    ",
		["nov"]  = "  OperatorFChar  ",
		["noV"]  = "  OperatorFLine  ",
		["no"] = "  OperatorFBlock ",
		--- Command
		["c"]    = "     Command     ",
		--- Wait
		["!"]    = "       Wait      ",
	}
	local mode = vim.fn.mode(1)
	for m, txt in pairs(equtbl) do
		if mode == m then
			return txt
		end
	end
	return mode
end

local function mode_color()
	local equtbl = {
		--- see :help mode()
		--- Normal
		["n"]    = {fg = "#ebdbb2", bg = "#32302F"},
		--- Insert
		["i"]    = {fg = "#7c8ec0", bg = "#32302f"},
		["ix"]   = {fg = "#7c8ec0", bg = "#fdf0d5"},
		["ic"]   = {fg = "#7c8ec0", bg = "#fdf0d5"},
		--- Replace
		["R"]    = {fg = "#c11c1f", bg = "#32302F"},
		["Rx"]   = {fg = "#c11c1f", bg = "#fdf0d5"},
		["Rc"]   = {fg = "#c11c1f", bg = "#fdf0d5"},
		--- Virtual Replace
		["Rv"]   = {fg = "#c11c1f", bg = "#32302F", gui="bold",},
		["Rvx"]  = {fg = "#c11c1f", bg = "#fdf0d5", gui="bold",},
		["Rvc"]  = {fg = "#c11c1f", bg = "#fdf0d5", gui="bold",},
		--- Visual
		["v"]    = {fg = "#8ec07c", bg = "#32302F"},
		["V"]    = {fg = "#8ec07c", bg = "#fdf0d5"},
		[""]   = {fg = "#8ec07c", bg = "#fdf0d5", gui = "italic"},
		--- Select
		["s"]    = {fg = "#8ec07c", bg = "#32302F", gui="bold",},
		["S"]    = {fg = "#8ec07c", bg = "#fdf0d5", gui="bold",},
		[""]   = {fg = "#8ec07c", bg = "#fdf0d5", gui="bold,italic",},
		---- Terminal
		["t"]    = {fg = "#7c8ec0", bg = "#99430a"},
		["nt"]   = {fg = "#ebdbb2", bg = "#99430a"},
		--- _CTRL-O
		["vs"]   = {fg = "#8ec07c", bg = "#32302F", gui="italic"},
		["Vs"]   = {fg = "#8ec07c", bg = "#fdf0d5", gui="italic"},
		["s"]  = {fg = "#8ec07c", bg = "#fdf0d5", gui="italic"},
		["niI"]  = {fg = "#7c8ec0", bg = "#32302F", gui="italic"},
		["niR"]  = {fg = "#c11c1f", bg = "#32302F", gui="italic"},
		["niV"]  = {fg = "#c11c1f", bg = "#32302F", gui="italic,bold"},
		["ntT"]  = {fg = "#fe8019", bg = "#32302F", gui="italic"},
		--- Operator pending
		["no"]   = {fg = "#b16286", bg = "#32302F"},
		["nov"]  = {fg = "#b16286", bg = "#32302F"},
		["noV"]  = {fg = "#b16286", bg = "#32302F", gui = "italic"},
		["no"] = {fg = "#b16286", bg = "#32302F", gui = "bold"},
		--- Command
		["c"]    = {fg = "#FFAF00", bg = "#32302F"},
		--- Wait
		["!"]    = {fg = "#ff0000", bg = "#cc00e6"},
	}
	local mode = vim.api.nvim_get_mode().mode
	if equtbl[mode] then
		return equtbl[mode]
	else
		return { fg = "#cc00e6" }
	end
end

local config = {
	options = {
		-- Disable sections and component separators
		icons_enabled = true;
		component_separators = '',
		section_separators = '',
		theme = theme,
	},
	sections = {
		lualine_a = { {
			mode_text,
			color = mode_color,
			icon = '',
			padding = { left = 1, right = 1},
		}, },
		lualine_b = {
			{'selectioncount'},
			{
				'FugitiveStatusline',
				icon = '',
				padding = { left = 1, right = 1 },
				color = { fg = colors.orange },
			},
			{
				'diagnostics',
			},
		},
		lualine_c = {
			{'progress', color = { fg = colors.fg, gui = 'italic'}},
			{
				'filetype',
				icon_only = true,
				padding = { left = 1, right = 0 },
				icon = { align = 'right' }
			},
			{
				'filename',
				color = { fg = colors.fg, gui = 'bold'},
				padding = { left = 0, right = 1 },
			},
			{
				function()
					local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf()})
					if next(clients) == nil then
						return ' No Lsp'
					end

					local c = vim.tbl_map(function(v) return v.name end, clients)

					return '⚡' .. table.concat(c, ' & ')
				end,
				color = { fg = "#FFAF00", },
			},
			-- {'location', color = { fg = colors.fg, gui = 'italic'}},
		},

		lualine_x = {
			'o:encoding',
			'o:fileformat',
		},
		lualine_y = {
			function()
				if vim.v.hlsearch == 0 then
					return ' '
				end
				local sh = vim.fn.getreg('/')
				if sh ~= '' then
					return "search: " .. sh
				else
					return " "
				end
			end,
		},
		lualine_z = {
			{
				'diff',
				symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
				color = { bg = "#282828", }
			}
		},
	},
}

vim.o.laststatus = 3; -- https://www.reddit.com/r/neovim/comments/1clx1cu/optionsvimoptlaststatus_config_being_overridden/
lualine.setup(config)

