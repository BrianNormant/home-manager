local gitsigns = require('gitsigns')
gitsigns.setup {}
-- TODO: Create a function with telescope/vim.select to choose a commit then display it with gitsigns.diffthis('$commit')
-- *telescope.previewers.git_commit_diff_to_head()*

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local utils = require "telescope.utils"
local git_command = utils.__git_command
local conf = require("telescope.config").values

local function telescope_select_commit()
	-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__git.lua#L67
	local opts = {
		require('telescope.themes').get_dropdown(),
		current_file = vim.fn.getreg("%"),
	}
	opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
	opts.git_command = vim.F.if_nil(
		opts.git_command,
		git_command({ "log", "--pretty=oneline", "--abbrev-commit", "--", opts.current_file },
		opts
	))

	pickers
	.new(opts, {
		prompt_title = "Git Commits For Current Buffer",
		finder = finders.new_oneshot_job(opts.git_command, opts),
		previewer = {
			previewers.git_commit_diff_to_parent.new(opts),
			previewers.git_commit_diff_to_head.new(opts),
			previewers.git_commit_diff_as_was.new(opts),
			previewers.git_commit_message.new(opts),
		},
		sorter = conf.file_sorter(opts),
		attach_mappings = function(_, map)
			actions.select_default:replace(function(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				gitsigns.diffthis(selection.value)
			end)
			-- map({ "i", "n" }, "<c-r>m", actions.git_reset_mixed)
			-- map({ "i", "n" }, "<c-r>s", actions.git_reset_soft)
			-- map({ "i", "n" }, "<c-r>h", actions.git_reset_hard)
			return true
		end,
	})
	:find()
end

--- Keymaps
local legend = {
	keymaps = {
		{"<leader>g", description = "Git keymaps"},
		{"<leader>gD",  telescope_select_commit     , description = "Open Telescope to select which commit to diff" },
		{"<leader>gS", function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end,             mode = 'v', description = "Reset hunk"},
		{"<leader>gS", gitsigns.reset_hunk,                              mode = 'n',                        description = "Reset current hunk"},
		{"<leader>gU", gitsigns.reset_buffer,                            mode = 'n',                        description = "Reset current buffer (NO UNDO)"},
		{"<leader>gb", function() gitsigns.blame_line{full=true} end,    mode = 'n',                        description = "Git blame current line"},
		{"<leader>gb", gitsigns.stage_buffer,                            mode = 'n',                        description = "Stage current buffer"},
		{"<leader>gd", gitsigns.diffthis,                                mode = 'n',                        description = "Diff file against HEAD"},
		{"<leader>gp", gitsigns.preview_hunk,                            mode = 'n',                        description = "Preview current hunk"},
		{"<leader>gs", function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end,             mode = 'v', description = "Stage hunk"},
		{"<leader>gs", gitsigns.stage_hunk,                              mode = 'n',                        description = "Stage current hunk"},
		{"<leader>gu", gitsigns.undo_stage_hunk,                         mode = 'n',                        description = "Undo last git stage"},
		{"<leader>ub", gitsigns.toggle_current_line_blame,               mode = 'n',                        description = "Show git blame"},
		{"<leader>gl", gitsigns.setloclist,                              mode = 'n',                        description = "Populate loclist with hunk of the current file"},
		{"]h",         function() gitsigns.nav_hunk('next', {navigation_message = false}) end,              description = "jump to next hunk"},
		{"[h",         function() gitsigns.nav_hunk('prev', {navigation_message = false}) end,              description = "jump to previous hunk"},
		{"[H",         function() gitsigns.nav_hunk('first',{navigation_message = true }) end,              description = "jump to first hunk"},
		{"]H",         function() gitsigns.nav_hunk('last', {navigation_message = true }) end,              description = "jump to last hunk"},
	},
}
_G.LEGEND_append(legend)

_G.diffthis_select = telescope_select_commit
