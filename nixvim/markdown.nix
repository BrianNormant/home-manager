{config, pkgs, ...}: let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
	inherit (pkgs.lib) fakeHash;
in {
	programs.nixvim = {
		plugins.markview = {
			enable = true;
			lazyLoad.settings = {
				enable = false;
				ft = [ "markdown" "tex" "typst" "yaml" "html" ];
			};
			settings.preview = {
				modes = [ "n" "no" "c" ];
				hybrid_modes = [ "o" "i" ];
				callbacks.on_enable.__raw = ''
					function(_, win)
vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "c"
					end
				'';
			};
		};
		extraPackages = with pkgs; [
			pandoc
		];
		autoCmd = [
			{
				event = ["BufWrite" "BufRead"];
				pattern = [ "*.md" ];
				callback.__raw = ''function()
					local inputfile = vim.fn.expand("%:p")
					vim.system({
						-- TODO, use pandoc extensions with plant-uml, mermaid, ect to genenerate
						-- Diagrams and such
						"pandoc",
						"--from",
						"markdown",
						"--to",
						"html",
						inputfile,
						"--output",
						"/var/lib/nvimpreview/preview.html",
						"-H", "/home/brian/.local/share/autoreload.html",
						"-H", "/home/brian/.local/share/githubstyle.css",
						"--standalone",
						"--katex", -- render inline latex
					},{}, function()
							if not _G.firefox_open then
								_G.firefox_open = true
								vim.defer_fn(function()
									vim.system {"firefox", "localhost/preview.html"}
									-- We create a callback to clear firefox_open when we close this buffer
									vim.cmd "auto BufWinLeave <buffer> lua _G.firefox_open = false"
								end, 10)
							end
						end)
				end'';
			}
		];
	};
	home.file = {
		".local/share/autoreload.html".text =
			''<script type="text/javascript" src="https://livejs.com/live.js"></script>'';
		".local/share/githubstyle.css".source = ../share/githubstyle.css;
	};
}
