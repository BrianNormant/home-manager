require("luasnip.loaders.from_vscode").lazy_load()

local legend = {
	keymaps = {
		{"<C-L>", mode = { "i", "s" }, function() require('luasnip').jump(1) end,  description="Complete tag with luasnip"},
		{"<C-J>", mode = { "i", "s" }, function() require('luasnip').jump(-1) end, description="Complete tag with luasnip reverse"},
		{"<C-K>", mode = { "i", "s" }, function()
			local ls = require('luasnip')
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, description="Choose tag with with luasnip reverse"},
	},
}
_G.LEGEND_append(legend)

