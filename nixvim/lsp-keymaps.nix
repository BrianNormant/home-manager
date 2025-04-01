{pkgs, ... }: {
	programs.nixvim = {
		plugins.lsp.keymaps.extra = [
			# vim.lps
			{
				key = "gD";
				action = "vim.lsp.buf.declaration";
				options.desc = "LSP: Goto declaration";
			}
			{
				key = "<leader>e";
				action = "vim.diagnostic.open_float";
				options.desc = "LSP: Open diagnostic";
			}
			{
				key = "<leader>ld";
				action = "vim.diagnostic.setqflist";
				options.desc = "LSP: Send diagnostic to QFlist";
			}
			{
				key = "<leader>ll";
				action = "vim.diagnostic.setloclist";
				options.desc = "LSP: Send diagnostic to loclist";
			}
			# Glance.nvim
			{
				key = "gd";
				action = "<Cmd>Glance definitions<cr>";
				options.desc = "LSP: Goto definitions";
			}
			{
				key = "gr";
				action = "<Cmd>Glance references<cr>";
				options.desc = "LSP: Goto references";
			}
			{
				key = "go";
				action = "<Cmd>Glance type_definitions<cr>";
				options.desc = "LSP: Goto type definitions";
			}
			{
				key = "gi";
				action = "<Cmd>Glance implementations<cr>";
				options.desc = "LSP: Goto implementations";
			}
			
			# Inc Rename
			{
				key = "gR";
				action = ''
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end
				'';
				options.desc = "LSP: Rename";
			}
			# Action Preview
			{
				key = "<Leader>la";
				action = ''
				function()
					require('actions-preview').code_actions()
				end
				'';
				options.desc = "LSP: Code actions";
				mode = [ "v" "n" ];
			}
			# Hover.nvim
			{
				key = "K";
				action = "require('hover').hover";
				options.desc = "LSP: Hover";
			}
			{
				key = "gk";
				action = "require('hover').hover_select";
				options.desc = "LSP: Hover";
			}
			{
				key = "g[";
				action = "function() require('hover').hover_switch(\"previous\") end";
				options.desc = "LSP: Hover";
			}
			{
				key = "g]";
				action = "function() require('hover').hover_switch(\"next\") end";
				options.desc = "LSP: Hover";
			}

			# Goto Preview
			{
				key = "gpd";
				action = "require('goto-preview').goto_preview_definition";
				options.desc = "LPS: Preview definition";
			}
			{
				key = "gpt";
				action = "require('goto-preview').goto_preview_type_definition";
				options.desc = "LPS: Preview type definition";
			}
			{
				key = "gpi";
				action = "require('goto-preview').goto_preview_implementation";
				options.desc = "LPS: Preview implementation";
			}
			{
				key = "gpD";
				action = "require('goto-preview').goto_preview_declaration";
				options.desc = "LPS: Preview declaration";
			}
			{
				key = "gpr";
				action = "require('goto-preview').goto_preview_references";
				options.desc = "LPS: Preview references";
			}
			{
				key = "gP";
				action = "require('goto-preview').goto_preview_close";
				options.desc = "LPS: Close preview window";
			}
		];
	};
}
