require('mini.indentscope').setup {
    draw = {
		delay = 2000,
		animation = require('mini.indentscope').gen_animation.none(),
	},
	indent_at_cursor = true,
	symbol = "",
	mappings = {
		goto_top = '',
		goto_bottom = '',
	}
}
