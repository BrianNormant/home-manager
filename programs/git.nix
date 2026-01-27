{ pkgs, hostname, ... }: {
	home.packages = with pkgs; [
		delta
		gh
		glab
	];
	programs = {
		gh = {
			enable = true;
			gitCredentialHelper = {
				enable = true;
			};
		};
		git = {
			enable = true;
			settings = {
				user = {
					email = "briannormant@gmail.com";
					name = hostname;
				};
				push = {
					followTags = "true";
					default = "upstream"; # Push to the tracked branch (see with git branch -vv)
				};
				merge.tool = "nvim -c \"Git mergetool\"";
				merge.conflictstyle = "diff3";
				commit.verbose = true;
			};
			hooks = {
				# TODO: pre commit to force commit message to match:
				# ^([a-zA-Z1-9]+,?)+(\(fix\))?:
				# group1,group2: commit message
				# feature1(fix): commit message
				pre-push = ../script/git-pre-push-hook.sh;
			};
		};
	};
}
