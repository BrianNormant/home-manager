local lines = {
	"--------------- Navigation --------------",
	"<CR> : Open file",
	"o : Open file in split",
	"gO : Open file in vertical split",
	"<count>~ : Open <count> ancestor",
	"C : Open file commit",
	"]c [c : Jump to next/previous hunk",
	"---------------- Staging ----------------",
	"s : Stage file",
	"u : Unstage file",
	"- : Toggle stage/unstage file",
	"U : Unstage all files",
	"X : Discard file",
	"= : Toggle inline file diff",
	"> : Enable inline file diff",
	"< : Disable inline file diff",
	"1gI : add to .gitignore",
	"----------------- Diff ------------------",
	"dp : diff file",
	"dd : split diff file",
	"dv : vertical split diff file",
	"dq : close all diff buffers",
	"---------------- Commit -----------------",
	"cc : new commit",
	"coo : checkout commit",
	"cw : reword last commit",
	"ca : amend last commit",
	"ce : amend last commit no msg edit",
	"cf / cF : fixup last commit (immediate rebase)",
	"cs / cS : squash last commit (immediate rebase)",
	"cn : squash last commit (edit msg)",
	"crc : Revert commit",
	"crn : Revert commit (no commit)",
	"----------------- Stash -----------------",
	"czz : push stash",
	"czA : apply top most stash",
	"czP : Pop top stash",
}

local bufnr = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

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
