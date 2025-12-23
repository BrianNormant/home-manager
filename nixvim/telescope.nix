{pkgs, ... }:
{
	programs.nixvim = {
		extraPackages = with pkgs; [
			fd
			ripgrep
		];
		plugins.telescope = {
			enable = true;
			settings = {
				defaults = {
					winblend = 50;
					dynamic_preview_title = true;
				};
			};
			extensions = {
				frecency = {
					enable = true;
					settings = {
						db_safe_mode = false;
						# default_workspace = "CWD";
						# path_display = [ "tail" ];
						show_scores = true;
						enable_prompt_mappings = true;
						show_unindexed = true;
						show_filter_column = false;
					};
				};
				fzf-native = {
					enable = true;
					settings = {
						case_mode = "ignore_case";
						fuzzy = true;
						override_generic_sorter = true;
						override_file_sorter = true;
					};
				};
				live-grep-args = {
					enable = true;
					settings = {
						auto_quoting = true;
						mappings = {
							i = {
								"<C-j>".__raw = "require(\"telescope-live-grep-args.actions\").quote_prompt()";
								"<C-k>".__raw = "require(\"telescope-live-grep-args.actions\").quote_prompt({ postfix = \" -t\" })";
								"<c-space>".__raw = "require(\"telescope-live-grep-args.actions\").to_fuzzy_refine";
							};
						};
					};
				};
				ui-select = {
					enable = true;
					settings.__raw =''
						require('telescope.themes').get_ivy {}
					'';
				};
				undo = {
					enable = true;
					settings = {
						mappings = {
							i = {
								"<c-cr>" = "require('telescope-undo.actions').restore";
								"<cr>" = "require('telescope-undo.actions').yank_additions";
								"<s-cr>" = "require('telescope-undo.actions').yank_deletions";
							};
							n = {
								Y = "require('telescope-undo.actions').yank_deletions";
								u = "require('telescope-undo.actions').restore";
								y = "require('telescope-undo.actions').yank_additions";
							};
						};
						vim_diff_opts = {
							ctxlen = 2;
						};
					};
				};
			};
			lazyLoad.settings = {
				event = "DeferredUIEnter";
			};
			luaConfig.post = ''
--- Function that replace telespope native keymap function
--- Because telescope keymap break when the plugins are combined
_G.telescope_keymaps = function (m)
	local format = "%-3s %-7s %s %s"
	local modes = m or {'n', 'i', 'v'}
	local strs = {}

	for _, mode in ipairs(modes) do
		local kys = vim.api.nvim_get_keymap(mode)
		local cur = vim.tbl_map(function(keymap)
			local lhs = keymap.lhs
			local rhs = keymap.rhs or keymap.callback
			local desc = keymap.desc or ""
			return string.format(format, mode, lhs, vim.inspect(rhs), desc)
		end, kys)

		for _, line in ipairs(cur) do table.insert(strs, line) end

		kys = vim.api.nvim_buf_get_keymap(0, mode)
		cur = vim.tbl_map(function(keymap)
			local lhs = keymap.lhs
			local rhs = keymap.rhs or keymap.callback
			local desc = keymap.desc or ""
			return string.format(format .. " <Buffer>", mode, lhs, vim.inspect(rhs), desc)
		end, kys)

		for _, line in ipairs(cur) do table.insert(strs, line) end
	end

	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values

	local picker = function (opts)
		opts = opts or {}
		pickers.new(opts, {
			prompt_title = "Keymaps",
			finder = finders.new_table {
				results = strs,
			},
			sorter = conf.generic_sorter(opts),
		}):find()
	end

	picker(require("telescope.themes").get_ivy {})
end
			'';
		};
		keymaps = [
			# Frecency
			{
				key = "<leader>ff";
				action = "<Cmd>Telescope frecency workspace=CWD theme=dropdown<CR>";
				options.desc = "Telescope: Find Files Frecency";
			}
			{
				key = "<leader>fu";
				action = "<Cmd>Telescope undo<CR>";
				options.desc = "Telescope: Undo";
			}
			{
				key = "<leader>F";
				action = "<Cmd>Telescope find_files theme=dropdown<CR>";
				options.desc = "Telescope: Find Files";
			}
			{
				key = "<leader>fF";
				action = "<CMD>Telescope live_grep_args theme=dropdown<cr>";
				options.desc = "Telescope: Live Grep";
			}
			{
				key = "<leader>ft";
				action = "<CMD>Telescope builtin theme=dropdown<CR>";
				options.desc = "Telescope: Builtins";
			}
			{
				key = "<leader>fb";
				action = "<CMD>Telescope buffers theme=dropdown<CR>";
				options.desc = "Telescope: Buffers";
			}
			{
				key = "<leader>f/";
				action = "<CMD>Telescope current_buffer_fuzzy_find theme=ivy<CR>";
				options.desc = "Telescope: Live Grep Buffer";
			}
			{
				key = "<leader>fh";
				action = "<CMD>Telescope help_tags theme=ivy<CR>";
				options.desc = "Telescope: Search Help";
			}
			{
				key = "<leader>fk";
				action = "<CMD>lua _G.telescope_keymaps()<CR>";
				options.desc = "Telescope: Search Keymaps";
			}
			{
				key = "<leader>fm";
				action = "<CMD>Telescope man_pages theme=ivy<CR>";
				options.desc = "Telescope: Search Man Pages";
			}
			{
				key = "<leader>fi";
				action = "<CMD>Telescope lsp_incoming_calls theme=ivy<CR>";
				options.desc = "Telescope: LSP Incoming Calls";
			}
			{
				key = "<leader>fo";
				action = "<CMD>Telescope lsp_outgoing_calls theme=ivy<CR>";
				options.desc = "Telescope: LSP Outgoing Calls";
			}
		];
		userCommands = {
			TelescopeKeymaps = {
				bar = true;
				command.__raw = ''
				function(opts)
					if #opts.fargs == 0 then
						_G.telescope_keymaps()
					else
						_G.telescope_keymaps(opts.fargs)
					end
				end
				'';
				nargs = "*";
				desc = "List all the keymaps for given modes";
			};
		};
	};
}
