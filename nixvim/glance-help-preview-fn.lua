local lines = {
	"Q         close preview window",
	"<Tab>     next location (skips groups, cycles)",
	"<S-Tab>   previous location (skips groups, cycles)",
	"<leader>l focus list window",
	"q         close this help",
}
local highlights = {
	{ "Special", 1,  0, 1 + vim.api.nvim_strwidth("q") },
	{ "Special", 2,  0, 1 + vim.api.nvim_strwidth("<Tab>") },
	{ "Special", 3,  0, 1 + vim.api.nvim_strwidth("<S-Tab>") },
	{ "Special", 4,  0, 1 + vim.api.nvim_strwidth("<leader>l") },
	{ "Special", 5,  0, 1 + vim.api.nvim_strwidth("q") },
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
	noautocmd = true,
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
