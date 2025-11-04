{pkgs, ...}:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.lib) fakeHash;
	inherit (pkgs) vimPlugins;
in {
	programs.nixvim = {
		extraPackages = with pkgs; [
			git-extras
		];
		plugins = {
			gitsigns = {
				enable = true;
				lazyLoad.settings = {
					event = [ "DeferredUIEnter" ];
				};
				luaConfig.content = builtins.readFile ./gitsigns.lua;
			};
		};
		# Workaround as Fugitive* are vimscript events
		extraPlugins = with vimPlugins; [
			{
				plugin = vim-fugitive;
				optional = true;
			}
			{
				plugin = buildVimPlugin rec {
					pname = "gitgraph.nvim";
					version = "01e466b";
					src = fetchFromGitHub {
						owner = "isakbm";
						repo = "gitgraph.nvim";
						rev = version;
						hash = "sha256-d55IRrOhK5tSLo2boSuMhDbkerqij5AHgNDkwtGadyI=";
					};
					patches = [ ./plugin-patch/gitgraph.patch ];
				};
				optional = true;
			}
			{
				plugin = diffview-nvim;
				optional = true;
			}
		];
		extraConfigLuaPost = ''
			_G.fugitive_help = function()
				${builtins.readFile ./fugitive-help-fn.lua}
			end
			require('lz.n').load {
				{
					'vim-fugitive',
					event = "DeferredUIEnter",
					after = function() end,
				},
				{
					'diffview.nvim',
					event = "DeferredUIEnter",
					after = function()
						require('diffview').setup {
							enhanced_diff_hl = true,
							view = {
								merge_tool = {
									layout = "diff4_mixed",
								},
							},
							file_panel = {
								listing_style = "list",
							},
						}
					end
				},
				{
					'gitgraph.nvim',
					keys = {
						{
							"<leader>fg",
							function()
								require('gitgraph').draw({}, {all = true, max_count = 100})
							end,
							desc = "Open Gitgraph in current window"
						},
					},
					cmd = "GitGraph",
					after = function()
						require('gitgraph').setup {
							symbols = {
								merge_commit = '',
								commit = '',
								merge_commit_end = '',
								commit_end = '',

								-- Advanced symbols
								GVER = '│',
								GHOR = '',
								GCLD = '',
								GCRU = '',
								GCRD = '╭',
								GCLU = '',
								GLRU = '',
								GLRD = '',
								GLUD = '',
								GRUD = '',
								GFORKU = '',
								GFORKD = '',
								GRUDCD = '',
								GRUDCU = '',
								GLUDCD = '',
								GLUDCU = '',
								GLRDCL = '',
								GLRDCR = '',
								GLRUCL = '',
								GLRUCR = '',
							},
							hooks = {
								-- TODO: Run a fugitive/diffview command with those actions
								on_select_commit = function(commit)
									vim.notify('DiffviewOpen ' .. commit.hash)
									vim.cmd(':DiffviewOpen ' .. commit.hash)
								end,
								on_select_range_commit = function(from, to)
									vim.notify('DiffviewOpen ' .. from.hash .. '..' .. to.hash)
									vim.cmd(':DiffviewOpen ' .. from.hash .. '..' .. to.hash)
								end,
							},
						}

						-- create user command
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
						-- TODO: Make fugitive autocmd run in graphview buffers
					end
				}
			}
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
			{
				key = "<leader>gm";
				action = "<CMD>DiffviewOpen<cr>";
				options.desc = "Diffview Mergetool resolve conflicts";
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
				action = "<CMD>Gitsign setqflist target=all<cr>";
				options.desc = "Open Quickfix with git changes";
			}
		];
	};
}
