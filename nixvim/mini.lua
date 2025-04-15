vim.notify = MiniNotify.make_notify()

vim.cmd [[
	autocmd User MiniStarterOpened autocmd TabLeave <buffer> close
]]
