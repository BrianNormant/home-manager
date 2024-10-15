-- vim.loader.enable()

_G.legendary = {
	config = {
		keymaps = {},
		commands = {},
	},
}

_G.legendary.append = function(opts)
	if opts.keymaps then
		local keymaps = _G.legendary.config.keymaps
		for _, v in ipairs(opts.keymaps) do
			keymaps[#keymaps+1] = v
		end
	end

	if opts.commands then
		local commands = _G.legendary.config.commands
		for _, v in ipairs(opts.commands) do
			commands[#commands+1] = v
		end
	end
end

_G.wk = {
	config = {},
}

_G.wk.append = function(opts)
	for _, v in ipairs(opts) do
		_G.wk.config[#_G.wk.config+1] = v
	end
end
