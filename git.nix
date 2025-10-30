{ pkgs, hostname, ... }: {
	home.packages = with pkgs; [
		delta
		gh
	];
	programs = {
		git = {
			enable = true;
			settings = {
				user = {
					email = "briannormant@gmail.com";
					name = hostname;
				};
				core = {
					pager = "delta --pager='ov -F'";
				};
				pager = {
					show = "delta --pager='ov -F --header 3'";
					diff = "delta --features ov-diff";
					log  = "delta --features ov-log";

				};
				delta = {
					navigate = "true";
					side-by-side = "true";
					file-style = "yellow";
				};
				"delta \"ov-diff\"" = {
					pager = "ov -F --section-delimiter '^(commit|added:|removed:|renamed:|Δ)' --section-header --pattern '•'";
				};
				"delta \"ov-log\"" = {
					pager = "ov -F --section-delimiter '^commit' --section-header-num 3";
				};
				push = {
					followTags = "true";
					default = "upstream"; # Push to the tracked branch (see with git branch -vv)
				};
				log.excludeDecoration = "refs/stash";
				merge.tool = "nvim -c \"Git mergetool\"";
				"credential \"https://github.com\"" = {
					helper = "${pkgs.gh} auth git-credential";
				};
				"credential \"https://gist.github.com\"" = {
					helper = "${pkgs.gh} auth git-credential";
				};
				"color \"decorate\"" = {
					HEAD = "blink bold italic 196";
					branch = "214";
					tag = "bold 222";
				};

			};
		};
	};
}
