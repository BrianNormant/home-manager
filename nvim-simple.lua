vim.opt.clipboard:append "unnamedplus"
vim.o.laststatus = 3
vim.o.scrolloff = 5

-- indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true -- set to true to use space instead of tab
vim.o.list = true

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = true,
})
