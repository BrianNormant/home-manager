require('lze').load {
	'marks.nvim',
	event = "BufNew",
	after = function ()
		require('marks').setup {}
	end
}

--- Keymaps
local legend = {
	keymaps = {
		{"mx",        description="Set mark x"},
		{"m,",        description="Set the next available alphabetical (lowercase) mark"},
		{"m;",        description="Toggle the next available mark at the current line"},
		{"dmx",       description="Delete mark x"},
		{"dm-",       description="Delete all marks on the current line"},
		{"dm<space>", description="Delete all marks in the current buffer"},
		{"m]",        description="Move to next mark"},
		{"m[",        description="Move to previous mark"},
		{"m:",        description="Preview mark. This will prompt you for a specific mark to preview; press <cr> to preview the next mark."},
		{"m[0-9]",    description="Add a bookmark from bookmark group[0-9]."},
		{"dm[0-9]",   description="Delete all bookmarks from bookmark group[0-9]."},
		{"m}",        description="Move to the next bookmark having the same type as the bookmark under the cursor. Works across buffers."},
		{"m{",        description="Move to the previous bookmark having the same type as the bookmark under the cursor. Works across buffers."},
		{"dm=",       description="Delete the bookmark under the cursor."},
	},
}
_G.legendary.append(legend)
