{config, pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			leap = {
				enable = true;
				luaConfig.post = ''
require('leap.user').set_repeat_keys('<enter>', '<backspace>')
-----------------------------------[ TSNode ]-----------------------------------
vim.keymap.set({'x', 'o'}, 'R', function()
	require('leap.treesitter').select {
		opts = require('leap.user').with_traversal_keys('R', 'r');
	}
end)
-------------------------------[ Remote Action ]--------------------------------
vim.keymap.set('o', 'r', function ()
	require('leap.remote').action {}
end)
-- Automatic paste after remote yank operations:
vim.api.nvim_create_autocmd('User', {
	pattern = 'RemoteOperationDone',
	group = vim.api.nvim_create_augroup('LeapRemote', {}),
	callback = function (event)
		if vim.v.operator == 'y' and event.data.register == '"' then
			vim.cmd('normal! p')
		end
	end,
})
---------------------------------[ f-t Jumps ]----------------------------------
local function as_ft (key_specific_args)
	local common_args = {
	  inputlen = 1,
	  inclusive = true,
	  -- To limit search scope to the current line:
	  -- pattern = function (pat) return '\\%.l'..pat end,
	  opts = {
		labels = "",
			safe_labels = vim.fn.mode(1):match'[no]' and "" or nil,  -- [1]
		},
	}
	return vim.tbl_deep_extend('keep', common_args, key_specific_args)
end

local clever = require('leap.user').with_traversal_keys        -- [2]
local clever_f = clever('f', 'F')
local clever_t = clever('t', 'T')

for key, key_specific_args in pairs {
	f = { opts = clever_f, },
	F = { backward = true, opts = clever_f },
	t = { offset = -1, opts = clever_t },
	T = { backward = true, offset = 1, opts = clever_t },
} do
	vim.keymap.set({'n', 'x', 'o'}, key, function ()
		require('leap').leap(as_ft(key_specific_args))
	end)
end
'';
			};
		};
		highlightOverride = {
			LeapBackdrop = { fg = "#888888"; };
			LeapLabel    = { fg = "#FF0000"; bold = true;};
		};
		keymaps = [
			{
				key = "<leader>r";
				action = "<Plug>(leap-anywhere)";
				mode = [ "n" "x" "o" ];
				options.desc = "Leap in window";
			}
		];
	};
}
