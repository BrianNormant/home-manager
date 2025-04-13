require('lz.n').load {
	{
		'registers.nvim',
		keys = {
			{ '"', mode = { "n", "x" }},
			{ "<C-r>", mode = "i" },
		},
		cmd = "Registers",
		after = function()
			require'registers'.setup {
				window = {
					border = "double",
					transparency = 10,
				},
			}


			vim.cmd [[
				let g:registers_delay_ms = 500

				function! DelayMap(key, command)
				  let status = wait(g:registers_delay_ms, 'getchar(1)')
				  if status < 0
					return a:command
				  else
					return a:key
				  end
				endfunction
				xnoremap <expr> " DelayMap('"', '<cmd>lua require("registers").show_window {mode="motion"}()<cr>')
				inoremap <expr> <C-R> DelayMap('<C-R>', '<cmd>lua require("registers").show_window {mode="insert"}()<cr>')
				nnoremap <expr> " DelayMap('"', '<cmd>lua require("registers").show_window {mode="motion"}()<cr>')
			]]
		end,
	},
	{
		"marks.nvim",
		event = "DeferredUIEnter",
		after = function()
			require('marks').setup {}
		end,
	}
}
