{pkgs, ... }: {
	programs.nixvim = {
		plugins.lsp.keymaps.extra = [
			# vim.lsp
			{
				key = "<C-]>";
				action.__raw = "vim.lsp.buf.definition";
				options.desc = "LSP: Goto definition";
			}
			{
				key = "gD";
				action.__raw = "vim.lsp.buf.declaration";
				options.desc = "LSP: Goto declaration";
			}
			{
				key = "<leader>e";
				action.__raw = "vim.diagnostic.open_float";
				options.desc = "LSP: Open diagnostic";
			}
			{
				key = "<leader>ld";
				action.__raw = "vim.diagnostic.setqflist";
				options.desc = "LSP: Send diagnostic to QFlist";
			}
			{
				key = "<leader>ll";
				action.__raw = "vim.diagnostic.setloclist";
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
				key = "<A-r>";
				action.__raw = ''
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end
				'';
				options.desc = "LSP: Rename";
				options.expr = true;
			}
			# Action.__raw Preview
			{
				key = "<Leader>la";
				action.__raw = ''
				function()
					require('actions-preview').code_actions()
				end
				'';
				options.desc = "LSP: Code action";
				mode = [ "v" "n" ];
			}
			# Hover.nvim
			{
				key = "K";
				action.__raw = "require('hover').hover";
				options.desc = "LSP: Hover";
			}
			{
				key = "gk";
				action.__raw = "require('hover').hover_select";
				options.desc = "LSP: Hover";
			}
			{
				key = "g[";
				action.__raw = "function() require('hover').hover_switch(\"previous\") end";
				options.desc = "LSP: Hover";
			}
			{
				key = "g]";
				action.__raw = "function() require('hover').hover_switch(\"next\") end";
				options.desc = "LSP: Hover";
			}

			# Goto Preview
			{
				key = "gpd";
				action.__raw = "require('goto-preview').goto_preview_definition";
				options.desc = "LPS: Preview definition";
			}
			{
				key = "gpt";
				action.__raw = "require('goto-preview').goto_preview_type_definition";
				options.desc = "LPS: Preview type definition";
			}
			{
				key = "gpi";
				action.__raw = "require('goto-preview').goto_preview_implementation";
				options.desc = "LPS: Preview implementation";
			}
			{
				key = "gpD";
				action.__raw = "require('goto-preview').goto_preview_declaration";
				options.desc = "LPS: Preview declaration";
			}
			{
				key = "gpr";
				action.__raw = "require('goto-preview').goto_preview_references";
				options.desc = "LPS: Preview references";
			}
			{
				key = "gP";
				action.__raw = "require('goto-preview').close_all_win";
				options.desc = "LPS: Close preview window";
			}
		];
	};
}
