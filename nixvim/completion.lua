-----------------------[ completeopt and shortmess ]---------------------------

local snippets = require 'mini.snippets'
local gen_loader = require('mini.snippets').gen_loader
snippets.setup {
	snippets = {
		gen_loader.from_lang(),
	},
}

require('lz.n').load {
	"mini.snippets",
	event = "LspAttach",
	---@diagnostic disable-next-line: undefined-global
	after = MiniSnippets.start_lsp_server
}

-- would be nice to have a custom completefunc that ask `mini.snippets` for the snippets
-- so <ctrl-x><ctrl-o> would show lsp results
-- while <ctrl-x><ctrl-u> would show snippets ONLY
-- local completefunc = function(findstart, base)
-- 	-- fist check if mini.snippets is running
-- 	vim.lsp.buf.
-- end

local completion = require 'mini.completion'
completion.setup {
	-- <C-x><C-o>
	-- so each buffer can define a custom user func
	lsp_completion = { source_func = 'omnifunc' },
	delay = {
		completion = 2500,
		info = 5000,
		signature = 1000,
	},
	mappings = {
		force_twostep = "",
		force_fallback = "",
	},
	fallback_action = "",
}

vim.opt.completeopt = {
	"menuone",
	"popup",
	"fuzzy",
	"nosort",
	"noinsert", -- works very well with no insert, allows to search with fuzzy easily
}

vim.opt.shortmess:append "c"
vim.o.pumheight = 20

--- <CR> to select if and only if a item is selected
--- use autopairs functionnality of:
--- {|} -> {
--- \t|
--- }
_G.MUtils= {}
MUtils.CR = function()
	local npairs = require('nvim-autopairs');
	if vim.fn.pumvisible() ~= 0 then
		if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
			return npairs.esc('<c-y>')
		else
			return npairs.esc('<c-e>') .. npairs.autopairs_cr()
		end
	else
		return npairs.autopairs_cr()
	end
end
vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

--- tabkey to navigated in completion menu
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		-- vim.defer_fn(require('compl')._start_info, 5)
		return "<c-n>"
	else
		return "<Tab>"
	end
end, {expr = true})
vim.keymap.set("i", "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		-- vim.defer_fn(require('compl')._start_info, 5)
		return "<c-p>"
	else
		return "<S-Tab>"
	end
end, {expr = true})

--- Up/Down should ignore the completion menu
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



MUtils.BS = function()
	local npairs = require('nvim-autopairs');
	if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({"selected"}).selected ~= -1 then
		return npairs.esc('<c-e>')
	else
		return npairs.autopairs_bs()
	end
end
--- BS should cancel the completion if opened
vim.api.nvim_set_keymap("i", "<BS>", 'v:lua.MUtils.BS()', {expr = true, noremap = true });

vim.keymap.set("i", "<Esc>", function ()
	if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({"selected"}).selected ~= -1 then
		return "<c-e>"
	else
		return "<Esc>"
	end
end, {expr = true, noremap = true, silent = true})
