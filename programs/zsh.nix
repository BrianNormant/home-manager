{
	pkgs,
	lib,
	fetchUrl,
	fakeHash,
	config,
	...
}:
let
	toPlugin = {pkg, file-name ? "init.zsh"} : {
		inherit (pkg) name;
		inherit (pkg) src;
		file = file-name;
	};
	fzf-theme-script = pkgs.fetchurl {
		url = "https://raw.githubusercontent.com/tinted-theming/tinted-fzf/refs/heads/main/bash/base16-gruvbox-dark-soft.config";
		hash = "sha256-edy1gDNDYlvStEH098vSnXekcL96qux8XDTT/sGforw=";
	};

	selected-zsh-plugins = with pkgs; [
		{pkg = zsh-completions       ; file-name = "zsh-completions.plugin.zsh"   ;}
		{pkg = zsh-forgit            ; file-name = "forgit.plugin.zsh"            ;}
		{pkg = zsh-vi-mode           ; file-name = "zsh-vi-mode.plugin.zsh"       ;}
		{pkg = zsh-fzf-history-search; file-name = "zsh-history-search.plugin.zsh";}
		{pkg = zsh-fzf-tab           ; file-name = "fzf-tab.plugin.zsh"           ;}
		{pkg = zsh-nix-shell         ; file-name = "nix-shell.plugin.zsh"         ;}
		{pkg = zsh-powerlevel10k     ; file-name = "powerlevel10k.zsh-theme"      ;}
		{pkg = zsh-you-should-use    ; file-name = "zsh-you-should-use.plugin.zsh";}
	];

in
{
	programs.zsh = {
		enable = true;
		dotDir = "${config.xdg.configHome}/zsh";
		syntaxHighlighting.enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		sessionVariables = {
			QT_QPA_PLATFORM = "wayland";
		};
		setOptions = [
			"NO_CASEGLOB"
		];
		shellAliases = {
			flake-init = "nix flake init -t github:BrianNormant/nixosconf";
			icat  =  "kitty +kitten icat --clear";
			neo = "neovide &>/dev/null &; sleep 0.250; niri msg action consume-or-expel-window-left";
			du = "dust";
			df = "duf";
			cd = "z"; # zoxide
			ls = lib.mkForce "lsd";
			ll = lib.mkForce "ls -l";
			l  = lib.mkForce "ls -la";
			gg  = "nvim +'tab Git'"; # vim-fugitive is the best thing ever
			gcl = "git clone";
			glo = "git log --all --decorate=short --color --pretty=format:'^%C(dim white)%>(12,trunc)%cr%C(reset)^%C(bold 214)%<(7,trunc)%h%C(reset)' -5 | column -t -s ^";
			glog = "git log --all --graph --decorate=short --color --pretty=format:'%C(bold 214)%<(7,trunc)%h%C(reset)^%C(dim white)%>(12,trunc)%cr%C(reset)^%C(auto)%>(15,trunc)%D%C(reset)^%C(white)%<(80,trunc)%s%C(reset)' | column -t -s ^";
			gloga = "git log --all --graph --decorate=short --color --pretty=format:'^%C(dim white)%>(12,trunc)%cr%C(reset)^%C(cyan)%<(10,trunc)%cs%C(reset)^%C(bold 214)%<(7,trunc)%h%C(reset)^%C(auto)%<(15,trunc)%D%C(reset)^%C(white)%s%C(reset)' | column -t -s ^";
		};
		plugins = map toPlugin selected-zsh-plugins;
		initContent = ''
${builtins.readFile ../config/zshrc.first}
source ${fzf-theme-script}
${builtins.readFile ../config/zshrc}
		'';
	};
	home = {
		packages = builtins.map ({pkg, ...}: pkg) selected-zsh-plugins;
		file.".p10k.zsh".source = ../config/.p10k.zsh;
	};
}
