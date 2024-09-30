local gitsigns = require('gitsigns')
gitsigns.setup {}

--- Keymaps
local legend = {
	keymaps = {
		{"<leader>ub",           gitsigns.toggle_current_line_blame,               mode = 'n',            description = "Show git blame"},
		{"<leader>gs",           gitsigns.stage_hunk,                              mode = 'n',            description = "Stage current hunk"},
		{"<leader>gS",           gitsigns.reset_hunk,                              mode = 'n',            description = "Reset current hunk"},
		{"<leader>gs",           function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, mode = 'v', description = "Stage hunk"},
		{"<leader>gS",           function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, mode = 'v', description = "Reset hunk"},
		{"<leader>gb",           gitsigns.stage_buffer,                            mode = 'n',            description = "Stage current buffer"},
		{"<leader>gu",           gitsigns.undo_stage_hunk,                         mode = 'n',            description = "Undo last git stage"},
		{"<leader>gU",           gitsigns.reset_buffer,                            mode = 'n',            description = "Reset current buffer (NO UNDO)"},
		{"<leader>gh",           gitsigns.preview_hunk,                            mode = 'n',            description = "Preview current hunk"},
		{"<leader>gb",           function() gitsigns.blame_line{full=true} end,    mode = 'n',            description = "Git blame current line"},
		{"<leader>gd",           gitsigns.diffthis,                                mode = 'n',            description = "Diff file against HEAD"},
		{"<leader>gD",           function() gitsigns.diffthis('~') end,            mode = 'n',            description = "diff file against last commit"},
	},
}
_G.LEGEND_append(legend)
