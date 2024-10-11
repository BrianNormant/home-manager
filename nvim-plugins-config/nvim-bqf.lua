local loaded = false
local lazyload = function ()
	if not loaded then
		require('bqf').setup {
			preview = {
				border = "double",
				show_scroll_bar = false,
				winblend = 0  -- Disable transparency
			},
		}
		loaded = true
	end
end

vim.api.nvim_create_autocmd("QuickFixCmdPre", {
	group = "Lazy",
	pattern = "*",
	callback = lazyload,
})

local legend = {
	keymaps = {
		{'zf',      description = "Bqf enter fuzzy mode"},
		{'<tab>',   description = "Bqf toggle sign of item and move up"},
		{'<S-tab>', description = "Bqf toggle sign of item and move down"},
		{'zn',      description = "Bqf new qflist with signed items"},
		{'zN',      description = "Bqf new qflsit with unsigned items"},
		{'<C-t>',   description = "Bqf open file in tab and close qflist"},
		{'<C-x>',   description = "Bqf open file in split"},
		{'<C-v>',   description = "Bqf open file in vertical split"},
		{'<C-v>',   description = "Bqf open file in vertical split"},
		{'<C-o>',   description = "Bqf(fzf) new qflist with fitlered items"},
		{'o',       description = "Bqf open item and close qflist"},
		{'t',       description = "Bqf open item in new tab"},
		{'T',       description = "Bqf open item in new tab but stay in qflist"},
		{'<',       description = "Bqf go to last qflist"},
		{'>',       description = "Bqf go to current qflist"},
	},
}

_G.LEGEND_append(legend)
