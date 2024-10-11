local diffview = require("diffview")

local loaded = false
local lazyload = function ()
	if not loaded then
		diffview.setup {
			hooks = {
				view_opened = function(view)
					if not _G.diffview_info then
						_G.diffview_info = {}
					end
					_G.diffview_info[view.tabpage] = true
				end,
				view_closed = function(view)
					_G.diffview_info[view.tabpage] = nil
				end
			},
			enhanced_diff_hl = false,
			[ "view.x.layout" ] = "diff3_mixed",
		}
		loaded = true
	end
end



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
	lazyload()
	-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__git.lua#L67
	local opts = {
		require('telescope.themes').get_dropdown(),
	}
	opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
	opts.git_command = vim.F.if_nil(
		opts.git_command,
		git_command({ "log", "--pretty=oneline", "--abbrev-commit", "--", '.' },
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
				diffview.open(selection.value)
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
		{"<leader>G", function()
			lazyload()
			vim.cmd "DiffviewOpen"
		end, description="Open DiffView"},
		{"<leader>gG", telescope_select_commit, description="Use telescope to select witch commit diffview must diff with"},
	},
}
_G.LEGEND_append(legend)

_G.diffview_select = telescope_select_commit
