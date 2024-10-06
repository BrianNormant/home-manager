require('no-neck-pain')

vim.g.mapleader = " "
local legend = {
	keymaps = {
		--- Basic key maps
		{"<A-p>",   "<cmd>Legendary<cr>", description="Open Legendary keybind manager" },
		{"\\",      '<cmd>split<cr>',     description="Split horizontal" },
		{"|",       '<cmd>vsplit<cr>',    description="Split vertical" },
		{"<leader>q",'<cmd>wqa!<cr>', description = "Quit neovim"},

		--- Spellcheck
		{ "z=", function() require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor()) end, description = "Telescope, suggest correct spelling"},

		--- Neotest
		--- TODO install Neotest
		{"<F7>", function() require("neotest").run.run() end, description="Run with neotest"},
		{"<F8>", function() require("neotest").run.run(vim.fn.extend("%")) end, description="Run with neotest"},

		--- git
		{"<leader>gg", "<cmd>LazyGit<cr>",      description="open lazygit"},

		--- Term
		{"<leader>tt", function() vim.cmd "!tmux popup" end, description="Open terminal in a tmux popup"},

		---              UI settings
		--- Treesitter
		{"<leader>z", function()
			if vim.opt_global.fillchars:get().eob == "~" then
				vim.opt_global.fillchars:append { eob = " " }
			else
				vim.opt_global.fillchars:append { eob = "~" }
			end
---@diagnostic disable-next-line: undefined-global
			NoNeckPain.toggle()
		end, description="center current buffer"},
		{"<leader>uh", "<cmd>TSToggle highlight<cr>", description="Toggle treesiter highlight"},
		{"<leader>uu", function()
			if vim.o.background == "dark" then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end
		end, description="change vim light/dark mode"},

		{"<A-s>", "<cmd>LegendaryScratchToggle<cr>", description = "Toggle markdown scratchpad"}
	},
	commands = {
		{":SudaWrite",       description="write a file as root"},
		{":SudaRead",        description="Open a file as root"},
		{":DiffRegFunc", function(args)
			local fargs = args.fargs
			-- by default compare the last 2 yank
			local l = "0"
			local r = "1"
			if fargs[0] then l = fargs[0] end
			if fargs[1] then r = fargs[1] end

			vim.cmd("tabnew")
			vim.cmd("vnew")
			local buffers = vim.fn.tabpagebuflist()

			vim.api.nvim_buf_set_lines(buffers[1], 0, -1, true,  vim.split(vim.fn.getreg(l), "\n" ))
			vim.api.nvim_buf_set_lines(buffers[2], 0, -1, true,  vim.split(vim.fn.getreg(r), "\n" ))

			vim.split(vim.fn.getreg("a"), "\n")

			for _,b in ipairs(buffers) do

				vim.api.nvim_set_option_value("buftype", "nofile", {
					 buf = b
				})
				vim.api.nvim_set_option_value("bufhidden", "delete", {
					 buf = b
				})
				vim.api.nvim_set_option_value("swapfile", false, {
					 buf = b
				})
			end

			local windows = vim.fn.gettabinfo()[vim.fn.tabpagenr()].windows
			for _,w in ipairs(windows) do
				vim.api.nvim_set_option_value("diff", true, {
					win = w
				})
			end
		end, description = "Diff buffer 0 and 1 in a new tab",
		unfinished = true, opts = { nargs = '*' } }
	},
}

_G.LEGEND_append(legend)
require('legendary').setup(_G.LEGEND_S)

-------------------- Suppress some default key maps
for _, mode in pairs({"n", "i", "v"}) do
	--- shift + arrow key moving around
	vim.api.nvim_set_keymap(mode, "<S-Up>",   "<Up>",   {nowait = true})
	vim.api.nvim_set_keymap(mode, "<S-Down>", "<Down>", {nowait = true})
end
vim.api.nvim_set_keymap("n", "q:", "", {nowait = true}) -- to open command buffer editing
vim.api.nvim_set_keymap("n", "?", "<cmd>noh<cr>", {nowait = true}) -- To suppress research highlight
vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", {})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = "Legendary Scratchpad",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		vim.lsp.stop_client(vim.lsp.get_clients({bufnr = buf, name = "lua_ls"})) -- stop the lua lsp
		vim.bo.filetype = "markdown"
	end,
})
