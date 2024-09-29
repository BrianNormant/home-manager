vim.g.mapleader = " "
require 'legendary'.setup {
	keymaps = {
		--- Basic keymaps
		{"<A-p>", "<cmd>Legendary<cr>",    description="Open Legendary keybind manager" },
		{"<C-q>", "<cmd>wqa<cr>",          description="Write, save, then exit" },
		{"\\",    '<cmd>split<cr><C-w>j',  description="Split horizontal" },
		{"|",     '<cmd>vsplit<cr><C-w>l', description="Split vertical" },

		--- Boo.nvim

		{"gi", function() require('boo').boo() end, description="open LSP info"},
		{"<C-s>", "<cmd>ISwap<cr>",           description="Write and save" },

		-- goto-preview
		{"gpd",  function()  require('goto-preview').goto_preview_definition()       end, description="LSP view definition"},
		{"gpt",  function()  require('goto-preview').goto_preview_type_definition()  end, description="LSP view type definition"  },
		{"gpi",  function()  require('goto-preview').goto_preview_implementation()   end, description="LSP view implementation"  },
		{"gpD",  function()  require('goto-preview').goto_preview_declaration()      end, description="LSP view declaration"  },
		{"gpr",  function()  require('goto-preview').goto_preview_references()       end, description="LSP view references"  },
		{"gP",   function()  require('goto-preview').close_all_win()                 end, description="LSP close preview window"  },

		--- default neovim LSP
		{"<leader>e", vim.diagnostic.open_float},

		--- Oil
		{"<leader>oo", '<cmd>Oil<cr>',          description = "Open Oil in current window" },
		{"<leader>oO", '<cmd>Oil -- float<cr>', description = "Open Oil in floating window" },

		--- Telescope
		{"<leader>ft", function() require('telescope.builtin').builtin() end, description="Telescope list builtins"},
		{"<leader>ff", '<cmd>Telescope find_files<cr>',                       description="Telescope list files"},
		{"<leader>fF", '<cmd>Telescope live_grep<cr>',                        description="Telescope live grep"},
		{"<leader>fb", '<cmd>Telescope buffers<cr>',                          description="Telescope list buffers"},
		{"<leader>f/", '<cmd>Telescope current_buffer_fuzzy_find<cr>',        description="Telescope live grep in file"},
		{"<M-h>", '<cmd>Telescope help_tags<cr>',                             description="Telescope neovim help"},

		--- Telescope & LSP
		{"<leader>fd", '<cmd>Telescope lsp_definitions<cr>',        descroption="Telescope list LSP definitions"},
		{"<leader>fr", '<cmd>Telescope lsp_references<cr>',         description="Telescope list LSP references"},
		{"<leader>fi", '<cmd>Telescope lsp_implementations<cr>',    description="Telescope list LSP implementations"},
		{"<leader>fp", require('diaglist').open_buffer_diagnostics, description="Open buffer diagnositics in loclist"},
		{"<leader>fD", require('diaglist').open_all_diagnostics,    description="Open workspace diagnositics in quickfix"},

		-- TODO find a good way to show the list of diagnositics
		{"<leader>L",  function() require("nvim-navbuddy").open() end, description="Open Navbuddy"},
		{"<leader>la", function()
			if vim.bo.filetype == "java" then
				vim.lsp.buf.code_action()
			else
				require'actions-preview'.code_actions()
			end
		end, description="LSP view avalaible code actions"},



		--- Muren
		{"<F3>", "<cmd>MurenFresh<cr>",  mode = "n", description="Open Muren"},
		{"<F3>", ":'<,'>MurenFresh<cr>", mode = "v", description="Open Muren with range"},

		--- Compiler
		{"<F5>", "<cmd>CompilerOpen<cr>"},
		{"<F6>", "<cmd>CompilerToggleResults<cr>"},

		--- Neotest
		{"<F7>", function() require("neotest").run.run() end, description="Run with neotest"},
		{"<F8>", function() require("neotest").run.run(vim.fn.extend("%")) end, description="Run with neotest"},

		--- DAP
		{"<F9>",   function()  require'dap'.toggle_breakpoint()  end,  description="DAP  Toggle breakpoint"},
		{"<F10>",  function()  require'dap'.continue()           end,  description="DAP  Start/Resume"},
		{"<F58>",  function()  require'dap'.terminate()          end,  description="DAP  Stop"},
		{"<F11>",  function()  require'dap'.step_over()          end,  description="DAP  Step"},
		{"<F12>",  function()  require'dap'.step_into()          end,  description="DAP  Step into"},
		{"<F60>",  function()  require'dap'.step_out()           end,  description="DAP  Step out"},

		--- Icon Picker
		{"<C-e>", "<cmd>IconPickerInsert<cr>", mode="i", description="Icon Picker insert"},
		{"<C-e>", "<cmd>IconPickerNormal<cr>", mode="n", description="Icon Picker normal"},

		--- git
		{"<leader>gg", "<cmd>LazyGit<cr>",      description="open lazygit"},
		{"<leader>gG", "<cmd>DiffviewOpen<cr>", description="use diffview to open file"},

		--- Term
		{"<leader>tt", function() vim.cmd "tab term" end, description="Open terminal in a new tab"},

		{"<F1>",  "<cmd>Gen<cr>",  mode="n", description="Open Generative AI"},
		{"<F1>",  ":'<,'>Gen<cr>", mode="v", description="Open Generative AI with range"},

		{"<F2>", function() require('dropbar.api').pick() end, description="Open dropbar"},

		---              UI settings
		--- Treesitter
		{"<leader>uh", "<cmd>TSToggle highlight<cr>", description="Toggle treesiter highlight"},

		--- True Zen
		{"<leader>zn",  "<cmd>TZNarrow<CR>",       mode  =  "n", description = "TrueZen focus a section of text"},
		{"<leader>zn",  ":'<,'>TZNarrow<CR>",      mode  =  "v", description = "TrueZen focus a section of text"},
		{"<leader>zf",  "<cmd>TZFocus<CR>",        mode  =  "n", description = "TrueZen focus the current buffer"},
		{"<leader>zm",  "<cmd>TZMinimalist<CR>",   mode  =  "n", description = "TrueZen remove all visual cluter"},
		{"<leader>za",  "<cmd>TZAtaraxis<CR>",     mode  =  "n", description = "TrueZen center the curent buffer"},

		--- Git Blame
		{"<leader>ub", require('gitsigns').toggle_current_line_blame, description = "Show git blame"},

		--- Switch between light/dark mode
		{"<leader>uu", function()
			if vim.o.background == "dark" then
				vim.o.background = "light"
			else
				vim.o.background = "dark"
			end
		end, description="change vim light/dark mode"},

		--- mini-ai
		{"a?, i?", description = "Around/Inside user selected 2 character" },
		{"af, if", description = "Around/Inside function call" },
		{"aa, ia", description = "Around/Inside function argument call" },

		--- mini-indentscope
		{ "[i", description = "goto indentscope top" },
		{ "]i", description = "goto indentscope bottom" },

		--- mini-operators
		{ "g=", description = "mini-operators evaluate" },
		{ "<A-x>", description = "mini-operators exchange" },
		{ "gm", description = "mini-operators multiply" },
		{ "gr", description = "mini-operators replace with register" },
		{ "<A-s>", description = "mini-operators sort text" },

		--- mini-surround
		{ "sa", description = "mini-surround add around {textobject} {surround}" },
		{ "sd", description = "mini-surround delete {surround}" },
		{ "sr", description = "mini-surround add around {surround} {surround}" },
		{ "sf", description = "mini-surround find surroundings" },
		{ "sF", description = "mini-surround find surroundings reverse" },
		{ "sh", description = "mini-surround highlight surrounding" },

		--- mini-bracketed
		{ "[B", description = "Target: Buffer " },
		{ "[b", description = "Target: Buffer " },
		{ "]b", description = "Target: Buffer " },
		{ "]B", description = "Target: Buffer " },
		{ "[C", description = "Target: Comment block " },
		{ "[c", description = "Target: Comment block " },
		{ "]c", description = "Target: Comment block " },
		{ "]C", description = "Target: Comment block " },
		{ "[X", description = "Target: Conflict marker " },
		{ "[x", description = "Target: Conflict marker " },
		{ "]x", description = "Target: Conflict marker " },
		{ "]X", description = "Target: Conflict marker " },
		{ "[D", description = "Target: Diagnostic " },
		{ "[d", description = "Target: Diagnostic " },
		{ "]d", description = "Target: Diagnostic " },
		{ "]D", description = "Target: Diagnostic " },
		{ "[F", description = "Target: File on disk " },
		{ "[f", description = "Target: File on disk " },
		{ "]f", description = "Target: File on disk " },
		{ "]F", description = "Target: File on disk " },
		{ "[I", description = "Target: Indent change " },
		{ "[i", description = "Target: Indent change " },
		{ "]i", description = "Target: Indent change " },
		{ "]I", description = "Target: Indent change " },
		{ "[J", description = "Target: Jump from jumplist inside current buffer " },
		{ "[j", description = "Target: Jump from jumplist inside current buffer " },
		{ "]j", description = "Target: Jump from jumplist inside current buffer " },
		{ "]J", description = "Target: Jump from jumplist inside current buffer " },
		{ "[L", description = "Target: Location from location list " },
		{ "[l", description = "Target: Location from location list " },
		{ "]l", description = "Target: Location from location list " },
		{ "]L", description = "Target: Location from location list " },
		{ "[O", description = "Target: Old files " },
		{ "[o", description = "Target: Old files " },
		{ "]o", description = "Target: Old files " },
		{ "]O", description = "Target: Old files " },
		{ "[Q", description = "Target: Quickfix entry from quickfix list " },
		{ "[q", description = "Target: Quickfix entry from quickfix list " },
		{ "]q", description = "Target: Quickfix entry from quickfix list " },
		{ "]Q", description = "Target: Quickfix entry from quickfix list " },
		{ "[T", description = "Target: Tree-sitter node and parents " },
		{ "[t", description = "Target: Tree-sitter node and parents " },
		{ "]t", description = "Target: Tree-sitter node and parents " },
		{ "]T", description = "Target: Tree-sitter node and parents " },
		{ "[U", description = "Target: Undo states from specially tracked linear history " },
		{ "[u", description = "Target: Undo states from specially tracked linear history " },
		{ "]u", description = "Target: Undo states from specially tracked linear history " },
		{ "]U", description = "Target: Undo states from specially tracked linear history " },
		{ "[W", description = "Target: Window in current tab " },
		{ "[w", description = "Target: Window in current tab " },
		{ "]w", description = "Target: Window in current tab " },
		{ "]W", description = "Target: Window in current tab " },
		{ "[Y", description = "Target: Yank selection replacing latest put region " },
		{ "[y", description = "Target: Yank selection replacing latest put region " },
		{ "]y", description = "Target: Yank selection replacing latest put region " },
		{ "]Y", description = "Target: Yank selection replacing latest put region " },

		--- mini-align
		{ "ga", mode = {'n', 'v'}, description = "Start mini-align" },
		{ "gA", mode = {'n', 'v'}, description = "Start mini-align with preview" },

		--- mini-move
		{ "<M-h>", mode = 'v', description = "left" },
		{ "<M-l>", mode = 'v', description = "right" },
		{ "<M-j>", mode = 'v', description = "down" },
		{ "<M-k>", mode = 'v', description = "up" },
		{ "<M-h>", mode = 'n', description = "line_left" },
		{ "<M-l>", mode = 'n', description = "line_right" },
		{ "<M-j>", mode = 'n', description = "line_down" },
		{ "<M-k>", mode = 'n', description = "line_up" },

		--- leap.nvim
		{ 'x',  '<Plug>(leap-forward)',     mode = {'n', 'x', 'o'}, description="Leap search forward" },
		{ 'X',  '<Plug>(leap-backward)',    mode = {'n', 'x', 'o'}, description="Leap search backward" },
		{ 'gs', '<Plug>(leap-from-window)', mode = {'n', 'x', 'o'}, description="Leap search in other windows" },

		--- Tabby
		{"<leader>ta",  ":$tabnew<CR>",               description = "Open new tab"},
		{"<M-t>",       "<cmd>Tabby jump_to_tab<CR>", description = "Use tabby leap feature to jump to a tab via 1 character"},
		{"<leader>tq",  "<cmd>tabclose<CR>",          description = "Close current tab"},
		{"<leader>tQ",  "<cmd>tabonly<CR>",           description = "Close all other tab"},
		-- move current tab to previous position
		{"<leader>tmp", ":-tabmove<CR>",              description = "Move current tab left <-- "},
		-- move current tab to next position
		{"<leader>tmn", ":+tabmove<CR>",              description = "move current tab right -->"},

		--- LuaSnip
		{"<C-L>", mode = { "i", "s" }, function() require('luasnip').jump(1) end,  description="Complete tag with luasnip"},
		{"<C-J>", mode = { "i", "s" }, function() require('luasnip').jump(-1) end, description="Complete tag with luasnip reverse"},
		{"<C-K>", mode = { "i", "s" }, function()
			local ls = require('luasnip')
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, description="Choose tag with with luasnip reverse"},

		-- Marks
		{"mx",        description="Set mark x"},
		{"m,",        description="Set the next available alphabetical (lowercase) mark"},
		{"m;",        description="Toggle the next available mark at the current line"},
		{"dmx",       description="Delete mark x"},
		{"dm-",       description="Delete all marks on the current line"},
		{"dm<space>", description="Delete all marks in the current buffer"},
		{"m]",        description="Move to next mark"},
		{"m[",        description="Move to previous mark"},
		{"m:",        description="Preview mark. This will prompt you for a specific mark to preview; press <cr> to preview the next mark."},
		{"m[0-9]",    description="Add a bookmark from bookmark group[0-9]."},
		{"dm[0-9]",   description="Delete all bookmarks from bookmark group[0-9]."},
		{"m}",        description="Move to the next bookmark having the same type as the bookmark under the cursor. Works across buffers."},
		{"m{",        description="Move to the previous bookmark having the same type as the bookmark under the cursor. Works across buffers."},
		{"dm=",       description="Delete the bookmark under the cursor."},

		-- Telescope internal mappings.
		{"<CR>",             description = "Telescope mapping: Confirm selection"},
		{"<C-x>",            description = "Telescope mapping: Go to file selection as a split"},
		{"<C-v>",            description = "Telescope mapping: Go to file selection as a vsplit"},
		{"<C-t>",            description = "Telescope mapping: Go to a file in a new tab"},
		{"<C-u>",            description = "Telescope mapping: Scroll up in preview window"},
		{"<C-d>",            description = "Telescope mapping: Scroll down in preview window"},
		{"<C-f>",            description = "Telescope mapping: Scroll left in preview window"},
		{"<C-k>",            description = "Telescope mapping: Scroll right in preview window"},
		{"<M-f>",            description = "Telescope mapping: Scroll left in results window"},
		{"<M-k>",            description = "Telescope mapping: Scroll right in results window"},
		{"<C-/>",            description = "Telescope mapping: Show mappings for picker actions (insert mode)"},
		{"?",                description = "Telescope mapping: Show mappings for picker actions (normal mode)"},
		{"<C-c>",            description = "Telescope mapping: Close telescope (insert mode)"},
		{"<Esc>",            description = "Telescope mapping: Close telescope (in normal mode)"},
		{"<Tab>",            description = "Telescope mapping: Toggle selection and move to next selection"},
		{"<S-Tab>",          description = "Telescope mapping: Toggle selection and move to prev selection"},
		{"<C-q>",            description = "Telescope mapping: Send all items not filtered to quickfixlist (qflist)"},
		{"<M-q>",            description = "Telescope mapping: Send all selected items to qflist"},
		{"<C-r><C-w>",       description = "Telescope mapping: Insert cword in original window into prompt (insert mode)"},
		{"<C-r><C-a>",       description = "Telescope mapping: Insert cWORD in original window into prompt (insert mode)"},
		{"<C-r><C-f>",       description = "Telescope mapping: Insert cfile in original window into prompt (insert mode)"},
		{"<C-r><C-l>",       description = "Telescope mapping: Insert cline in original window into prompt (insert mode)"},
	},
	commands = {
		{":SudaWrite",       description="write a file as root"},
		{":SudaRead",        description="Open a file as root"},
		{":IdrisEvaluate",   require('idris2.repl').evalutate,           description="Use Idris2 lsp to evalutate a expression sourcing the file"},
		{":IdrisCasesplit",  require('idris2.code_action').case_split,   description="Idris2 lsp Case split"},
		{":IdrisExprSearch", require('idris2.code_action').expr_search,  description="Idris2 lsp expression search"},
		{":IdrisGenDef",     require('idris2.code_action').generate_def, description="Idris2 lsp Try to generate a definition"},
	},
}
