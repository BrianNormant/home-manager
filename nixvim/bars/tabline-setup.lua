---@diagnostic disable-next-line: undefined-global
tabline.setup {
	default = {
		components = {
			{
				kind = "tabs",
				condition = function ()
					return vim.g.bars_tabline_show_buflist ~= true;
				end,

				separator = " ",
				-- separator_hl = "Normal",

				overflow = " ┇ ",
				-- overflow_hl = "BarsNavOverflow",

				nav_left = "   ",
				-- nav_left_hl = "BarsNav",

				nav_left_locked = "    ",
				-- nav_left_locked_hl = "BarsNavLocked",

				nav_right = "   ",
				-- nav_right_hl = "BarsNav",

				nav_right_locked = " 󰌾  ",
				-- nav_right_locked_hl = "BarsNavLocked",

				active = {
					padding_left = " ",
					padding_right = " ",

					divider = " ┃ ",

					win_count = "󰨝 %d",
					win_count_hl = nil,

					icon = "󰛺 ",

					-- hl = "BarsTab"
				},
				inactive = {
					padding_left = " ",
					padding_right = " ",

					divider = " | ",

					win_count = "󰨝 %d",
					win_count_hl = nil,

					icon = "󰛻 ",

					-- hl = "BarsInactive"
				}
			},
		},
	}
}
