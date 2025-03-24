if vim.g.neovide then
	vim.o.guifont = "FiraCode Nerd Font:h12";
	vim.g.neovide_floating_shadow = false;
	vim.g.neovide_position_animation_length = 0.10;
	vim.g.neovide_scroll_animation_length = 0;
	vim.g.neovide_scroll_animation_far_lines = 0;
	vim.g.neovide_hide_mouse_when_typing = true;
	vim.g.neovide_refresh_rate = 120;
	vim.g.neovide_cursor_animation_length = 0.13;
	vim.g.neovide_cursor_trail_size = 0;
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_cursor_smooth_blink = true;
	vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
	vim.keymap.set({ "n", "v" }, "<C-S-C>", '"+y', { desc = "Copy system clipboard" })
	vim.keymap.set({ "n", "v" }, "<C-S-V>", '"+p', { desc = "Paste system clipboard" })
end

vim.opt.clipboard:append "unnamedplus"
vim.opt.scrolloff = 5
vim.o.updatetime = 200

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.laststatus = 3
vim.opt.cmdheight = 1
vim.o.showmode = false
vim.opt.showtabline = 2
vim.opt.expandtab = false -- set to true to use space instead of tab
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.ignorecase = true
vim.o.smartcase = true

-- enable spell check
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

vim.o.foldenable = true
vim.o.foldmethod = "syntax"

vim.api.nvim_create_autocmd( {"TextYankPost"}, {
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
	end,
})

vim.opt_global.listchars:append {
	tab = "··>",
	trail = "█",
	nbsp = "󱁐",
}
vim.o.list = true;
vim.opt_global.fillchars:append { eob = "~" }

-- Open help in a new tab
vim.cmd "cabbrev h tab help"

-- Open Man in a new tab
vim.cmd "cabbrev Man tab Man"

vim.cmd "colorscheme gruvbox-material"
