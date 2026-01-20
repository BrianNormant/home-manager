{pkgs, ...}:
{
	programs.nixvim = {
		plugins = {
			iron = {
				enable = true;
				settings = {
					config = {
						scratch_repl = true;
						repl_definition = {
							sh = { command = "zsh"; };
							zsh = { command = "zsh"; };
							lua = { command = "lua"; };
							idris2 = { command = "pack repl"; };
						};
						repl_filetype.__raw = "function(_, ft) return ft end";
						repl_open_cmd = "bot split";
					};
					keymaps = {
						# TODO : find other kemap, <leader>r is used by leap
						# toggle_repl = "<leader>rr";
						# restart_repl = "<leader>rR";
						# send_motion = "<leader>rs";
						# visual_send = "<leader>rs";
						# send_file = "<leader>rf";
						# send_line = "<leader>rl";
						# send_paragraph = "<leader>rp";
						# send_until_cursor = "<leader>ru";
						# send_code_block = "<leader>rb";
					};
				};
			};
		};
	};
}
