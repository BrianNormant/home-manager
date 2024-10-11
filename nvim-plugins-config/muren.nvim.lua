local loaded = false
local lazyload = function ()
	if not loaded then
		require('muren').setup {
			all_on_line = false,
			patterns_width = 75,
			patterns_height = 10,
			options_width = 25,
			preview_height = 12,
			anchor = "top",
		}
		loaded = true
	end
end

--- Key maps
local legend = {
	keymaps = {
		{"<F3>", function()
			lazyload()
			vim.cmd "MurenToggle"
		end, mode = { "n", "v" }, description="Open Muren"},
	},
}
_G.LEGEND_append(legend)

