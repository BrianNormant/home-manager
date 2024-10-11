local loaded = false
local lazyload = function ()
	if not loaded then
		require('icon-picker').setup {
			disable_legacy_commands = true,
		}
		loaded = true
	end
end

--- Keymaps
local legend = {
	keymaps = {
		{"<C-e>", function()
			lazyload()
			vim.cmd "IconPickerInsert"
		end, mode="i", description="󰱨 Icon Picker insert"},
		{"<C-e>", function()
			lazyload()
			vim.cmd "IconPickerNormal"
		end, mode="n", description="󰱨 Icon Picker normal"},
	},
}
_G.LEGEND_append(legend)
