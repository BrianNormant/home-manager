local M = {}

M.lsp = {
	{
		name = "Goto Definition",
		cmd = vim.lsp.buf.definition,
		rtxt = "gd",
	},
	{
		name = "Goto Declaration",
		cmd = vim.lsp.buf.declaration,
		rtxt = "gD",
	},
	{
		name = "Goto Type Definition",
		cmd = vim.lsp.buf.type_definition,
		rtxt = "go"
	},
	{
		name = "Goto Implementation",
		cmd = vim.lsp.buf.Implementation,
		rtxt = "gi",
	},
	{
		name = "Goto References",
		cmd = vim.lsp.buf.references,
		rtxt = "gr"
	},
	{ name = "separator" },
	{
		name = "Rename symbol",
		cmd = vim.lsp.buf.rename,
		rtxt = "gR",
	},
	{
		name = "Format Buffer",
		cmd = function()
			vim.lsp.buf.format {
				filter = function(client) return client.name ~= "null-ls" end
			}
		end,
		rtxt = "<leader>lf",
	},
	{ name = "separator" },
	{
		name = "Set Loclist",
		cmd = vim.diagnostic.setloclist,
		rtxt = "<leader>ll"
	},
	{
		name = "Set Quickfix",
		cmd = vim.diagnostic.setqflist,
		rtxt = "<leader>ll"
	},
	{
		name = "Code actions",
		cmd = require('actions-preview').code_actions,
		rtxt = "<leader>la",
	},
	{ name = "separator" },
	{
		name = "Lsp Info",
		cmd = function()
			vim.cmd "LspInfo"
		end,
		rtxt = "<leader>li",
	},
	{
		name = "Stop Lsp",
		cmd = function()
			vim.cmd "LspStop"
		end,
		rtxt = "<leader>lS",
		
	},
	{
		name = "Start Lsp",
		cmd = function()
			vim.cmd "LspStart"
		end,
		rtxt = "<leader>ls",
	},
	{
		name = "Restart Lsp",
		cmd =function ()
			vim.cmd "LspRestart"
		end,
		rtxt = "<leader>lr",
	}
}


local preview = require('goto-preview')
M.lsp_preview = {
	{
		name = "Preview Definition",
		cmd = preview.goto_preview_definition,
		rtxt = "gpd",
	},
	{
		name = "Preview Type Definition",
		cmd = preview.goto_preview_type_definition,
		rtxt = "gpt",
	},
	{
		name = "Preview Implementation",
		cmd = preview.goto_preview_implementation,
		rtxt = "gpi",
	},
	{
		name = "Preview Declaration",
		cmd = preview.goto_preview_declaration,
		rtxt = "gpD",
	},
	{
		name = "Preview References",
		cmd = preview.goto_preview_references,
		rtxt = "gpr",
	},
	{
		name = "Close Preview",
		cmd = preview.close_all_win,
		rtxt = "gP",
	}
}

M.nvim = {
	{
		name = "Open Tab",
		cmd = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.cmd ("tab sb " .. bufnr)
		end,
		rtxt = "<C-w>t"
	},
	{
		name = "Open Split",
		cmd = function()
			vim.cmd "split"
		end,
		rtxt = "\\",
	},
	{
		name = "Open VSplit",
		cmd = function()
			vim.cmd "vsplit"
		end,
		rtxt = "|",
	},
	{
		name = "Close Window",
		cmd = function()
			vim.cmd "wq"
		end,
		rtxt = "ZZ",
	},
	{ name = "separator" },
	{
		name = "Move Right",
		cmd = function()
			vim.api.nvim_input("L")
		end,
		rtxt = "<C-w>L"
	},
	{
		name = "Move Left",
		cmd = function()
			vim.api.nvim_input("H")
		end,
		rtxt = "<C-w>H"
	},
	{
		name = "Move Up",
		cmd = function()
			vim.api.nvim_input("K")
		end,
		rtxt = "<C-w>K"
	},
	{
		name = "Move Down",
		cmd = function()
			vim.api.nvim_input("J")
		end,
		rtxt = "<C-w>J"
	},
	{
		name = "Rotate Window",
		cmd = function()
			vim.api.nvim_input("r")
		end,
		rtxt = "<C-w>r",
	},
	{
		name = "Exchange Window",
		cmd =function()
			vim.api.nvim_input("x")
		end,
		rtxt = "<C-w>x",
	}
}

local gitsigns = require("gitsigns")
M.git = {
	{
		name = "Blame Line",
		cmd = gitsigns.toggle_currnet_line_blame,
		rtxt = "<leader>ub",
	},
	{
		name = "Preview Hunk",
		cmd = gitsigns.preview_hunk,
		rtxt = "<leader>gp",
	},
	{
		name = "Stage Hunk",
		cmd = gitsigns.stage_hunk,
		rtxt = "<leaedr>gs",
	},
	{
		name = "Undo Stage",
		cmd = gitsigns.undo_stage_hunk,
		rtxt = "<clander>gu",
	},
	{
		name = "Reset Hunk",
		cmd = gitsigns.reset_hunk,
		rtxt = "<leader>gS",
	},
	{
		name = "Stage Buffer",
		cmd = gitsigns.stage_buffer,
		rtxt = "<leader>gb",
	},
	{
		name = " Reset Buffer",
		cmd = gitsigns.reset_buffer,
		rtxt = "<leader>gU",
	},
	{ name = "separator" },
	{
		name = "Set loclist",
		cmd = gitsigns.setloclist,
		rtxt = "<leader>gl",
	},
	{
		name = "Set qfList",
		cmd = function() gitsigns.setqflist("all") end,
	},
	{ name = "separator" },
	{
		name = "Diff HEAD",
		cmd = gitsigns.diffthis,
		rtxt = "<leader>gd",
	},
	{
		name = "Diff Select",
		cmd = _G.diffthis_select,
		rtxt = "<leader>gD",
	},
	{
		name = "Diff Project",
		cmd = require('diffview').open,
		rtxt = "<leader>G",
	},
	{
		name = "Diff Project Select",
		cmd = _G.diffview_select,
		rtxt = "<leader>gG",
	},
}

local marks = require('marks')
M.marks = {
	{
		name = "Set Mark",
		cmd = marks.set_next,
		rtxt = "m,"
	},
	{
		name = "Delete Mark",
		cmd = marks.delete_line,
		rtxt = "dm-",
	},
	{
		name = "Delete Mark Buffer",
		cmd = marks.delete_buf,
		rtxt = "dm<space>",
	},
	{
		name = "Marks Quickfix",
		cmd = function()
			vim.cmd "MarksQFListAll"
		end,
	}
}


local navbuddy = require('nvim-navbuddy.actions')
M.navbuddy = {
	{
		name = "Rename symbol",
		cmd = function()
			vim.api.nvim_input("r")
		end,
		rtxt = "r",
	},
	{
		name = "Split on Symbol",
		cmd = function()
			vim.api.nvim_input("")
		end,
		rtxt = "<C-s>"
	},
	{
		name = "VSplit on Symbol",
		cmd = function()
			vim.api.nvim_input("")
		end,
		rtxt = "<C-v>",
	},
	{
		name = "Delete Symbol",
		cmd = function()
			vim.api.nvim_input("d")
		end,
		rtxt = "d",
	}
}

M.oil = {
	{
		name = "Preview",
		cmd = function() vim.api.nvim_input("") end,
		rtxt = "<C-p>",
	},
	{
		name = "Set cwd here",
		cmd = function() vim.api.nvim_input("`") end,
		rtxt = "`",
	},
	{
		name = "Show hidden",
		cmd = function() vim.api.nvim_input("g.") end,
		rtxt = "g.",
	},
	{
		name = "VSplit",
		cmd = function() vim.api.nvim_input("") end,
		rtxt = "<C-s>",
	},
	{
		name = "Split",
		cmd = function() vim.api.nvim_input("") end,
		rtxt = "<C-h>",
	},
	{
		name = "Go up 1 directory",
		cmd = function() vim.api.nvim_input("-") end,
		rtxt = "-",
	},
	{
		name = "Change to cwd",
		cmd = function() vim.api.nvim_input("_") end,
		rtxt = "_",
	},
	{
		name = "Tab",
		cmd = function() vim.api.nvim_input("") end,
		rtxt = "<C-t>",
	},
}

M.diffview = {
	{
		name = "Commit Info",
		cmd = function() vim.api.nvim_input("L") end,
		rtxt = "L",
	},
	{
		name = "Stage",
		cmd = function() vim.api.nvim_input("s") end,
		rtxt = "S",
	},
	{
		name = "Stage All",
		cmd = function() vim.api.nvim_input("S") end,
		rtxt = "s",
	},
	{
		name = "Unstage All",
		cmd = function() vim.api.nvim_input("U") end,
		rtxt = "U",
	},
	{
		name = "Next Conflict",
		cmd = function() vim.api.nvim_input("]x") end,
		rtxt = "]x",
	},
	{
		name = "Prev Conflict",
		cmd = function() vim.api.nvim_input("[x") end,
		rtxt = "[x",
	},
	{
		name = "Delete Conflicts",
		cmd = function() vim.api.nvim_input("dX") end,
		rtxt = "dX",
	},
	{
		name = "Select OURS",
		cmd = function() vim.api.nvim_input(" cO") end,
		rtxt = "<leader>cO",
	},
	{
		name = "Select THEIRS",
		cmd = function() vim.api.nvim_input(" cT") end,
		rtxt = "<leader>cT",
	},
	{
		name = "File Panel",
		cmd = function() vim.api.nvim_input(" b") end,
		rtxt = "<leader>b",
	},
	{
		name = "Cycle Layout",
		cmd = function() vim.api.nvim_input("g") end,
		rtxt = "g<C-x>",
	},
}

-- TODO: DiffView
M.gen_menu = function()
	local ignored_ft = { 'help' }
	for _, ft in ipairs(ignored_ft) do
		if vim.bo.filetype == ft then
			return {}
		end
	end
	if vim.bo.filetype == 'Navbuddy' then
		return M.navbuddy
	end
	if vim.bo.filetype == 'oil' then
		return M.oil
	end
	local menu = {
		{
			name = "Info",
			cmd = vim.lsp.buf.hover,
			rtxt = "K",
		},
		{
			name = "Show Tree",
			cmd = require('nvim-navbuddy').open,
			rtxt = "L",
		},
		{
			name = "SpellCheck",
			cmd = require('telescope.builtin').spell_suggest,
			rtxt = "z=",
		},
		{ name = "separator" },
		{
			name = " Nvim Actions",
			hl = "Conditional",
			items = M.nvim,
		},
		{
			name = "󱗖 Marks",
			hl = "Conditional",
			items = M.marks,
		}
	}
	if _G.diffview_info then
		if _G.diffview_info[vim.api.nvim_get_current_tabpage()] then
			menu[#menu+1] = {
				name = "󰕚 DiffView",
				hl = "Conditional",
				items = M.diffview,
			}
		end
	end
	if #vim.lsp.get_clients({bufnr = vim.api.nvim_get_current_buf()}) > 0 then
		menu[#menu+1] = {
			name = " LSP Actions",
			hl = "Conditional",
			items = M.lsp,
		}
		menu[#menu+1] = {
			name = " LSP Preview",
			hl = "Conditional",
			items = M.lsp_preview,
		}
	end
	local r = vim.system({'git', 'ls-files', '--error-unmatch', '--',  vim.api.nvim_buf_get_name(0) }):wait()
	if r.code == 0 then
		menu[#menu+1] = {
			name = " Git Actions",
			hl = "Conditional",
			items = M.git,
		}
	end
	return menu
end

local menu = require('menu')

vim.keymap.set("n", "<RightMouse>", function()
	vim.cmd.exec '"normal! \\<RightMouse>"'
	menu.open(M.gen_menu(), { mouse = true, border = false }) end,
{ silent = true } )
