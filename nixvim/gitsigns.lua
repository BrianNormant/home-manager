local map = vim.keymap.set
local gitsigns = require('gitsigns')


-- Actions
map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage Hunk'})
map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset Hunk'})

map('v', '<leader>hs', function()
	gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }, { desc = 'Stage Hunk'})
end)

map('v', '<leader>hr', function()
	gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }, { desc = 'Reset Hunk'})
end)

map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage Buffer'})
map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset Buffer'})
map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview Hunk'})
map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = "Preview hunk virtual text"})

map('n', '<leader>hb', function()
	gitsigns.blame_line({ full = true })
end, {desc = 'Blame Line'})

map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff This Buffer'})

map('n', '<leader>hD', function()
	gitsigns.diffthis('~')
end, {desc = 'Diff Buffer against last Commit'})

map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, {desc = 'Send Hunks to Quickfix'})
map('n', '<leader>hq', gitsigns.setqflist, {desc = 'Send Hunks to Quickfix'})

-- Toggles
map('n', '<leader>tb', gitsigns.toggle_current_line_blame, {desc = "Git blame toggle current line"})
map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Git Toggle deleted lines'})
map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = 'Git Toggle word diff'})

-- Text object
map({'o', 'x'}, 'ih', gitsigns.select_hunk, { desc = 'Git Hunk'})

map('n', "[H", function() gitsigns.nav_hunk('first',{navigation_message = true }) end, { desc = "jump to first hunk" })
map('n', "]H", function() gitsigns.nav_hunk('last', {navigation_message = true }) end, { desc = "jump to last hunk" })


