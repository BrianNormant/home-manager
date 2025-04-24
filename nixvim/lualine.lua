local lualine = require('lualine')

local theme = _G.get_lualine_theme()
local colors = _G.get_colors()


local function mode_text()
	-- When supermaven has a suggestion
	if vim.fn.pumvisible() == 1 and vim.fn.complete_info()["selected"] == -1 then
		return "   SuperMaven    "
	end
	local equtbl = {
		--- see :help mode()
		--- Normal
		["n"]    = "      Normal     ", -- <Esc>, <C-c>, ...
		--- Insert
		["i"]    = "      Insert     ", -- i,a,o,c,...
		["ix"]   = "   InsertCompl   ", -- i_ctrl-x
		["ic"]   = "    OmniCompl    ", -- i_ctrl-x_ctrl-o
		--- Replace
		["R"]    = "     Replace     ", -- R ,i_INS
		["Rx"]   = "   ReplaceCompl  ", -- r_ctrl-x
		["Rc"]   = "   ReplaceOmni   ", -- r_ctrl-x_ctrl-o
		--- Virtual Replace
		["Rv"]   = "   VirtReplace   ", -- gR
		["Rvx"]  = " VirtReplaceCompl", -- gR_ctrl-x
		["Rvc"]  = " VirtReplaceOmni ", -- gR_ctrl-x_ctrl-o
		--- Visual
		["v"]    = "      Visual     ", -- v
		["V"]    = "    VisualLine   ", -- V
		[""]   = "   VisualBlock   ", -- <c-v>
		--- Select
		["s"]    = "      Select     ", -- v_ctrl-g
		["S"]    = "    SelectLine   ", -- V_ctrl-g
		[""]   = "   SelectBlock   ", -- <c-v>ctrl-g
		--- Terminal
		["t"]    = "     Terminal    ", -- :term
		["nt"]   = "    NTerminal    ", -- Ctrl-\_Ctrl-N
		--- _CTRL-O
		["vs"]   = "   VisualSelect  ", -- v_ctrl-g_ctrl-o
		["Vs"]   = " VisualSelectLine", -- V_ctrl-g_ctrl-o
		["s"]  = "VisualSelectBlock", -- <C-v>_ctrl-g_ctrl-o
		["niI"]  = "    C-OInsert    ", -- i_ctrl-o
		["niR"]  = "    C-OReplace   ", -- R_ctrl-o
		["niV"]  = " C-OVirtReplace  ", -- gR_ctrl-o
		["ntT"]  = "   C-OTerminal   ", -- t_Ctrl-\_ctrl-o
		--- Operator Pending
		["no"]   = "     Operator    ", -- after an operator, ie: d,y,c,gm,ga,ys,...
		["nov"]  = "  OperatorFChar  ", -- o_v -- force the movement to be charwise
		["noV"]  = "  OperatorFLine  ", -- o_V -- force the movement to be linewise
		["no"] = "  OperatorFBlock ", -- o_Ctrl-v -- force the movement to be block wise
		--- Command
		["c"]    = "     Command     ", -- :
		--- Wait
		["!"]    = "       Wait      ", -- I don't know how to trigger this mode...
	}
	local mode = vim.fn.mode(1)
	for m, txt in pairs(equtbl) do
		if mode == m then
			return txt
		end
	end
	return mode
end

-- This would be a pain to change because different colorscheme
-- Have different way to name their colors
-- Maybe get the color with nvim_get_hl?
local function mode_color()
	if vim.fn.pumvisible() == 1 and vim.fn.complete_info()["selected"] == -1 then
		return {fg = "#7c8ec0", bg = "#32302f", gui="italic"}
	end
	local equtbl = {
		--- see :help mode()
		--- Normal
		["n"]    = {fg = "#ebdbb2", bg = "#32302F"},
		--- Insert
		["i"]    = {fg = "#7c8ec0", bg = "#32302f"},
		["ix"]   = {fg = "#7c8ec0", bg = "#fdf0d5"},
		["ic"]   = {fg = "#7c8ec0", bg = "#32302f", gui="bold"},
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
		["t"]    = {fg = "#7c8ec0", bg = "#99430a", gui = "bold",},
		["nt"]   = {fg = "#ebdbb2", bg = "#99430a", gui = "bold"},
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

