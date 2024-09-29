vim.g.gruvbox_material_background = 'soft'
vim.cmd.colorscheme("gruvbox-material")
vim.opt.laststatus = 3
vim.cmd [[
hi NormalFloat ctermfg=223 ctermbg=236 guifg=#d4be98 guibg=#32302f
hi FloatBorder ctermfg=245 ctermbg=236 guifg=#928374 guibg=#32302f
hi FloatTitle  ctermfg=208 ctermbg=236 guifg=#e78a4e guibg=#32302f cterm=bold
]]

----------------- Put custom lua that should be accessible by all plugins here.


--[[
merge the keybinds and commands table of a and b. using vim.tbl_extend
for use with legendary.nvim, the idea being that each plugin can add its keybinds to a global table like so:
```lua
local legend = {
	keybinds = { ... },
	commands = { ... },
}

vim.g.legend_append(legend)
```
]]--
vim.g.legend_merge = function (a, b)
	local keybinds = {}
	if a.keybinds ~= nil then vim.list_extend(keybinds, a.keybinds) end
	if b.keybinds ~= nil then vim.list_extend(keybinds, b.keybinds) end

	local commands = {}
	if a.commands ~= nil then vim.list_extend(commands, a.commands) end
	if b.commands ~= nil then vim.list_extend(commands, b.commands) end

	return {
		keybinds = keybinds,
		commands = commands
	}
end
vim.g.legend_append = function(a)
	vim.g.legend = vim.g.legend_merge(vim.g.legend, a)
end
