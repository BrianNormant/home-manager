require('lze').load {
	'dropbar.nvim',
	event = "BufNew",
	after = function ()
		vim.cmd [[
		hi WinBar   guisp=#665c54 gui=underline guibg=#313131
		hi WinBarNC guisp=#665c54 gui=underline guibg=#313131
		]]
		require('dropbar').setup {}

		vim.keymap.set('n', '<F2>', function() require('dropbar.api').pick() end)
	end
}
