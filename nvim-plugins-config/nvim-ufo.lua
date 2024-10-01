
vim.o.foldcolumn = '0' -- 0 to disable, 1 to enable
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

local legend = {
    keymaps = {
        {'zR', require('ufo').openAllFolds, description = "UFO open all folds"},
        {'zM', require('ufo').closeAllFolds, description = "UFO close all folds"},
    }
}
_G.LEGEND_append(legend)
