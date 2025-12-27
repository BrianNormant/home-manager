{ pkgs, ... }: {
	programs = {
		kitty = {
			enable = true;
			font = {
				# name = "FiraCode Nerd Font Ret";
				name = "Victor Mono";
				package = pkgs.rictydiminished-with-firacode;
				size = 14;
			};
			settings = {
				enable_audio_bell = false;
				confirm_os_window_close = "0";
				# background_opacity = "0.8";
				# dynamic_background_opacity = true;
				# background_tint = "0.0";
				background = "#32302F";
				sync_to_monitor = "no";
			};
			quickAccessTerminalConfig = {
				lines = 25;
				columns = 80;
				opacity = 0.8;
				edge = "center-sized";
			};
			extraConfig = ''
				map alt+F1 set_background_opacity +0.1
				map alt+F2 set_background_opacity -0.1
			'';
		};
	};
}
