{config, pkgs, ...}: let
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs.tree-sitter) buildGrammar;
	inherit (pkgs.lib) fakeHash;
	diagram = pkgs.stdenv.mkDerivation rec {
		pname = "diagram";
		version = "023b317";
		src = fetchFromGitHub {
			owner = "pandoc-ext";
			repo = pname;
			rev = version;
			hash = "sha256-NmaI1ikZHLPD+Q+LnETUnwTvXQdzZinHIhGpBq6ESeQ=";
		};
		# Didn't find a way to override this phase :(
		buildPhase = ''
					printf "hello world"
		'';
		installPhase = ''
					mkdir -p $out/
					cp -L $src/diagram.lua $out/diagram.lua
		'';
	};
in {
	programs.nixvim = {
		plugins.markview = {
			enable = true;
			lazyLoad = {
				enable = true;
				settings = {
					ft = [ "markdown" "tex" "typst" "yaml" "html" ];
				};
			};
			settings.preview = {
				enable = true;
				modes = [ "n" "no" "c" ];
				hybrid_modes = [ "o" "i" ];
				linewise_hybrid_modes = true;
				callbacks.on_enable.__raw = ''
					function(_, win)
						vim.wo[win].conceallevel = 2
						vim.wo[win].concealcursor = "c"
						vim.wo[win].wrap = true
					end
				'';
			};
		};
		extraPackages = with pkgs; [
			pandoc
			texliveSmall
			asymptote # 2d/3d graphing https://asymptote.sourceforge.io/gallery/
			plantuml # UML diagrams https://plantuml.com/
			graphviz # graphes https://www.graphviz.org/doc/info/lang.html
			diagram
		];
		autoCmd = [
			{
				event = ["BufWrite" "BufRead"];
				pattern = [ "*.md" ];
				callback.__raw = ''function()
					local name = vim.fn.expand("%:r")
					local outputfile = "/var/lib/nvimpreview/" .. name .. ".html"

					local inputfile = vim.fn.expand("%:p")
					vim.system({
						-- Diagrams and such
						-- https://github.com/pandoc-ext/diagram
						"pandoc",
						"--from",
						"markdown",
						"--to",
						"html",
						inputfile,
						"--output", outputfile,
						"--metadata", "pagetitle=" .. name,
						"--highlight-style", "/home/brian/.local/share/gruvboxdark.theme";
						"--lua-filter", "${diagram}/diagram.lua",
						"--embed-resources=true", -- the generated images are always svg
						"-H", "/home/brian/.local/share/autoreload.html",
						"-H", "/home/brian/.local/share/githubstyle.css",
						"--standalone",
						"--katex", -- render inline latex
					},{}, function(obj)
							if obj.code ~= 0 then
								vim.notify("Pandoc generation failed")
								vim.notify(obj.stderr)
								return
							end
							vim.notify("Pandoc generated!")
							vim.schedule(function()
								if not _G.firefox_open then
									_G.firefox_open = true
									vim.system {"firefox", "localhost/" .. name .. ".html"}
									-- We create a callback to clear firefox_open when we close this buffer
									vim.cmd "auto BufWinLeave <buffer> lua _G.firefox_open = false"
								end
							end)
						end)
				end'';
			}
		];
	};
	home.file = {
		".local/share/autoreload.html".text =
			''<script type="text/javascript" src="https://livejs.com/live.js"></script>'';
		".local/share/githubstyle.css".source = ../share/githubstyle.css;
		".local/share/gruvboxdark.theme".source = ../share/gruvboxdark.theme;
	};
}
