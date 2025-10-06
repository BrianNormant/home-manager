{...}: {
	programs.ssh = {
		enable = true;
		enableDefaultConfig = false;
		matchBlocks = {
			"BrianNixDesktop" = {
				hostname = "192.168.2.71";
				port = 4269;
				user = "brian";
			};
			"BrianNixDesktopI" = {
				hostname = "ggkbrian.com";
				port = 4269;
				user = "brian";
			};
			"BrianNixServer" = {
				hostname = "192.168.2.72";
				port = 22;
				user = "server";
			};
			"RootNixServer" = {
				hostname = "192.168.2.72";
				port = 22;
				user = "root";
			};
			"BrianNixLaptop" = {
				hostname = "192.168.2.73";
				port = 4269;
				user = "brian";
			};
		};
	};
}
