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

vim.api.nvim_create_augroup("Lazy", { clear = true; })

_G.LEGEND_merge = function (a, b)
	local keymaps = {}
	if a.keymaps ~= nil then vim.list_extend(keymaps, a.keymaps) end
	if b.keymaps ~= nil then vim.list_extend(keymaps, b.keymaps) end

	local commands = {}
	if a.commands ~= nil then vim.list_extend(commands, a.commands) end
	if b.commands ~= nil then vim.list_extend(commands, b.commands) end

	return {
		keymaps = keymaps,
		commands = commands
	}
end
-- add the Key maps to the global Key maps table that legendary will read
-- @args a table of keymaps and/or commands and/or function
_G.LEGEND_append = function(a)
	_G.LEGEND_S = _G.LEGEND_merge(_G.LEGEND_S, a)
end

_G.LEGEND_S = {}
