local telescope = require "telescope"
telescope.setup {
	defaults = {
		layout_strategy = "flex",
		theme = "ivy",
	},
	extensions = {
		["ui-select"] = {
			theme = "cursor",
		},
	},
}
telescope.load_extension('lsp_handlers')
telescope.load_extension('ui-select')

-- Keymaps
local legend = {
	keymaps = {
		{"<leader>f", description = "Telescope Fuzzy finding"},
		{"<leader>ft", require('telescope.builtin').builtin, description="Telescope find builtins"},
		{"<leader>ff", '<cmd>Telescope find_files<cr>',                description="Telescope find files"},
		{"<leader>fF", '<cmd>Telescope live_grep<cr>',                 description="Telescope live grep"},
		{"<leader>fb", '<cmd>Telescope buffers<cr>',                   description="Telescope find buffers"},
		{"<leader>f/", '<cmd>Telescope current_buffer_fuzzy_find<cr>', description="Telescope live grep in file"},
		{"<M-h>",      '<cmd>Telescope help_tags<cr>',                 description="Telescope neovim help"},

		{"<leader>fd", '<cmd>Telescope lsp_definitions<cr>',           description="Telescope find LSP definitions"},
		{"<leader>fr", '<cmd>Telescope lsp_references<cr>',            description="Telescope find LSP references"},
		{"<leader>fi", '<cmd>Telescope lsp_implementations<cr>',       description="Telescope find LSP implementations"},
		{"<leader>fp", '<cmd>Telescope diagnostics<cr>',               description="Telescope find LSP diagnostics"},
		{"<CR>",       description = "Telescope mapping: Confirm selection"},
		{"<C-x>",      description = "Telescope mapping: Go to file selection as a split"},
		{"<C-v>",      description = "Telescope mapping: Go to file selection as a vsplit"},
		{"<C-t>",      description = "Telescope mapping: Go to a file in a new tab"},
		{"<C-u>",      description = "Telescope mapping: Scroll up in preview window"},
		{"<C-d>",      description = "Telescope mapping: Scroll down in preview window"},
		{"<C-f>",      description = "Telescope mapping: Scroll left in preview window"},
		{"<C-k>",      description = "Telescope mapping: Scroll right in preview window"},
		{"<M-f>",      description = "Telescope mapping: Scroll left in results window"},
		{"<M-k>",      description = "Telescope mapping: Scroll right in results window"},
		{"<C-/>",      description = "Telescope mapping: Show mappings for picker actions (insert mode)"},
		{"?",          description = "Telescope mapping: Show mappings for picker actions (normal mode)"},
		{"<C-c>",      description = "Telescope mapping: Close telescope (insert mode)"},
		{"<Esc>",      description = "Telescope mapping: Close telescope (in normal mode)"},
		{"<Tab>",      description = "Telescope mapping: Toggle selection and move to next selection"},
		{"<S-Tab>",    description = "Telescope mapping: Toggle selection and move to prev selection"},
		{"<C-q>",      description = "Telescope mapping: Send all items not filtered to quickfixlist (qflist)"},
		{"<M-q>",      description = "Telescope mapping: Send all selected items to qflist"},
		{"<C-r><C-w>", description = "Telescope mapping: Insert cword in original window into prompt (insert mode)"},
		{"<C-r><C-a>", description = "Telescope mapping: Insert cWORD in original window into prompt (insert mode)"},
		{"<C-r><C-f>", description = "Telescope mapping: Insert cfile in original window into prompt (insert mode)"},
		{"<C-r><C-l>", description = "Telescope mapping: Insert cline in original window into prompt (insert mode)"},
	},
}
_G.LEGEND_append(legend)
