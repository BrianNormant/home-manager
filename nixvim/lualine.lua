local lualine = require('lualine')

local contrast = "soft"

local theme = require('gruvbox-material.lualine').theme(contrast)
local g_colors = require("gruvbox-material.colors")
local colors = g_colors.get(vim.o.background, contrast)

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand('%:p:h')
		local gitdir = vim.fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}



-- Config
local config = {
	options = {
		-- Disable sections and component separators
		component_separators = '',
		section_separators = '',
		theme = theme,
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

local function mode_color()
	local equtbl = {
		--- see :help mode()
		["R"]    = { fg = colors.blue, },
		["Rx"]   = { fg = colors.blue, bg = colors.bg_diff_red },
		["Rc"]   = { fg = colors.blue, bg = colors.bg_diff_green },
		["Rv"]   = { fg = colors.blue, gui = "bold"},
		["Rvx"]  = { fg = colors.blue, bg = colors.bg_diff_red ,gui = "bold"},
		["Rvc"]  = { fg = colors.blue, bg = colors.bg_diff_green, gui = "bold"},
		["s"]    = { fg = colors.green },
		["S"]    = { fg = colors.green },
		[""]   = { fg = colors.green, gui  = "bold" },
		["vs"]   = { fg = colors.green, bg = colors.orange},
		["Vs"]   = { fg = colors.green, bg = colors.orange},
		["s"]  = { fg = colors.green, bg = colors.orange, gui = "bold"},
		["v"]    = { fg = colors.orange, },
		["V"]    = { fg = colors.orange, },
		[""]   = { fg = colors.orange, gui = "bold" },
		["i"]    = { fg = colors.red, },
		["ic"]   = { fg = colors.red, bg = colors.bg_diff_green },
		["ix"]   = { fg = colors.red, bg = colors.bg_diff_red },
		["niI"]  = { fg = colors.red, gui = "underline" },
		["niR"]  = { fg = colors.blue, gui = "underline" },
		["niV"]  = { fg = colors.blue, gui = "underline" },
		["t"]    = { fg = colors.yellow, },
		["nt"]   = { fg = colors.yellow, gui = "underline" },
		["ntT"]  = { fg = colors.yellow, gui = "underline" },
		["no"]   = { fg = colors.purple, },
		["nov"]  = { fg = colors.purple, },
		["noV"]  = { fg = colors.purple, },
		["no"] = { fg = colors.purple, gui = "bold" },
		["n"]    = { fg = colors.fg1, },
		["!"]    = { fg = colors.red, bg = colors.bg_visual_red, gui = "bold"},
		["c"]    = { fg = "#331a99" }
	}
	local mode = vim.api.nvim_get_mode().mode
	if equtbl[mode] then
		return equtbl[mode]
	else
		return { fg = "#cc00e6" }
	end
end

local function mode_text()
	local equtbl = {
		--- see :help mode()
		[""]   = "SelectBlock      ",
		[""]   = "VisualBlock      ",
		["s"]  = "VisualSelectBlock",
		["!"]    = "Wait             ",
		["R"]    = "Replace          ",
		["Rc"]   = "ReplaceOmni      ",
		["Rv"]   = "VirtReplace      ",
		["Rvc"]  = "VirtReplaceOmni  ",
		["Rvx"]  = "VirtReplaceCompl ",
		["Rx"]   = "ReplaceCompl     ",
		["S"]    = "SelectLine       ",
		["V"]    = "VisualLine       ",
		["Vs"]   = "VisualSelectLine ",
		["i"]    = "Insert           ",
		["ic"]   = "OmniComp         ",
		["ix"]   = "InsertCompl      ",
		["n"]    = "Normal           ",
		["niI"]  = "NInsert          ",
		["niR"]  = "NReplace         ",
		["niV"]  = "NVirtReplace     ",
		["no"] = "OperatorBlock    ",
		["no"]   = "Operator         ",
		["noV"]  = "OperatorLine     ",
		["nov"]  = "OperatorChar     ",
		["nt"]   = "NTerminal        ",
		["ntT"]  = "NNTerminal       ",
		["s"]    = "Select           ",
		["t"]    = "Terminal         ",
		["v"]    = "Visual           ",
		["vs"]   = "VisualSelect     ",
		["c"]    = "Command          ",
	}
	local mode = vim.api.nvim_get_mode().mode
	for m, txt in pairs(equtbl) do
		if mode == m then
			return txt
		end
	end
	return mode
end

local function format_recording()
	if vim.fn.reg_recording() ~= "" then
		return "Recording @" .. vim.fn.reg_recording()
	else
		return ""
	end
end

ins_left {
	-- mode component
	mode_text,
	color = mode_color,
	icon = '',
	padding = { right = 1 },
}

ins_left {
	format_recording,
	cond = function()
		return vim.fn.reg_recording() ~= ""
	end,
	color = { fg = colors.fg0 }
}


ins_left {
	-- filesize component
	'filetype',
	cond = conditions.buffer_not_empty,
}

ins_left {
	'filename',
	cond = conditions.buffer_not_empty,
	color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	symbols = { error = ' ', warn = ' ', info = ' ' },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2

ins_left {
	color = { fg = colors.grey, gui = 'bold' },
	-- Lsp server name .,
	function()
		local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf()})
		if next(clients) == nil then
			return '%=No Lsp'
		end

		local c = vim.tbl_map(function(v) return v.name end, clients)

		return '%=' .. ' LSP:' .. table.concat(c, ' & ')
	end,
}

ins_right {
	function()
		return '%='
	end,
}
-- Add components to right sections
ins_right {
	function()
		if vim.v.hlsearch == 0 then
			return ''
		end
		local last_search = vim.fn.getreg('/')
		if not last_search or last_search == '' then
			return ''
		end
		local searchcount = vim.fn.searchcount { maxcount = 9999 }
		return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
	end,
}


ins_right {
	'rest',
	color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
	'o:encoding', -- option component same as &encoding in viml
	fmt = string.upper, -- I'm not sure why it's upper case either ;)
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = 'bold' },
}

ins_right {
	'fileformat',
	fmt = string.upper,
	icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
	color = { fg = colors.green, gui = 'bold' },
}

ins_right {
	'branch',
	icon = '',
	color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
	'diff',
	-- Is it me or the symbol for modified us really weird
	symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
}

vim.o.laststatus = 3; -- https://www.reddit.com/r/neovim/comments/1clx1cu/optionsvimoptlaststatus_config_being_overridden/
lualine.setup(config)

lualine.setup {
	options = {
		theme = require('gruvbox-material.lualine').theme("soft")
	}
}
