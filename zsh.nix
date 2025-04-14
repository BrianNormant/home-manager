{pkgs, lib, ...}:
let
	inherit (pkgs.lib) fakeHash;
	toPlugin = {pkg, file-name ? "init.zsh"} : {
		inherit (pkg) name;
		inherit (pkg) src;
		file = file-name;
	};
	selected-zsh-plugins = with pkgs; [
		{pkg = zsh-completions       ; file-name = "zsh-completions.plugin.zsh";}
		{pkg = zsh-forgit            ; file-name = "forgit.plugin.zsh";}
		{pkg = zsh-fzf-history-search; file-name = "zsh-history-search.plugin.zsh";}
		{pkg = zsh-fzf-tab           ; file-name = "fzf-tab.plugin.zsh";}
		{pkg = zsh-nix-shell         ; file-name = "nix-shell.plugin.zsh";}
		{pkg = zsh-powerlevel10k     ; file-name = "powerlevel10k.zsh-theme";}
		{pkg = zsh-you-should-use    ; file-name = "zsh-you-should-use.plugin.zsh";}
	];
in {
	programs.direnv = {
		enable = true;
		enableZshIntegration = true;
		enableBashIntegration = false;
		silent = true;
	};
	programs.zsh = {
		enable = true;
		syntaxHighlighting.enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		shellAliases = {
			rimsort = "nix run github:vinnymeller/nixpkgs/init-rimsort#rimsort";
			flake-init = "nix flake init -t github:BrianNormant/nixosconf";
			icat  =  "kitty +kitten icat --clear";
			neo = "hyprctl dispatch scroller:setmode c; neovide &>/dev/null &; sleep 1; hyprctl dispatch scroller:setmode s";
			du = "dust";
			df = "duf";
			cd = "z"; # zoxide
			ls = "lsd";
			ll = "ls -l";
			l  = "ls -la";
			man = "batman";
			gg  = "lazygit";
			glo = "git log --all --decorate=short --color --pretty=format:'^%C(dim white)%>(12,trunc)%cr%C(reset)^%C(bold 214)%<(7,trunc)%h%C(reset)' -5 | column -t -s ^";
			glog = "git log --all --graph --decorate=short --color --pretty=format:'%C(bold 214)%<(7,trunc)%h%C(reset)^%C(dim white)%>(12,trunc)%cr%C(reset)^%C(auto)%>(15,trunc)%D%C(reset)^%C(white)%<(80,trunc)%s%C(reset)' | column -t -s ^";
			gloga = "git log --all --graph --decorate=short --color --pretty=format:'^%C(dim white)%>(12,trunc)%cr%C(reset)^%C(cyan)%<(10,trunc)%cs%C(reset)^%C(bold 214)%<(7,trunc)%h%C(reset)^%C(auto)%<(15,trunc)%D%C(reset)^%C(white)%s%C(reset)' | column -t -s ^";
		};
		plugins = map toPlugin selected-zsh-plugins;
		initExtraFirst = builtins.readFile ./config/zshrc.first;
		initContent = lib.mkOrder 2000 (builtins.readFile ./config/zshrc);
	};
	home = {
		packages = builtins.map ({pkg, ...}: pkg) selected-zsh-plugins;
		file.".p10k.zsh".source = ./config/.p10k.zsh;
	};
}
