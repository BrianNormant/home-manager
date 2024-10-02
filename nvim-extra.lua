if vim.g.neovide then
	vim.o.guifont = "FiraCode Nerd Font:h12";
	vim.g.neovide_floating_shadow = false;
	vim.g.neovide_position_animation_length = 0.05;
	vim.g.neovide_scroll_animation_length = 0;
	vim.g.neovide_scroll_animation_far_lines = 0;
	vim.g.neovide_hide_mouse_when_typing = true;
	vim.g.neovide_refresh_rate = 120;
	vim.g.neovide_cursor_animation_length = 0;
	if vim.g.neovide then
		vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
		vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
		vim.keymap.set({ "n" , "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
	end
end

vim.opt.clipboard:append "unnamedplus"
vim.opt.scrolloff = 5

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.showtabline = 2
vim.opt.expandtab = false -- set to true to use space instead of tab


-- enable spell check
vim.opt.spelllang = 'en_us'
vim.opt.spell = true
--- clear spell check highlights
vim.cmd [[
hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal
]]

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

vim.o.foldenable = true
vim.o.foldmethod = "syntax"

vim.cmd "set listchars=tab:··>,trail:█,nbsp:󱁐"
vim.cmd "set invlist"

-- Open help in a new tab
vim.cmd "cabbrev h tab help"

-- Open Man in a new tab
vim.cmd "cabbrev Man tab Man"


-- TODO rewrite this in vimscript
vim.cmd [[
	function! DiffRegsFunc(...)
	let l:left = a:0 == 2 ? a:1 : "@0"
	let l:right = a:0 == 2 ? a:2 : "@1"

	tabnew
	exe 'put! ='. l:left
	vnew
	exe 'put! ='. l:right

	windo setlocal buftype=nofile
	windo setlocal bufhidden=delete
	windo setlocal noswapfile
	windo diffthis
	winc t
	endfunction
	com -nargs=* DiffRegs call DiffRegsFunc(<f-args>)
]]
