{hostname, ...}: {
	programs = {
		zapzap = {
			enable = true;
			settings = {
				system = {
					scale = if hostname == "BrianNixDesktop" then 150 else 100;
					sidebar = false;
					start_background = true;
					wayland = true;
				};
				website = {
					open_page = false;
				};
			};
		};
	};
}
