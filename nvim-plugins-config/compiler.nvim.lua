local loaded = false

local function lazyload()
	if not loaded then
		require('overseer').setup {}
		require('compiler').setup {}
		loaded = true
	end
end


--- Keybinds
local legend = {
	keymaps = {
		{"<F5>", function ()
			lazyload()
			vim.cmd "CompilerOpen"
		end, description = "Open compiler view"},
		{"<F17>", function () -- <S-F5>
			lazyload()
			vim.cmd "CompilerRedo"
		end, description = "Redo last compiler option"},
		{"<F6>", function ()
			lazyload()
			vim.cmd "CompilerToggleResult"
		end , description = "Toggle compiler result window"},
	},
}
_G.LEGEND_append(legend)
