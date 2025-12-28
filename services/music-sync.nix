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
			Service = {
				Type = "exec";
				ExecStart = "${script} ${dir} ${url}";
				Restart="always";
				RestartSec="5h";
			};
			Unit = {
				Description = "Sync ${name} playlist";
				After="network-online.target";
			};
			Install.WantedBy=["multi-user.target"];
		};
in
	{
	systemd.user.services = {
		music-sync-default = mkMusicPlaylistSync
			{name = "default"   ; uuid = "PLIXakC3E17zOrxzGj9ZhnDhI5qXnOwySx";};
		music-sync-miku = mkMusicPlaylistSync
			{name = "miku"      ; uuid = "PL_vUk3T5tDsszjAAphvdCz7z6SCu6A5E6";};
		music-sync-nightcore = mkMusicPlaylistSync
			{name = "nightcore" ; uuid = "PL5qXa9xbuolOlZAMvPQBL6i5CnxR8ctvm";};
	};
}
