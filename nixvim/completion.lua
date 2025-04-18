require('lz.n').load {
	{
		"supermaven-nvim",
		event = "DeferredUIEnter",
		after = function ()
			require("supermaven-nvim").setup {
				disable_inline_completion = true, -- disables inline completion for use with cmp
				disable_keymaps = true, -- disables built in keymaps for more manual control
				log_level = "off", -- Shut off the warnings
			}
		end
	},
	{
		"compl.nvim",
		event = "DeferredUIEnter",
		after = function ()
			require("compl").setup {
				completion = {
					fuzzy = false,
					timeout = 500,
				},
				info = { enable = true, },
				snippet = {
					enable = true,
					-- add friendly snippets
					paths = {
						_G.friendly_snippets_path
					}
				}
			}
		end
	}
}

--- <CR> to select if and only if a item is selected
vim.keymap.set("i", "<CR>", function()
	if vim.fn.complete_info()["selected"] ~= -1 then
		return "<C-y>"
	end
	if vim.fn.pumvisible() ~= 0 then
		return "<c-e><CR>"
	else
		return "<CR>"
	end
end, {expr = true})

--- adapted from :help ins-completion
local clevertab = function (tab, next_or_previous)
		--- When the line is not empty, call completion
	if #vim.fn.getline('.') == 0 then
		return tab
	else
		return next_or_previous
	end
end

--- tabkey to navigated in completion menu
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<c-n>"
	else
		return clevertab("<Tab>", "<c-n>")
	end
end, {expr = true})
vim.keymap.set("i", "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<c-p>"
	else
		return clevertab("<S-Tab>", "<c-p>")
	end
end, {expr = true})

--- Jump in snippets
vim.keymap.set({"i", "s"}, "<c-l>", function()
	if vim.snippet.active { direction = 1 } then
		vim.snippet.jump(1)
	end
end, {desc = "Snippets jump next"})
vim.keymap.set({"i", "s"}, "<c-k>", function()
	if vim.snippet.active { direction = -1 } then
		vim.snippet.jump(-1)
	end
end, {desc = "Snippets jump previous"})

vim.opt.completeopt = {
	"menuone",
	"noselect",
	"noinsert",
	"fuzzy",
	"preview",
}
vim.opt.shortmess:append "c"


--- Up/Down should ignore with the completion menu
vim.keymap.set("i", "<Down>", function()
	if vim.fn.pumvisible() ~= 0 then
		return "<C-e><Down>"
	end
	return "<Down>"
end, {expr = true, silent = true})
vim.keymap.set("i", "<Up>", function()
	if vim.fn.pumvisible() ~= 0 then
		return "<C-e><Up>"
	end
	return "<Up>"
end, {expr = true, silent = true})
