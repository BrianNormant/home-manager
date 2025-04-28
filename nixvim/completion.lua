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
		before = function ()
			require('lz.n').trigger_load('markview.nvim')
		end,
		after = function ()
			require("compl").setup {
				completion = {
					fuzzy = false,
					timeout = 1,
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

-----------------------[ completeopt and shortmess ]---------------------------

vim.opt.completeopt = {
	"menuone",
	"popup",
	"fuzzy",
}

vim.opt.shortmess:append "c"
vim.o.pumheight = 20

_G.compl_autorefresh = false -- refresh the completion items on every keystroke
_G.auto_trigger_completion = true -- trigger completion as soon as supermaven has suggestion


vim.keymap.set("i", "<C-x>", function()
	if vim.fn.complete_info()["selected"] == -1 and vim.fn.pumvisible() == 1 then
		-- in 99% of scenarios, this means that supermaven have
		-- a suggestion but we don't want to use it.
		-- because we always autoselect the other suggestions.
		-- If we were use <C-l> for lines and wanted to repeat it
		-- If would already be selected because of autoselect options
		return "<C-e><C-x>"
	else
		return "<C-x>"
	end
end, {expr = true, noremap = true})

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

--- adapted from :help ins-completion
local clevertab = function (tab, next_or_previous)
	-- local after = get_chars_after_cursor()
	-- if string.match("(\t|' ')*", after) ~= nil then
	-- 	return next_or_previous
	-- end
	return tab
end

--- tabkey to navigated in completion menu
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		vim.defer_fn(require('compl')._start_info, 5)
		return "<c-n>"
	else
		return clevertab("<Tab>", "<c-n>")
	end
end, {expr = true})
vim.keymap.set("i", "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		vim.defer_fn(require('compl')._start_info, 5)
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
		npairs.autopairs_bs()
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

--- Everytime the text changes, we check if supermaven has a suggestion,
--- If it does, we show the complete window (enabling noinsert noselect first)
vim.api.nvim_create_autocmd({ "TextChangedI" }, {
	callback = vim.schedule_wrap(function()
		if not _G.auto_trigger_completion then return end
		if vim.fn.mode(1) == "ix" then return end -- we are waiting for a completion submode


		-- if the completion window is open, we stop immediately
		if vim.fn.complete_info()["selected"] ~= -1 then return end

		local CompPrev = require('supermaven-nvim.completion_preview')
		local inlay_instance = CompPrev:get_inlay_instance()
		if inlay_instance == nil then
			return
		end
		if not inlay_instance.is_active then
			CompPrev:dispose_inlay()
			return
		end

		local col = vim.fn.col('.')

		-- we have a suggestion!
		local text = inlay_instance.completion_text

		CompPrev:dispose_inlay()
		local abbr = string.sub(text, 1, 25)
		local menu = "SuperMaven"
		local match = {
			word = text,
			abbr = abbr,
			menu = menu,
			-- info = info,
			user_data = { supermaven = true },
		}

		vim.opt.completeopt:append('noinsert')
		vim.opt.completeopt:append('noselect')

		vim.fn.complete(col, {match})

		vim.opt.completeopt:remove('noinsert')
		vim.opt.completeopt:remove('noselect')
	end)
})
