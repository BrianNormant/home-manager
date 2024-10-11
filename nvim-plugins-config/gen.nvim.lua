local loaded = false
local lazyload = function ()
	if not loaded then
		require 'gen'.setup({
			model = 'llama3:latest',
			display_mode = 'split',
			show_prompt = true,
			show_model = true,
		})
		loaded = true
	end
end

--- Keymaps
local legend = {
	keymaps = {
		{"<F1>",  function ()
			lazyload()
			vim.cmd "Gen"
		end, mode={ "n", "v" }, description="Open Generative AI"},
	},
}
_G.LEGEND_append(legend)
