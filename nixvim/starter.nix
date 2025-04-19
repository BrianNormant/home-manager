{ pkgs, ...}: {
	programs.nixvim = {
		plugins.mini.modules.starter = {
			header.__raw = ''function()
				local text = "nixvim"
				local font = "starwars"

				if (vim.env.PROJECT) then text = vim.env.PROJECT end

				local figlet = vim.system(
					{'figlet', '-w', 100, '-c', '-f', font, text },
					{text=true}
				):wait()

				return figlet.stdout
			end'';
			content_hooks.__raw = ''{
				require('mini.starter').gen_hook.aligning('center', 'center'),
			}'';
			footer.__raw = ''(function()
				local txt = "<Tip>"
				vim.system(
					{"curl", "-L", "https://vtip.43z.one"},
					{text = true},
					vim.schedule_wrap(function(obj)
						if obj.code ~= 0 then return "⚠ ERROR" end
						txt = obj.stdout
						MiniStarter.refresh()
					end)
				)
				return function() return txt end
			end)()'';
			items.__raw = ''{
				-- Finders
				function()
					return vim.tbl_map(function(tbl)
						return {
							section = "Finders",
							name = tbl[1],
							action = tbl[2],
						}
					end,
					{
						{"Files",   "Telescope frecency workspace=CWD theme=dropdown"},
						{"Help",    "Telescope help_tags theme=ivy"},
						{"Keymaps", "TelescopeKeymaps"},
						{"Colors",  "Telescope colorscheme theme=ivy"},
						{"Builtins","Telescope builtin theme=ivy"},
					}
					)
				end,

				-- Git
				function()
					return vim.tbl_map(function(tbl)
						return {
							section = "Git",
							name = tbl[1],
							action = tbl[2],
						}
					end,
					{
						{"Status",   "Git"},
						{"Log",      "GitGraph"},
						{"Commit",   "Telescope git_commits theme=dropdown"},
						{"Branches", "Telescope git_branches theme=dropdown"},
						{"Stashes",  "Telescope git_stash theme=dropdown"},
					})
				end,

				-- Git actions
				function()
					return vim.tbl_map(function(tbl)
						return {
							section = "Git Actions",
							name = tbl[1],
							action = tbl[2],
						}
					end,
					{
						{"Commit",   "Git commit"},
						{"Push",     "Git push"},
						{"Pull",     "Git pull"},
						{"Stash",    "Git stash"},
					})
				end,

				-- Oil
				function()
					return vim.tbl_map(function(tbl)
						return {
							section = "Oil",
							name = tbl[1],
							action = tbl[2],
						}
					end,
					{
						{"Oil",   "Oil"},
						{"Oil Float", "Oil --float"},
					})
				end,

				-- Sessions
				require("mini.starter").sections.sessions(5, false),

				-- Other
				require("mini.starter").sections.builtin_actions(),

				-- Recent files
				require("mini.starter").sections.recent_files(5, true),
			}'';
		};
	};
}
