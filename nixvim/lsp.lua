require('actions-preview').setup {
	highlight_command = {
		require("actions-preview.highlight").delta(),
	},
	backend = { "telescope" },
}

local hover = require('hover')
hover.setup {
	init = function ()
		require('hover.providers.lsp')
		require('hover.providers.dap')
		require('hover.providers.diagnostic')
		require('hover.providers.man')
		require('hover.providers.dictionary')
		-- gh is avaible if needs be for github issues tracking
	end
}

require('docs-view').setup {
	position = "bottom",
}

require('goto-preview').setup {
	border = "rounded"
}


local function pick_many(items, prompt, label_f, opts)
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"
	local finders = require "telescope.finders"
	local pickers = require "telescope.pickers"
	local conf = require("telescope.config").values

	local co = coroutine.running()
	pickers.new({}, {
		prompt_title = prompt,
		finder = finders.new_table {
			results = vim.tbl_map(function(item)
				return {
					value = item,
					display = label_f(item),
				}
			end, items),
			entry_maker = function(entry)
				return {
					value = entry.value,
					display = entry.display,
					ordinal = entry.display,
				}
			end
		},
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(_, _)
			actions.select_default:replace(function(prompt_bufnr)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local choices = picker:get_multi_selection()

				actions.close(prompt_bufnr)
				choices = vim.tbl_map(function(choice) return choice.value end, choices)
				coroutine.resume(co, choices)
			end)
			return true
		end,
	}):find()

	local result = coroutine.yield()
	return result
end

require('jdtls.ui').pick_many = pick_many
