{pkgs, ...}: {
	home = {
		file = {
			".config/script/replay.sh" = {
				source = ../script/replay-notify.sh;
				executable = true;
			};
			".config/script/record-replay.sh" = {
				source = ../script/record-replay.sh;
				executable = true;
			};
		};
		packages = with pkgs; [
			gpu-screen-recorder
		];
	};
}
