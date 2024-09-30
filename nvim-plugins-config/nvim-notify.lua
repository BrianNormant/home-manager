local notify = require 'notify'

notify.setup {
	stages = "static",
	fps = 5,
}

vim.notify = notify
