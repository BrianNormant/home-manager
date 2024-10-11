local setup = function ()
	local highlight = {
		"Comment", -- we want the first line to not be highlighted strongly
		"MarkdownH1",
		"MarkdownH2",
		"MarkdownH3",
		"MarkdownH4",
		"MarkdownH5",
		"MarkdownH6",
	}

	require("ibl").setup {
		indent = {
			highlight = highlight,
			char = "▏",
			tab_char = { "·" }
		},
		scope = {
			enabled = true,
			highlight = "Blue",
			char = "║",
			show_end = false,
		},
	}
end

vim.api.nvim_create_autocmd({"UIEnter"},{
	group = "Lazy",
	pattern = "*",
	callback = setup,
})
