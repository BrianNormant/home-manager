{pkgs, config, ...} :
let
	script = pkgs.writeScript "sync-youtube-playlist"
		''
#!${pkgs.zsh}/bin/zsh
export dir=$1
export url=$2

export PATH=${pkgs.yt-dlp}/bin:$PATH
export PATH=${pkgs.ffmpeg}/bin:$PATH

mkdir -p $dir

touch $dir/playlist.txt


exec yt-dlp --max-filesize 10M \
	--yes-playlist \
	--download-archive $dir/playlist.txt \
	--extract-audio \
	--audio-format opus \
	--output "$dir/%(title)s.%(ext)s" \
	$url
'';
	mkMusicPlaylistSync = {name, uuid}:
		let
			dir = config.home.homeDirectory + "/Music/${name}";
			url = "https://youtube.com/playlist?list=" + uuid;
		in {
		Service.Type = "exec";
		Service.ExecStart = "${script} ${dir} ${url}";
		Service.Restart="always";
		Service.RestartSec="5h";
		Unit.Description = "Sync ${name} playlist";
		Unit.After="network-online.target";
		Install.WantedBy=["multi-user.target"];
	};
	playlists = {
		music-sync-default = mkMusicPlaylistSync
			{name = "default"   ; uuid = "PLIXakC3E17zOrxzGj9ZhnDhI5qXnOwySx";};
		music-sync-miku = mkMusicPlaylistSync
			{name = "miku"      ; uuid = "PL_vUk3T5tDsszjAAphvdCz7z6SCu6A5E6";};
		music-sync-nightcore = mkMusicPlaylistSync
			{name = "nightcore" ; uuid = "PL5qXa9xbuolOlZAMvPQBL6i5CnxR8ctvm";};
	};
in
	{
	systemd.user = {
		services = playlists // {
			nm-applet = {
				Service.Type = "exec";
				Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
				Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			steam = {
				Service.Type = "exec";
				Service.Environment = [
					"PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin"
					"DISPLAY=:0"
				];
				Service.ExecStart = "/run/current-system/sw/bin/steam -silent";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			discord = {
				Service.Type = "exec";
				Service.Environment = [
					"PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin"
					"DISPLAY=:0"
				];
				Service.ExecStart = "${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform-hint=auto --start-minimized";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			waypaper = {
				Service.Type = "oneshot";
				Service.ExecStart = "${pkgs.waypaper}/bin/waypaper --random";
				Service.Environment = [
					"WAYLAND_DISPLAY=wayland-1"
				];
				Unit.Description = "Randomize the wallpaper";
			};
			
			swww = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.swww}/bin/swww-daemon";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			corectrl = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.corectrl}/bin/corectrl";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			copyq = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.copyq}/bin/copyq";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			zapzap = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.zapzap}/bin/zapzap";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};
		
			yt-music = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.youtube-music}/bin/youtube-music";
				Service.Restart="always";
				Service.RestartSec="5s";
				Unit.After="niri.service";
			};

			switch-playerctl = {
				Service.Environment = "PATH=/run/current-system/sw/bin:/home/brian/.nix-profile/bin";
				Service.ExecStart = "/run/current-system/sw/bin/zsh /home/brian/.config/script/switch-playerctl.zsh";
			};

			polkit-agent = {
				Service.Type = "exec";
				Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Unit.After="niri.service";
			};
		};

		timers = {
			# cycle-paper.Timer.OnCalendar = "*-*-* *:*:00";
			waypaper.Timer.OnCalendar = "*:0/1";
		};
	};
}
