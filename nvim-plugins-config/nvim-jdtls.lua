local jdtls = require 'jdtls'
local root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', "pom.xml"})

local config = {
	cmd = {
		'jdtls',
		"-data", root_dir,
	},
	settings = {
		java = {
			configuration = {
				runtimes = {
					-- {name = "JavaSE-17", path = "~/.gradle/jdks/eclipse_adoptium-17-amd64-linux/jdk-17.0.10+7" },
					-- {name = "JavaSE-21", path = "~/.gradle/jdks/eclipse_adoptium-21-amd64-linux/jdk-21.0.2+13",},
					{name = "JavaSE-21", path = "~/.java/home/jdk-21",},
					{name = "JavaSE-17", path = "~/.java/home/jdk-17",},
					-- {name = "JavaSE-8",  path = "~/.java/home/jdk-8" ,},
				}
			},
			references = {
				includeDecompiledSources = true,
			}
		},
	},
	root_dir = root_dir,
	init_options = {
		bundles = {
			vim.fn.glob(vscodepath .. "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1),
		}
	},
}

--- Replace the default picker with telescope
local function pick_many(items, prompt, label_f, opts)
  if not items or #items == 0 then
    return {}
  end

  label_f = label_f or function(item)
    return item
  end
  opts = opts or {}

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

-- To attach a dap to junit
-- https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#vscode-java-test-installation

vim.api.nvim_create_autocmd( { 'BufEnter', 'FileType' }, {
	pattern = {'*'},
	callback = function(ev)
		if vim.bo.filetype == "java" then
			jdtls.start_or_attach(config)
			vim.api.nvim_create_autocmd({'InsertLeave', 'CursorHold', 'CursorMoved'}, {
				group = "LSP_inlayHints",
				desc = 'Update inlay hints on line change',
				buffer = ev.buf,
				callback = function()
					vim.lsp.inlay_hint.enable(true, {bufnr = ev.buf})
				end,
			})
			vim.api.nvim_create_autocmd({"InsertEnter"}, {
				group = "LSP_inlayHints",
				desc = 'Remove inlay hints before insert',
				buffer = ev.buf,
				callback = function()
					vim.lsp.inlay_hint.enable(false, {bufnr = ev.buf})
				end
			})
			-- TODO install dap
			-- vim.defer_fn(function () require('jdtls.dap').setup_dap_main_class_configs() end, 3000) -- Wait for LSP to start
		end
	end,
})

local legend = {
	keymaps = {
		{'<A-o>', function() require('jdtls').organize_imports() end, mode = 'n', description="jdtls organize imports"},
		{'cjc',   function() require('jdtls').extract_constant() end, mode = 'n', description="jdtls extract constant"},
		{'cjm',   function() require('jdtls').extract_method()   end, mode = 'n', description="jdtls extract method"},
		{'cjv',   function() require('jdtls').extract_variable() end, mode = 'n', description="jdtls extract variable"},
		{'cjv',   function() require('jdtls').extract_variable() end, mode = 'n', description="jdtls extract variable"},
	},
}
_G.LEGEND_append(legend)
