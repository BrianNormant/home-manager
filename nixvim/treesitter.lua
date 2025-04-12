require('lz.n').load {
	{
		'iswap.nvim',
		cmd = {"ISwap", "ISwapWith"},
		after = function ()
			require('iswap').setup {}
		end
	},
	{
		'nvim-treesitter-textsubjects',
		event = "DeferredUIEnter",
		after = function ()
			require('nvim-treesitter-textsubjects').configure {
				keymaps = {
					['.'] = 'textsubjects-smart',
					-- [';'] = 'textsubjects-container-outer',
					-- [':'] = 'textsubjects-container-inner',
				}
			}
		end
	},
	{
		'nvim-better-n',
		event = "DeferredUIEnter",
		before = function ()
			require('lz.n').trigger_load("mini.nvim")
			require('lz.n').trigger_load("gitsigns.nvim")
		end,
		after = function ()
			local better_n = require("better-n")
			better_n.setup { disable_default_mappings = true }

			better_n.create({ key = "/", next = "n", previous = "<s-n>" })
			local asterisk = better_n.create({ key = "*", next = "n", previous = "<s-n>" })
			vim.keymap.set({ "n", "x" }, "*", asterisk.passthrough, { expr = true, silent = true })

			local hash = better_n.create({ key = "#", next = "n", previous = "<s-n>" })
			vim.keymap.set({ "n", "x" }, "#", hash.passthrough, { expr = true, silent = true })



			local bracketed_override = function(key, name, desc_name)
				local bracket = require('mini.bracketed')

				local nav = better_n.create {
					next = function() bracket[name]('forward') end,
					previous = function() bracket[name]('backward') end,
				}

				vim.keymap.set({ "n", "x" }, "]" .. key,               nav.next,                              { desc = desc_name .. " forward"})
				vim.keymap.set({ "n", "x" }, "[" .. key,               nav.previous,                          { desc = desc_name .. " backward"})
				vim.keymap.set({ "n", "x" }, "]" .. string.upper(key), function() bracket[name]('last')  end, { desc = desc_name .. " last"})
				vim.keymap.set({ "n", "x" }, "[" .. string.upper(key), function() bracket[name]('first') end, { desc = desc_name .. " first"})
			end
			local bracketed_list = {
				{ "d", "diagnostic", "Diagnostic" },
				{ "x", "conflict",   "Conflict"},
				{ "b", "buffer",     "Buffer" },
				{ "f", "file",       "File" },
				{ "j", "jump",       "Jump" },
				{ "l", "location",   "Loclist" },
				{ "o", "oldfile",    "Oldfile" },
				{ "q", "quickfix",   "Quickfix" },
				{ "t", "treesitter", "Treesitter node" },
				{ "u", "undo",       "Undo" },
				{ "w", "window",     "Window" },
				{ "y", "yank",       "Yank" },
			}

			for _, v in ipairs(bracketed_list) do
				bracketed_override(unpack(v))
			end

			local normal_override = function(key, fn_next, fn_prev, desc)
				local nav = better_n.create {
					next = fn_next,
					previous = fn_prev,
				}

				vim.keymap.set({ "n", "x" }, "]" .. key, nav.next,     { desc = "next " .. desc})
				vim.keymap.set({ "n", "x" }, "[" .. key, nav.previous, { desc = "previous " .. desc})
			end

			local normal_list = {
				{ "i",
					function() require('mini.indentscope').operator("top", true) end,
					function() require('mini.indentscope').operator("bottom", true) end, "Indent"
				},
				{ "h",
					function() require('gitsigns').nav_hunk("next") end,
					function() require('gitsigns').nav_hunk("prev") end, "Hunk"
				},
				{ "s",
					function() vim.cmd "norm! ]s" end,
					function() vim.cmd "norm! [s" end, "misspelled word"
				},
				{ "c",
					function() vim.cmd "norm! ]c" end,
					function() vim.cmd "norm! [c" end, "diff"
				},
			}
			for _, v in ipairs(normal_list) do
				normal_override(unpack(v))
			end
			-- I prefer to use , and ;
			vim.keymap.set({ "n", "x" }, "n", better_n.next,     { expr = true, silent = true, nowait = true })
			vim.keymap.set({ "n", "x" }, "N", better_n.previous, { expr = true, silent = true, nowait = true })
			vim.keymap.set({ "n", "x"},  ",", better_n.next,     { expr = true, silent = true, nowait = true })
			vim.keymap.set({ "n", },     ";", better_n.previous, { expr = true, silent = true, nowait = true })
		end
	}
}
