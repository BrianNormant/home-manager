local loaded = false
vim.api.nvim_create_autocmd({"BufNew"}, {
	group = "Lazy",
	pattern = "*",
	callback = function()
		if loaded then return end
		loaded = true
		require ('Comment').setup()
	end
})

--- Keymaps
local legend = {
	keymaps = {
		{ "gc", description = "Toggle line Comment" },
		{ "gb", description = "Toggle block Comment" },
		{ "gco", description = "Inserts comment below and enters INSERT mode" },
		{ "gcO", description = "Inserts comment above and enters INSERT mode" },
		{ "gcA", description = "Inserts comment at the end of line and enters INSERT mode" },
	},
}
_G.LEGEND_append(legend)
