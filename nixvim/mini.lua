vim.notify = MiniNotify.make_notify()

vim.cmd [[
	autocmd User MiniStarterOpened autocmd TabLeave <buffer> close
]]

vim.keymap.del('x', 'ys')
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], {silent=true})
