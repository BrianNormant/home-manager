local lines = {
	"----------------------------------[ Open ]--------------------------------------",
	"<CR> : open the item under the cursor ",
	"o : open the item, and close quickfix window ",
	"O : use drop to open the item, and close quickfix window ",
	"t : open the item in a new tab ",
	"T : open the item in a new tab, but stay in quickfix window ",
	"<C-t> : open the item in a new tab, and close quickfix window ",
	"<C-x> : open the item in horizontal split ",
	"<C-v> : open the item in vertical split ",
	"<C-p> : go to previous file under the cursor in quickfix window ",
	"<C-n> : go to next file under the cursor in quickfix window ",
	"<C-c> : close quickfix",
	"-----------------------------------[ Sign ]-------------------------------------",
	"<C-q> : toggle sign of selected item",
	"<C-o> : toggle sign of all items",
	"<Tab> : toggle sign and move cursor down ",
	"<S-Tab> : toggle sign and move cursor up ",
	"<Tab> : toggle multiple signs in visual mode ",
	"'<Tab> : toggle signs for same buffers under the cursor ",
	"z<Tab> : clear the signs in current quickfix list ",
	"zn : create new list for signed items ",
	"zN : create new list for non-signed items ",
	"----------------------------------[ Preview ]-----------------------------------",
	"p : toggle preview for a quickfix list item ",
	"P : toggle auto-preview when cursor moves ",
	"<C-b> : scroll up half-page in preview window ",
	"<C-f> : scroll down half-page in preview window ",
	"zo : scroll back to original position in preview window ",
	"zp : toggle preview window between normal and max size ",
	"-------------------------------------[ FZF ]------------------------------------",
	"<C-o> : toggle sign of all items",
	"<S-Tab> : toggle sign and move cursor up ",
	"<Tab> : toggle sign and move cursor down ",
	"zf : enter fzf mode ",
	"<C-c> : abort fzf",
	"<CR> : Create a new list with selected items ",
}

local bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr})
vim.bo[bufnr].bufhidden = 'wipe'
vim.bo[bufnr].modifiable = false

local editor_width = vim.o.columns
local editor_height = vim.o.lines
local max_line = 80; -- the max width in the help text
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
