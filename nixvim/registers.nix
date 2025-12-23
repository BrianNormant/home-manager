{pkgs, ... }:
let
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		plugins = {
			marks = {
				enable = true;
				lazyLoad.settings = { event = "DeferredUIEnter"; };
			};
			registers = {
				enable = true;
				package = pkgs.vimPlugins.registers-nvim.overrideAttrs {
					patches = [
						./plugin-patch/registers-nvim.patch
					];
				};
				lazyLoad.settings = {
					cmd = "Registers";
					keys = [
						{ __unkeyed-1 = "\""; mode = [ "n" "x" ]; }
						{ __unkeyed-1 = "<C-r>"; mode = "i"; }
					];
				};
				settings = {
					window = {
						border = "double";
						transparency = 10;
					};
				};
				luaConfig.post = ''
					vim.cmd [[
						let g:registers_delay_ms = 500

						function! DelayMap(key, command)
						  let status = wait(g:registers_delay_ms, 'getchar(1)')
						  if status < 0
							return a:command
						  else
							return a:key
						  end
						endfunction
						xnoremap <expr> " DelayMap('"', '<cmd>lua require("registers").show_window {mode="motion"}()<cr>')
						inoremap <expr> <C-R> DelayMap('<C-R>', '<cmd>lua require("registers").show_window {mode="insert"}()<cr>')
						nnoremap <expr> " DelayMap('"', '<cmd>lua require("registers").show_window {mode="motion"}()<cr>')
					]]
					'';
			};
		};
		keymaps = [
			{
				key = "m.";
				action = "<Cmd>Telescope marks theme=cursor<CR>";
			}
		];
	};
}
