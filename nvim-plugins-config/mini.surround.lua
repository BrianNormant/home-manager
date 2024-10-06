require('mini.surround').setup { }

vim.keymap.set("n", "sA", "sa$", { desc = "Surround to EOF", remap = true })
