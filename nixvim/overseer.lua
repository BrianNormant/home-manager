local overseer = require('overseer')
local task_list = require('overseer.task_list')
local commands = require('overseer.commands')
local templates = require('overseer.template')

--------------------------------[ runLastOrAsk ]--------------------------------

vim.api.nvim_create_user_command("OverseerRunLastOrAsk", function ()
	local tasks = overseer.list_tasks({
		status = {
			overseer.STATUS.SUCCESS,
			overseer.STATUS.FAILURE,
		},
		sort = task_list.sort_finished_recently
	})
	if vim.tbl_isempty(tasks) then
		commands.run_template()
	else
		overseer.run_action(tasks[1], "restart")
	end
end, {})

vim.api.nvim_create_user_command("Make", function(params)
	local fn = function(arg)
		-- Insert args at the '$*' in the makeprg
		local cmd, num_subs = vim.o.makeprg:gsub("%$%*", arg)
		if num_subs == 0 then
			cmd = cmd .. " " .. params.args
		end
		local task = require("overseer").new_task({
			cmd = vim.fn.expandcmd(cmd),
			components = {
				{ "on_output_quickfix", open_height = 8 },
				"default",
			},
		})
		task:start()
	end
	if params.bang then
		vim.ui.input( {
			prompt = "Make Command: ",
		}, fn)
	else
		fn(params.args)
	end
end, {
		desc = "Run your makeprg as an Overseer task",
		nargs = "*",
		bang = true,
	})

-------------------------------[ Nix flake Cmd ]--------------------------------

local mk_task_pkg_build = function(args, name)
	return {
		name = "nix build " .. name,
		builder = function(_)
			return {
				cmd = { "nix", "build" },
				args = args,
				desc = "Build Package",
			}
		end,
	}
end

local mk_task_home_build = function(args, name)
	return {
		name = "home-manager build " .. name,
		builder = function(_)
			return {
			cmd = { "home-manager", "build" },
			args = args,
			desc = "Build Home Manager Configuration",
			}
		end,
	}
end

local mk_task_home_switch = function(args, name)
	return {
		name = "home-manager switch " .. name,
		builder = function(_)
			return {
				cmd = { "home-manager", "switch" },
				args = args,
				desc = "Switch Home Manager Configuration",
			}
		end,
	}
end

local mk_task_os_build = function(args, name)
	return {
		name = "nixos-rebuild build " .. name,
		builder = function(_)
			return {
				cmd = { "nixos-rebuild", "build", },
				args = args,
				desc = "Build NixOS Configuration",
			}
		end,
	}
end

local mk_task_os_switch = function(args, name)
	return {
		name = "nixos-rebuild switch " .. name,
		builder = function(_)
			return {
				cmd = { "nixos-rebuild", "switch", },
				args = args,
				desc = "Switch NixOS Configuration",
			}
		end,
	}
end

-- we register if there is a flake.nix file
local get_flake = function(opts)
	return vim.fs.find("flake.nix", {upward = false, type = "file", path = opts.dir})[1]
end

local parse_flake_show = function(_, cb)
	local cwd = vim.uv.cwd()
	-- we have to manually list the homeConfigurations as they don't show individually
	-- in the nix flake show output
	-- https://discourse.nixos.org/t/how-to-list-home-manager-configs-in-flake/58808/2
	vim.system({
		"nix",
		"eval",
		"./#homeConfigurations",
		"--apply",
		"hconf: builtins.attrNames hconf",
		"--json",
	}, {text = true, cwd = cwd}, function(obj)
			if obj.code ~= 0 then return end
			local json_raw = obj.stdout
			local json = vim.json.decode(json_raw)
			local tasks = {}

			for _, conf in pairs(json) do
				local task_build = mk_task_home_build({ "--flake", ".#" .. conf }, conf)
				table.insert(tasks, task_build)
				local switch_task = mk_task_home_switch({ "--flake", ".#" .. conf }, conf)
				table.insert(tasks, switch_task)
			end

			vim.schedule(function() cb(tasks) end)
	end)
	vim.system({"nix", "flake", "show", "--json"}, {text = true, cwd = cwd}, function(obj)
		assert(obj.code == 0, obj.stderr)
		local json_raw = obj.stdout
		local json = vim.json.decode(json_raw)
		local tasks = {}

		if json["nixosConfigurations"] then
			local configurations = json["nixosConfigurations"]
			for conf, _ in pairs(configurations) do
				local task_build = mk_task_os_build({ "--flake", ".#" .. conf }, conf)
				table.insert(tasks, task_build)
				local switch_task = mk_task_os_switch({ "--flake", ".#" .. conf }, conf)
				table.insert(tasks, switch_task)
			end
		end

		if json["packages"] then
			local packages = json["packages"]["x86_64-linux"]
			for pkg, _ in pairs(packages) do
				local task_build = mk_task_pkg_build({ "--flake", ".#" .. pkg }, pkg)
				table.insert(tasks, task_build)
			end
		end
		vim.schedule(function() cb(tasks) end)
	end)
end

-- the template generator
local nix_provider = {
	name = "nix-provider",
	cache_key = get_flake,
	generator = parse_flake_show,
}

templates.register(nix_provider)

--------------------------------[ Makefile Cmd ]--------------------------------

local mk_task_make = function(args, name)
	return {
		name = "make task " .. name,
		builder = function(_)
			return {
				cmd = { "make" },
				args = args,
				desc = "Run make task",
			}
		end
	}
end

local get_make = function(opts)
	return vim.fs.find("Makefile", {upward = false, type = "file", path = opts.idr})[1]
end

local make_generator = function(_, cb)
	-- try make list and make help
	
	local cwd = vim.uv.cwd()

	vim.system({"make", "list"}, {text = true, cwd = cwd}, function(obj)
		if obj.code ~= 0 then return end
		local raw = obj.stdout
		local tasks = {}
		for line in raw:gmatch("[^\r\n]+") do
			-- target is first word
			local target = line:match("%S+")
			local task_make = mk_task_make({ target }, name)
			table.insert(tasks, task_make)
		end
		vim.schedule(function() cb(tasks) end)
	end)

	vim.system({"make", "help"}, {text = true, cwd = cwd}, function(obj)
		if obj.code ~= 0 then return end
		local raw = obj.stdout
		local tasks = {}
		for line in raw:gmatch("[^\r\n]+") do
			-- target is first word
			local target = line:match("%S+")
			local task_make = mk_task_make({ target }, name)
			table.insert(tasks, task_make)
		end
		vim.schedule(function() cb(tasks) end)
	end)
end

local makefile_provider = {
	name = "make-provider",
	cache_key = get_make,
	generator = make_generator,
}

templates.register(makefile_provider)
