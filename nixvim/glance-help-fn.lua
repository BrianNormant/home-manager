-- We want to pause the autocmd from Glance as they will close
-- Glance whenever we leave it's windows

local group = "Glance"
local glance_autocmds = vim.api.nvim_get_autocmds {
	group = group,
}
vim.api.nvim_clear_autocmds {
	group = group,
}

local lines = {
	"j         next item",
	"k         previous item",
	"<Down>    next item",
	"<Up>      previous item",
	"<Tab>     next location (skips groups, cycles)",
	"<S-Tab>   previous location (skips groups, cycles)",
	"<C-u>     scroll up the preview window",
	"<C-d>     scroll down the preview window",
	"v         open location in vertical split",
	"s         open location in horizontal split",
	"t         open in new tab",
	"<CR>      jump to location",
	"o         jump to location",
	"l         open fold",
	"h         close fold",
	"<leader>l focus preview window",
	"q         close Glance window",
	"Q         close Glance window",
	"<Esc>     close Glance window",
	"<C-q>     send all locations to quickfix list",
	"g?        show this help",
	"q         close this help",
}
local highlights = {
	{ "Special", 1,  0, 1 + vim.api.nvim_strwidth("j") },
	{ "Special", 2,  0, 1 + vim.api.nvim_strwidth("k") },
	{ "Special", 3,  0, 1 + vim.api.nvim_strwidth("<Down>") },
	{ "Special", 4,  0, 1 + vim.api.nvim_strwidth("<Up>") },
	{ "Special", 5,  0, 1 + vim.api.nvim_strwidth("<Tab>") },
	{ "Special", 6,  0, 1 + vim.api.nvim_strwidth("<S-Tab>") },
	{ "Special", 7,  0, 1 + vim.api.nvim_strwidth("<C-u>") },
	{ "Special", 8,  0, 1 + vim.api.nvim_strwidth("<C-d>") },
	{ "Special", 9,  0, 1 + vim.api.nvim_strwidth("v") },
	{ "Special", 10, 0, 1 + vim.api.nvim_strwidth("s") },
	{ "Special", 11, 0, 1 + vim.api.nvim_strwidth("t") },
	{ "Special", 12, 0, 1 + vim.api.nvim_strwidth("<CR>") },
	{ "Special", 13, 0, 1 + vim.api.nvim_strwidth("o") },
	{ "Special", 14, 0, 1 + vim.api.nvim_strwidth("l") },
	{ "Special", 15, 0, 1 + vim.api.nvim_strwidth("h") },
	{ "Special", 16, 0, 1 + vim.api.nvim_strwidth("<leader>l") },
	{ "Special", 17, 0, 1 + vim.api.nvim_strwidth("q") },
	{ "Special", 18, 0, 1 + vim.api.nvim_strwidth("Q") },
	{ "Special", 19, 0, 1 + vim.api.nvim_strwidth("<Esc>") },
	{ "Special", 20, 0, 1 + vim.api.nvim_strwidth("<C-q>") },
	{ "Special", 21, 0, 1 + vim.api.nvim_strwidth("g?") },
	{ "Special", 22, 0, 1 + vim.api.nvim_strwidth("q") },
}
local bufnr = vim.api.nvim_create_buf(false, true)
local ns = vim.api.nvim_create_namespace("glance-help")
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
for _, hl in ipairs(highlights) do
	local hl_group, lnum, start_col, end_col = unpack(hl)
	vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, start_col, {
		end_col = end_col,
		hl_group = hl_group,
	})
end
vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr})
vim.bo[bufnr].bufhidden = 'wipe'
vim.bo[bufnr].modifiable = false
local editor_width = vim.o.columns
local editor_height = vim.o.lines
local max_line = 50; -- the max width in the help text
local winid = vim.api.nvim_open_win(bufnr, true, {
	relative = "editor",
	row = math.max(0, (editor_height - #lines) / 2),
	col = math.max(0, (editor_width - max_line - 1) / 2),
	width = math.min(editor_width, max_line + 1),
	height = math.min(editor_height, #lines),
	zindex = 150,
	style = "minimal",
	border = "rounded",
})
local function close()
	if vim.api.nvim_win_is_valid(winid) then
		vim.api.nvim_win_close(winid, true)
	end
end
vim.api.nvim_create_autocmd("BufLeave", {
	callback = close,
	once = true,
	nested = true,
	buffer = bufnr,
})
vim.api.nvim_create_autocmd("WinLeave", {
	callback = close,
	once = true,
	nested = true,
})

-- We can now resume the autocmds

for _, autocmd in ipairs(glance_autocmds) do
	local event = autocmd.event
	autocmd.event = nil
	autocmd.id = nil
	autocmd.group = autocmd.group_name
	autocmd.group_name = nil
	autocmd.buflocal = nil
	if autocmd.buffer then
		autocmd.pattern = nil
	end
	if autocmd.callback then
		autocmd.command = nil
		vim.api.nvim_create_autocmd(event, autocmd)
	else
		vim.api.nvim_create_autocmd(event, autocmd)
	end
end
