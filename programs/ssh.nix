{...}: {
	programs.ssh = {
		enable = true;
		enableDefaultConfig = false;
		settings = {
			"BrianNixDesktop" = {
				HostName = "192.168.2.71";
				Port = 4269;
				User = "brian";
			};
			"BrianNixDesktopI" = {
				HostName = "ggkbrian.com";
				Port = 4269;
				User = "brian";
			};
			"BrianNixServer" = {
				HostName = "192.168.2.72";
				Port = 22;
				User = "server";
			};
			"RootNixServer" = {
				HostName = "192.168.2.72";
				Port = 22;
				User = "root";
			};
			"BrianNixLaptop" = {
				HostName = "192.168.2.73";
				Port = 4269;
				User = "brian";
			};
			"Remarkable" = {
				HostName = "10.11.99.1";
				Port = 22;
				User = "root";
				StrictHostKeyChecking = "no";
				UserKnownHostsFile = "/dev/null";
			};
		};
	};
}
