{pkgs, lib, ...}:
lib.nixvim.plugins.mkNeovimPlugin {
	name = "attempt";
	package = "attempt-nvim";
	maintainers = [];
	description = "Manage your temporary buffers";
	settingsExample = {
		dir = ''
(unix and '/tmp/' or vim.fn.expand '$TEMP\\') .. 'attempt.nvim' .. path_separator
		'';
		autosave = "false";
		list_buffers = "false";
		initial_content = ''{
py = initial_content_fn, -- Either string or function that returns the initial content
c = initial_content_fn,
cpp = initial_content_fn,
java = initial_content_fn,
rs = initial_content_fn,
go = initial_content_fn,
sh = initial_content_fn
}'';
		ext_options = "{ 'lua', 'js', 'py', 'cpp', 'c', '' }";
		format_opts = "{ [''] = '[None]' } -- How they'll look";
		run = ''{
py = { 'w !python' },      -- Either table of strings or lua functions
js = { 'w !node' },
ts = { 'w !deno run -' },
lua = { 'w' , 'luafile %' },
sh = { 'w !bash' },
pl = { 'w !perl' },
cpp = { 'w' , '!'.. cpp_compiler ..' %:p -o %:p:r.out && echo "" && %:p:r.out && rm %:p:r.out '},
c = { 'w' , '!'.. c_compiler ..' %:p -o %:p:r.out && echo "" && %:p:r.out && rm %:p:r.out'},
}'';
	};
}
