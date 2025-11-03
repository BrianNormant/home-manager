local overseer = require('overseer')

-- every `packages` is ran with `nix build`
local tmpl_pkg = {
	name = "nix",
	priority = 10,
	params = {
		args = {
			type = "list",
			delimiter = " ",
			name = "flake",
			desc = "The flake to build",
			default = ".#default",
			optional = false,
		},
		cwd = { optional = false, },
	},
	builder = function(params)
		return {
			cmd = { "nix", "build" },
			args = params.args,
			cwd = params.cwd,
		}
	end,
}

-- every `homeConfigurations` is ran with `home-manager build`
local tmpl_home = {
	name = "home-manager",
	priority = 30,
	params = {
		cwd = { optional = false, },
	},
	builder = function(params)
		return {
			cmd = { "home-manager", "build" },
			cwd = params.cwd,
		}
	end,
}

local tmpl_home_switch = {
	name = "home-manager",
	priority = 20,
	params = {
		cwd = { optional = false, },
	},
	builder = function(params)
		return {
			cmd = { "home-manager", "switch" },
			cwd = params.cwd,
		}
	end,
}

-- every `nixosConfigurations` is ran with `nixos-rebuild build`
local tmpl_os = {
	name = "Nixos",
	priority = 30,
	params = {
		args = {
			type = "list",
			name = "conf",
			desc = "The configuration to build",
			optional = false,
			delimiter = " ",
		},
		cwd = { optional = false, },
	},
	builder = function(params)
		return {
			cmd = { "nixos-rebuild", "build", "--flake" },
			args = params.args,
			cwd = params.cwd,
		}
	end,
}

local tmpl_os_switch = {
	name = "Nixos",
	priority = 20,
	params = {
		args = {
			type = "list",
			name = "conf",
			desc = "The configuration to build",
			optional = false,
			delimiter = " ",
		},
		cwd = { optional = false, },
	},
	builder = function(params)
		return {
			cmd = { "nixos-rebuild", "switch", "--flake" },
			args = params.args,
			cwd = params.cwd,
		}
	end,
}

-- we register if there is a flake.nix file
local get_flake = function(opts)
	local cwd = vim.uv.cwd()
	return vim.fs.find("flake.nix", {upward = false, type = "file", path = cwd})[1]
end

-- We take the json output from `nix flake show --json`
local parse_flake_show = function(_, cb)
	local cwd = vim.uv.cwd()
	vim.system({"nix", "flake", "show", "--json"}, {text = true, cwd = cwd}, function(obj)
		assert(obj.code == 0, obj.stderr)
		local json_raw = obj.stdout
		local json = vim.json.decode(json_raw)
		local tasks = {}

		if json["homeConfigurations"] then
			local override = { name = "home-manager" }
			local tmpl = overseer.wrap_template(
				tmpl_home,
				override,
				{
					cwd = cwd
				}
			)
			table.insert(tasks, tmpl)
			override = { name = "home-manager Switch" }
			tmpl = overseer.wrap_template(
				tmpl_home_switch,
				override,
				{
					cwd = cwd
				}
			)
			table.insert(tasks, tmpl)
		end

		if json["nixosConfigurations"] then
			local configurations = json["nixosConfigurations"]
			for conf, _ in pairs(configurations) do
				local override = { name = string.format("Nixos Build %s", conf)}
				local tmpl = overseer.wrap_template(tmpl_os,
					override,
					{
						args = {".#" .. conf},
						cwd = cwd
					}
				)
				table.insert(tasks, tmpl)
				override = { name = string.format("Nixos Switch %s", conf)}
				tmpl = overseer.wrap_template(tmpl_os_switch,
					override,
					{
						args = {".#" .. conf},
						cwd = cwd
					}
				)
				table.insert(tasks, tmpl)
			end
		end

		if json["packages"] then
			local packages = json["packages"]["x86_64-linux"]
			for pkg, _ in pairs(packages) do
				local override = { name = string.format("Nix %s", pkg)}
				local tmpl = overseer.wrap_template(tmpl_pkg,
					override,
					{
						args = { ".#" .. pkg},
						cwd = cwd
					}
				)
				table.insert(tasks, tmpl)
			end
		end
		vim.schedule(function()
			cb(tasks)
		end)
	end)
end

-- the template generator
local provider = {
	name = "nix",
	cache_key = function(opts)
		return get_flake(opts)
	end,
	condition = {
		callback = function(opts)
			if vim.fn.executable("nix") == 0 then
				return false, 'Command "nix" not found'
			end
			if not get_flake(opts) then
				return false, "No flake.nix file found"
			end
			return true
		end,
	},
	generator = parse_flake_show,
}

overseer.register_template(provider)
