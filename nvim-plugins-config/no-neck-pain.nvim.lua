require('lze').load {
	'no-neck-pain.nvim',
	cmd = "NoNeckPain",
	keys = { {"<Space>z", "<cmd>NoNeckPain<cr>"}, },
	after = function()
		require('no-neck-pain').setup {
			buffers = {
				scratchPad = {
					enabled = true,
					location = nil, -- save in current working directory
				},
				bo = {
					filetype = "md",
				},
			},
		}
	end
}
