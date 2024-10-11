function load()
	vim.cmd [[
	hi WinBar   guisp=#665c54 gui=underline guibg=#313131
	hi WinBarNC guisp=#665c54 gui=underline guibg=#313131
	]]
	require('dropbar').setup {}
end

vim.api.nvim_create_autocmd("UIEnter", {
	group = "Lazy",
	pattern = { "*" },
	callback = load,
})

--- Keymaps
local legend = {
	keymaps = {
		{"<F2>", function() require('dropbar.api').pick() end, description="Open dropbar"},
	},
}
_G.LEGEND_append(legend)
