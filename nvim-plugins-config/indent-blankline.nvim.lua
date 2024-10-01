local highlight = {
	"Comment",
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
		tab_char = { "▏" }
	},
	scope = {
		enabled = true,
		highlight = "Blue",
		char = "║",
		show_end = false,
	},
}
