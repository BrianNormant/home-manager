local lint = require('lint')

local checkstyle = require('lint').linters.checkstyle
checkstyle.args = {"-c", vim.env.HOME .. "/.java/checkstyle/checkstyle.xml"}

lint.linter_by_ft = {
	java = {"checkstyle"},
}



vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		lint.try_lint()
	end
})
