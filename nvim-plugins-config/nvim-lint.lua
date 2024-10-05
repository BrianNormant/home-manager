local lint = require('lint')

lint.linters.checkstyle = require("lint.util").wrap(
	lint.linters.checkstyle, function(diag)
		diag.severity = vim.diagnostic.severity.HINT
		return diag
	end
)

local checkstyle = require('lint').linters.checkstyle
checkstyle.args = {"-c", vim.env.HOME .. "/.java/checkstyle/checkstyle.xml"}

lint.linter_by_ft = {
	java = {"checkstyle"},
}

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.java" },
	callback = function()
		lint.try_lint("checkstyle")
	end
})
