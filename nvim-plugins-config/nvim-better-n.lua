-- TODO
local better_n = require("better-n")

better_n.setup {
	disable_defaults_mappings = true,
}


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


vim.keymap.set({ "n", "x" }, ",", better_n.next, { expr = true, silent = true, nowait = true })
