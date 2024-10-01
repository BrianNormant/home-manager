local gitsigns = require('gitsigns')
gitsigns.setup {}

--- Keymaps
local legend = {
	keymaps = {
		-- TODO: Create a function with telescope/vim.select to choose a commit then display it with gitsigns.diffthis('$commit')
		{"<leader>g", description = "Git keymaps"},
		{"<leader>gD",           function() gitsigns.diffthis('~') end,            mode = 'n',            description = "diff file against last commit"},
		{"<leader>gS",           function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, mode = 'v', description = "Reset hunk"},
		{"<leader>gS",           gitsigns.reset_hunk,                              mode = 'n',            description = "Reset current hunk"},
		{"<leader>gU",           gitsigns.reset_buffer,                            mode = 'n',            description = "Reset current buffer (NO UNDO)"},
		{"<leader>gb",           function() gitsigns.blame_line{full=true} end,    mode = 'n',            description = "Git blame current line"},
		{"<leader>gb",           gitsigns.stage_buffer,                            mode = 'n',            description = "Stage current buffer"},
		{"<leader>gd",           gitsigns.diffthis,                                mode = 'n',            description = "Diff file against HEAD"},
		{"<leader>gp",           gitsigns.preview_hunk,                            mode = 'n',            description = "Preview current hunk"},
		{"<leader>gs",           function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, mode = 'v', description = "Stage hunk"},
		{"<leader>gs",           gitsigns.stage_hunk,                              mode = 'n',            description = "Stage current hunk"},
		{"<leader>gu",           gitsigns.undo_stage_hunk,                         mode = 'n',            description = "Undo last git stage"},
		{"<leader>ub",           gitsigns.toggle_current_line_blame,               mode = 'n',            description = "Show git blame"},
	},
}
_G.LEGEND_append(legend)
