{pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.stdenv) mkDerivation;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		env = {
			VSCODE_DIFF_NO_AUTO_INSTALL = 1;
		};
		extraPackages = with pkgs; [
			git-extras
		];
		plugins = {
			gitsigns = {
				enable = true;
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
				};
				settings = {
					signs = {
						add          = { text = "┃"; show_count = true;};
						change       = { text = "┃"; show_count = true; };
						changedelete = { text = "▁"; show_count = true; };
						delete       = { text = "▔"; show_count = true; };
						topdelete    = { text = "~"; show_count = true; };
						untracked    = { text = "┆"; show_count = false; };
					};
					count_chars.__raw = ''
					{
						"₁",
						"₂",
						"₃",
						"₄",
						"₅",
						"₆",
						"₇",
						"₈",
						"₉",
						["+"] = ">"
					}
					'';
				};
				luaConfig.content = builtins.readFile ./gitsigns.lua;
			};
			fugitive = { enable = true; };
			gitgraph = {
				enable = true;
				lazyLoad.settings = {
					cmd = "GitGraph";
					keys = [
						{
							__unkeyed-1 = "<leader>fg";
							__unkeyed-2.__raw = "function() require('gitgraph').draw({}, {all = true, max_count = 100}) end";
							desc = "Open Gitgraph in current window";
						}
					];
					settings = {
						symbols = {
							merge_commit = "";
							commit = "";
							merge_commit_end = "";
							commit_end = "";

							# -- Advanced symbols
							GVER = "│";
							GHOR = "";
							GCLD = "";
							GCRU = "";
							GCRD = "╭";
							GCLU = "";
							GLRU = "";
							GLRD = "";
							GLUD = "";
							GRUD = "";
							GFORKU = "";
							GFORKD = "";
							GRUDCD = "";
							GRUDCU = "";
							GLUDCD = "";
							GLUDCU = "";
							GLRDCL = "";
							GLRDCR = "";
							GLRUCL = "";
							GLRUCR = "";
						};
						hooks = {
							on_select_commit.__raw = ''function(commit)
								vim.notify('CodeDiff ' .. commit.hash)
								vim.cmd(':CodeDiff ' .. commit.hash)
							end'';
							on_select_range_commit.__raw = ''function(from, to)
								vim.notify('CodeDiff ' .. from.hash .. '..' .. to.hash)
								vim.cmd(':CodeDiff ' .. from.hash .. '..' .. to.hash)
							end'';
						};
					};
					luaConfig.post = ''
vim.api.nvim_create_user_command('GitGraph', function()
	require('gitgraph').draw({}, {all = true, max_count = 100})
end, {})
vim.cmd(string.format("hi GitGraphHash gui=bold guifg=%s", "#FFAF00"))
vim.cmd(string.format("hi GitGraphAuthor guifg=%s", "#0DCDCD"))
vim.cmd(string.format("hi GitGraphTimestamp guifg=#565555"))
vim.cmd(string.format("hi GitGraphBranchName guifg=%s", "#E43E1E"))
vim.cmd(string.format("hi GitGraphBranchTag gui=bold guifg=%s", "#4A2574"))
vim.cmd(string.format("hi GitGraphBranchMsg guifg=%s", "#565555"))
vim.cmd("hi! link RainbowRed    GitGraphBranch1")
vim.cmd("hi! link RainbowCyan   GitGraphBranch2")
vim.cmd("hi! link RainbowBlue   GitGraphBranch3")
vim.cmd("hi! link RainbowOrange GitGraphBranch4")
vim.cmd("hi! link RainbowViolet GitGraphBranch4")
'';
				};
			};
			vscode-diff = {
				enable = true;
				lazyLoad.settings = {
					cmd = "CodeDiff";
					keys = [
						{
							__unkeyed-1 = "<leader>gm";
							__unkeyed-2 = "<CMD>CodeDiff<cr>";
							desc = "CodeDiff workspace against HEAD";
						}
					];
				};
			};
		};
		# Workaround as Fugitive* are vimscript events
		extraConfigLuaPost = ''
_G.fugitive_help = function()
	${builtins.readFile ./fugitive-help-fn.lua}
end
		'';
		keymaps = [
			{
				key = "<leader>G";
				action = "<CMD>Git<CR>";
				options.desc = "Fugitive";
			}
			{
				key = "<leader>gd";
				action = "<CMD>Gclog<CR>";
				options.desc = "Fugitive Git log to qlf";
			}
			{
				key = "<leader>gd";
				action = ":'<,'>Gclog<CR>";
				options.desc = "Fugitive Git grep to qfl";
				mode = ["v"];
			}
			{
				key = "<leader>gf";
				action = "<CMD>Ggrep -q<CR>";
				options.desc = "Fugitive Git grep to qfl";
			}
			{
				key = "<leader>gc";
				action = "<CMD>Git commit<cr>";
				options.desc = "Fugitive Commit";
			}
			{
				key = "<leader>gt";
				action.__raw = ''
					function() return ":Git tag" end
				'';
				options.desc = "Prefill cmd to tag commit";
				options.expr = true;
			}
			{
				key = "<leader>gC";
				action.__raw = ''
					function()
						local hash = vim.fn.expand("<cword>")
						return ":Git checkout " .. hash
					end
				'';
				options.desc = "Prefill cmd to checkout commit";
				options.expr = true;
			}
			{
				key = "<leader>gp";
				action = "<CMD>Git pull<cr>";
				options.desc = "Fugitive Pull";
			}
			{
				key = "<leader>gP";
				action = "<CMD>Git push<cr>";
				options.desc = "Fugitive Push";
			}
			{
				key = "<leader>gri";
				action = "<CMD>Git rebase --continue<CR>";
				options.desc = "Fugitive Rebase Continue";
			}
			{
				key = "<leader>gR";
				action = "<CMD>Git rebase --abort<CR>";
				options.desc = "Fugitive Rebase Abort";
			}
			{ # TODO: select a revision to diff current file against
				key = "<leader>gM";
				action.__raw = ''
function()
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local themes = require("telescope.themes")
	local opts = {
		attach_mappings = function()
			actions.select_default:replace(function(prompt_bufnr)
				local rev = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				-- vim.notify(vim.inspect(rev))
				local cmd = string.format("Gitsigns diffthis %s", rev["value"])
				-- vim.notify(cmd)
				vim.cmd(cmd)

			end)
			return true
		end
	}
	builtin.git_commits( themes.get_dropdown(opts) )
end
				'';
				options.desc = "Fugitive Diff against current file";
			}
			{
				key = "<leader>gg";
				# action = "<CMD>cexpr system(\"git jump --stdout diff\") | copen<CR>";
				action = "<CMD>lua require('gitsigns').setqflist(\"all\", {})<CR>";
				options.desc = "Open Quickfix with git changes";
			}
		];
	};
}
