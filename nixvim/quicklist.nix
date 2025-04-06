{pkgs, ...}: {
	programs.nixvim = {
		plugins = {
			quicker = {
				enable = true;
				settings = {
					keys = [
						{
							__unkeyed-1 = ">";
							__unkeyed-2.__raw = ''
								function()
									require('quicker').expand {
										before = 2,
										after = 2,
										add_to_existing = true,
									}
								end
								'';
							desc = "Expand quickfix context";
						}
						{
							__unkeyed-1 = "<";
							__unkeyed-2.__raw = ''
								function()
									require('quicker').collapse {
										before = 2,
										after = 2,
										add_to_existing = true,
									}
								end
								'';
							desc = "Collapse quickfix context";
						}
					];
				};
			};
			nvim-bqf.enable = true;
			nvim-bqf.extraOptions = {
				preview = {
					border = "double";
					show_scroll_bar = false;
					winblend = 0;
				};
			};
		};
		keymaps = [
			{
				key = "<leader>q";
				action.__raw = ''
					function()
						require('quicker').toggle()
					end
				'';
				options.desc = "Toggle quickfix";
			}
		];
		# TODO help with g? for quickfix list
	};
}
