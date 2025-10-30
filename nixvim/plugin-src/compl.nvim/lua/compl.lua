--- https://github.com/brianaung/compl.nvim
local M = {}
_G.Compl = {}

M._opts = {
	completion = {
		timeout = 100,
		fuzzy = false,
	},
	info = {
		enable = true,
		timeout = 100,
	},
	snippet = {
		enable = false,
		paths = {},
	},
}

M._ctx = {
	cursor = nil,
	pending_requests = {},
	cancel_pending = function()
		for _, cancel_fn in ipairs(M._ctx.pending_requests) do
			pcall(cancel_fn)
		end
		M._ctx.pending_requests = {}
	end,
}

M._completion = {
	timer = vim.uv.new_timer(),
	responses = {},
}


M._info = {
	bufnr = 0,
	winids = {},
	request = false,
	close_windows = function()
		for idx, winid in ipairs(M._info.winids) do
			if pcall(vim.api.nvim_win_close, winid, false) then
				M._info.winids[idx] = nil
			end
		end
	end,
}

M._snippet = {
	client_id = nil,
	items = {},
}

function M.setup(opts)
	if vim.fn.has "nvim-0.10" ~= 1 then
		vim.notify("compl.nvim: Requires nvim-0.10 or higher.", vim.log.levels.ERROR)
		return
	end

	-- apply and validate settings
	M._opts = vim.tbl_deep_extend("force", M._opts, opts or {})
	vim.validate {
		["completion"] = { M._opts.completion, "t" },
		["completion.timeout"] = { M._opts.completion.timeout, "n" },
		["completion.fuzzy"] = { M._opts.completion.fuzzy, "b" },
		["info"] = { M._opts.info, "t" },
		["info.enable"] = { M._opts.info.enable, "b" },
		["info.timeout"] = { M._opts.info.timeout, "n" },
		["snippet"] = { M._opts.snippet, "t" },
		["snippet.enable"] = { M._opts.snippet.enable, "b" },
		["snippet.paths"] = { M._opts.snippet.paths, "t" },
	}

	local group = vim.api.nvim_create_augroup("Compl", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
		group = group,
		callback = function(args)
			vim.bo[args.buf].omnifunc = "v:lua.Compl.completefunc"
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
		group = group,
		callback = vim.schedule_wrap(function()
			if not _G.compl_autorefresh then return end
			M._start_completion(false)
		end),
	})

	vim.api.nvim_create_autocmd("CompleteDone", {
		group = group,
		callback = M._on_completedone,
	})

	vim.api.nvim_create_autocmd({ "InsertLeavePre", "InsertLeave" }, {
		group = group,
		callback = function()
			M._ctx.cancel_pending()
			M._info.close_windows()
		end,
	})

	if M._opts.info.enable then
		M._create_info_buffer()
	end

	if M._opts.snippet.enable then
		vim.api.nvim_create_autocmd("BufEnter", {
			group = group,
			callback = M._start_snippet,
		})
	end
end


function M._create_info_buffer()
	M._info.bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(M._info.bufnr, "Compl:InfoWindow")
	vim.fn.setbufvar(M._info.bufnr, "&buftype", "nofile")
	vim.fn.setbufvar(M._info.bufnr, "&filetype", "markdown")
	require('markview').actions.attach(M._info.bufnr)
	require('markview').actions.enable(M._info.bufnr)
end

-- This function populate the completion options with the lsps
-- if the open_after option is set, we open the completion menu with the items after
function M._start_completion(open_after)
	-- M._ctx.cancel_pending()

	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))
	local line = vim.api.nvim_get_current_line()

	if
		-- No LSP clients
		not next(vim.lsp.get_clients { bufnr = bufnr, method = "textDocument/completion" })
		-- Not a normal buffer
		or vim.api.nvim_get_option_value("buftype", { buf = bufnr }) ~= ""
		-- Item is selected
		or vim.fn.complete_info()["selected"] ~= -1
		-- Context didn't change
		-- or vim.deep_equal(M._ctx.cursor, { row, col })
	then
		M._ctx.cursor = { row, col }
		-- Do not trigger completion
		return
	end
	M._ctx.cursor = { row, col }

	-- Make a request to get completion items
	local position_params = M._make_position_params()
	M._completion.responses = {}
	local cancel_fn = vim.lsp.buf_request_all(bufnr, "textDocument/completion", position_params, function(responses)
		vim.iter(pairs(responses))
			:filter(function(_, response)
				return (not response.err) and response.result
			end)
			:each(function(client_id, response)
				local name = vim.lsp.get_client_by_id(client_id)["name"]
				local itemDefaults = response.result.itemDefaults
				local items = response.result.items or response.result or {}
				vim.iter(ipairs(items)):each(function(_, item)
					item.menu = "LSP"
					if name == "jdtls" and item.kind ~= 1 then
						item.expandme = true
					end
					if string.match(name, "snippets#-.+") then
						item.menu = "Snippets"
					end
					if itemDefaults == nil then return end
					-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/completion.lua#L173
					item.insertTextFormat = item.insertTextFormat or itemDefaults.insertTextFormat
					item.insertTextMode = item.insertTextMode or itemDefaults.insertTextMode
					item.data = item.data or itemDefaults.data
					if itemDefaults.editRange then
						local textEdit =  item.textEdit or {}
						item.textEdit = textEdit
						textEdit.newText = textEdit.newText or item.textEditText or item.insertText
						if itemDefaults.editRange.start then
							textEdit.range = textEdit.range or itemDefaults.editRange
						elseif itemDefaults.editRange.insert then
							textEdit.insert = itemDefaults.editRange.insert
							textEdit.replace = itemDefaults.editRange.replace
						end
					end
				end)
			end)
		M._completion.responses = responses
		if open_after and vim.fn.mode() == "i" then
			local from = M._completefunc_getcol() + 1
			local to = vim.fn.col(".")
			local line_ = vim.api.nvim_get_current_line()
			local base = line_:sub(from, to - from)
			vim.fn.complete(
				from,
				M._process_items(M._completion.responses, base)
			)
			M._start_info() -- because we preselect, we need to show the info window
			-- manually for the first item
			M._completion.responses = {}
		end
	end)

	-- table.insert(M._ctx.pending_requests, cancel_fn)
end

function M._process_items(items_arg, base)
	local matches = {}
	for client_id, response in pairs(items_arg) do
		if not response.err and response.result then
			local items = response.result.items or response.result or {}

			for _, item in pairs(items) do
				local text = item.filterText
					or (vim.tbl_get(item, "textEdit", "newText") or item.insertText or item.label or "")
				if vim.startswith(text, base) then
					table.insert(matches, { client_id = client_id, item = item })
				end
			end
		end
	end

	matches = vim.iter(ipairs(matches))
		:map(function(_, match)
			local item = match.item
			local client_id = match.client_id

			local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Unknown"
			local menu = item.menu
			-- local doc = M._get_documentation(client_id, item)
			local word
			if kind == "Snippet" then
				word = item.label or ""
			else
				word = vim.tbl_get(item, "textEdit", "newText") or item.insertText or item.label or ""
			end

			return {
				word = word,
				abbr = item.label,
				kind = kind,
				-- info = doc,
				icase = 1,
				dup = 1,
				menu = menu,
				user_data = {
					expandme = item.expandme ~= nil,
					nvim = {
						lsp = {
							completion_item = item,
							client_id = client_id,
						},
					},
				},
			}
		end)
		:totable()
	return matches
end

function M._get_documentation(client_id, item)
	local Client = vim.lsp.get_client_by_id(client_id)
	if not Client then return end
	--- This may be very very slow...
	local err, result = Client:request_sync("completionItem/resolve", item)
	if err then return end
	if result then return result end
end

function M._completefunc_getcol()
	-- Example from: https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/completion.lua#L331
	-- Completion response items may be relative to a position different than `client_start_boundary`.
	-- Concrete example, with lua-language-server:
	--
	-- require('plenary.asy|
	--         ▲       ▲   ▲
	--         │       │   └── cursor_pos:                     20
	--         │       └────── client_start_boundary:          17
	--         └────────────── textEdit.range.start.character: 9
	--                                 .newText = 'plenary.async'
	--                  ^^^
	--                  prefix (We'd remove everything not starting with `asy`,
	--                  so we'd eliminate the `plenary.async` result
	--
	-- We prefer to use the language server boundary if available.
	local winnr = vim.api.nvim_get_current_win()
	local line = vim.api.nvim_get_current_line()
	local _, col = unpack(vim.api.nvim_win_get_cursor(winnr))
	for _, response in pairs(M._completion.responses) do
		if not response.err and response.result then
			local items = response.result.items or response.result or {}
			for _, item in pairs(items) do
				-- Get server start (if completion item has text edits)
				-- https://github.com/echasnovski/mini.completion/blob/main/lua/mini/completion.lua#L1306
				if type(item.textEdit) == "table" then
					local range = type(item.textEdit.range) == "table" and item.textEdit.range
						or item.textEdit.insert
					return range.start.character
				end
			end
		end
	end

	-- Fallback to client start (if completion item does not provide text edits)
	return vim.fn.match(line:sub(1, col), "\\k*$")
end

function _G.Compl.completefunc(findstart, base)

	-- Find completion start
	if findstart == 1 then

		--- no responses
		if #M._completion.responses == 0 then
			vim.schedule(function() M._start_completion(true) end)
			return -3
		end

		return M._completefunc_getcol()
	end

	-- Process and find completion words
	return M._process_items(M._completion.responses, base)
end

function M._start_info(data)
	M._info.close_windows()
	M._info.request = true

	local lsp_data = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp") or {}
	local completion_item = lsp_data.completion_item or {}
	if not next(completion_item) then
		return
	end

	local client = vim.lsp.get_client_by_id(lsp_data.client_id)
	if not client then
		return
	end

	-- get resolved item only if item does not already contain documentation
	if completion_item.documentation then
		M.request = true
		M._open_info_window(completion_item)
	else
		local ok, request_id = client.request("completionItem/resolve", completion_item, function(err, result)
			if not err and result.documentation then
				M.request = true
				M._open_info_window(result)
			end
		end)
	end
end

function M._open_info_window(item)
	-- require('markview').clear(M._info.bufnr)
	local detail = item.detail or ""

	local documentation
	if type(item.documentation) == "string" then
		documentation = item.documentation or ""
	else
		documentation = vim.tbl_get(item.documentation or {}, "value") or ""
	end

	if documentation == "" and detail == "" then
		return
	end

	local input
	if detail == "" then
		input = documentation
	elseif documentation == "" then
		input = detail
	else
		input = detail .. "\n" .. documentation
	end

	local lines = vim.lsp.util.convert_input_to_markdown_lines(input) or {}
	local pumpos = vim.fn.pum_getpos() or {}

	if next(lines) and next(pumpos) then
		-- Convert lines into syntax highlighted regions and set it in the buffer
		if (vim.fn.bufexists(M._info.bufnr) == 0) then
			M._create_info_buffer()
		end
		
		vim.api.nvim_buf_set_lines(M._info.bufnr, 0, -1, false, lines)

		local pum_left = pumpos.col - 1
		local pum_right = pumpos.col + pumpos.width + (pumpos.scrollbar and 1 or 0)
		local space_left = pum_left + 1
		local space_right = vim.o.columns - pum_right - 1

		-- Choose the side to open win
		local anchor, col, space = "NW", pum_right, space_right
		if space_right < space_left then
			anchor, col, space = "NE", pum_left, space_left
		end

		-- Calculate width (can grow to full space) and height
		local line_range = vim.api.nvim_buf_get_lines(M._info.bufnr, 0, -1, false)
		local width, height = vim.lsp.util._make_floating_popup_size(line_range, { max_width = space })

		local win_opts = {
			relative = "editor",
			anchor = anchor,
			zindex = 100,
			row = pumpos.row,
			col = col,
			width = 80,
			height = height,
			focusable = false,
			style = "minimal",
			border = "none",
		}

		local wid = vim.api.nvim_open_win(M._info.bufnr, false, win_opts)
		vim.api.nvim_win_set_option(wid, "winblend", 90)
		require('markview').render(M._info.bufnr)

		table.insert(M._info.winids, wid)
	end
end

function M._on_completedone()
	M._info.close_windows()


	local supermaven = vim.tbl_get(vim.v.completed_item, "user_data", "supermaven") or false
	if supermaven then
		local linelen = #vim.api.nvim_get_current_line()
		local cur = vim.api.nvim_win_get_cursor(0)[2] + 1
		if cur > linelen then return end
		-- absolutely stupid revins based solution...
		if vim.o.revins then
			vim.api.nvim_input("<C-u>")
		else
			vim.api.nvim_input("<C-_><C-u><C-_>")
		end
		return
	end

	local lsp_data = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp") or {}
	local expandme = vim.tbl_get(vim.v.completed_item, "user_data", "expandme") or false
	local completion_item = lsp_data.completion_item or {}
	if not next(completion_item) then
		return
	end

	local client = vim.lsp.get_client_by_id(lsp_data.client_id)
	local bufnr = vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()
	local row, col = unpack(vim.api.nvim_win_get_cursor(winnr))

	-- Update context cursor so completion is not triggered right after complete done.
	M._ctx.cursor = { row, col }

	if not client then
		return
	end

	local completed_word = vim.v.completed_item.word or ""
	local kind = vim.lsp.protocol.CompletionItemKind[completion_item.kind] or "Unknown"

	-- No words were inserted since it is a duplicate, so set cursor to end of duplicate word
	if completed_word == "" then
		local replace = vim.tbl_get(lsp_data, "replace") or ""
		pcall(vim.api.nvim_win_set_cursor, winnr, { row, col + vim.fn.strwidth(replace) })
	end

	-- Expand snippets
	if kind == "Snippet" or expandme then
		pcall(vim.api.nvim_buf_set_text, bufnr, row - 1, col - vim.fn.strwidth(completed_word), row - 1, col, { "" })
		pcall(vim.api.nvim_win_set_cursor, winnr, { row, col - vim.fn.strwidth(completed_word) })
		vim.snippet.expand(vim.tbl_get(completion_item, "textEdit", "newText") or completion_item.insertText or "")
	end

	-- Apply additionalTextEdits
	local edits = completion_item.additionalTextEdits or {}
	if next(edits) then
		vim.lsp.util.apply_text_edits(edits, bufnr, client.offset_encoding)
	else
		-- TODO fix bug
		-- Reproduce:
		-- 1. Insert newline(s) right after completing an item without exiting insert mode.
		-- 2. Undo changes.
		-- Result: Completed item is not removed without the undo changes.
		local ok, request_id = client.request("completionItem/resolve", completion_item, function(err, result)
			edits = (not err) and (result.additionalTextEdits or {}) or {}
			if next(edits) then
				vim.lsp.util.apply_text_edits(edits, bufnr, client.offset_encoding)
			end
		end)
		if ok then
			local cancel_fn = function()
				if client then
					client.cancel_request(request_id)
				end
			end
			table.insert(M._ctx.pending_requests, cancel_fn)
		end
	end
end

function M._start_snippet(ev)
	local bufnr = 0
	local filetype = vim.bo[bufnr].filetype
	-- already created
	-- if the server already exist, attach it to the buffer
	if M.snippets_lsps[filetype] ~= nil then
		local id = M.snippets_lsps[filetype].id
		vim.lsp.buf_attach_client(bufnr, id)
		return
	end
	-- not a normal buffer
	if vim.bo[bufnr].buftype ~= "" then
		return
	end
	-- check if filetype is in disabled list
	local excluded = {
		"help",
		"telescope",
		"oil",
		"",
	}
	if vim.list_contains(excluded, filetype) then
		return
	end
	local snippet_items = {}

	local parse_snippet_data = function(snippet_data)
		vim.iter(pairs(snippet_data or {})):each(function(_, snippet)
			local prefixes = type(snippet.prefix) == "table" and snippet.prefix or { snippet.prefix }
			vim.iter(ipairs(prefixes)):each(function(_, prefix)
				table.insert(snippet_items, {
					detail = "snippet",
					label = prefix,
					kind = vim.lsp.protocol.CompletionItemKind["Snippet"],
					documentation = {
						value = snippet.description,
						kind = vim.lsp.protocol.MarkupKind.Markdown,
					},
					insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
					insertText = type(snippet.body) == "table" and table.concat(snippet.body, "\n") or snippet.body,
				})
			end)
		end)
	end

	vim.iter(ipairs(M._opts.snippet.paths)):each(function(_, root)
		local manifest_path = table.concat({ root, "package.json" }, M._sep)
		M._async_read_json(manifest_path, function(manifest_data)
			vim.iter(ipairs((manifest_data.contributes and manifest_data.contributes.snippets) or {}))
				:filter(function(_, s)
					if type(s.language) == "table" then
						return vim.iter(ipairs(s.language)):any(function(_, l)
							return l == filetype
						end)
					else
						return s.language == filetype
					end
				end)
				:map(function(_, snippet_contribute)
					return vim.fn.resolve(table.concat({ root, snippet_contribute.path }, M._sep))
				end)
				:each(function(snippet_path)
					M._async_read_json(snippet_path, parse_snippet_data)
				end)
		end)
	end)

	-- let the the table be populated
	vim.defer_fn(function()
		M._start_snippet_server(snippet_items, bufnr, filetype)
	end, 1000)
end

-- https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/path.lua#L21
M._sep = (function()
	if jit then
		local os = string.lower(jit.os)
		if os ~= "windows" then
			return "/"
		else
			return "\\"
		end
	else
		return package.config:sub(1, 1)
	end
end)()

M.snippets_lsps = {}

function M._start_snippet_server(items, bufnr, ft)
	local id = vim.lsp.start {
		name = "snippets" .. "-" .. ft,
		cmd = M._make_lsp_server {
			isIncomplete = false,
			items = items,
		},
	}

	M.snippets_lsps[ft] = { items = items, id = id}
end

function M._debounce(timer, timeout, callback)
	return function(...)
		local argv = { ... }
		timer:start(timeout, 0, function()
			timer:stop()
			vim.schedule_wrap(callback)(unpack(argv))
		end)
	end
end

-- https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/path.lua#L755
function M._async_read(file, callback)
	vim.uv.fs_open(file, "r", 438, function(err_open, fd)
		assert(not err_open, err_open)
		vim.uv.fs_fstat(fd, function(err_fstat, stat)
			assert(not err_fstat, err_fstat)
			if stat.type ~= "file" then
				return callback ""
			end
			vim.uv.fs_read(fd, stat.size, 0, function(err_read, data)
				assert(not err_read, err_read)
				vim.uv.fs_close(fd, function(err_close)
					assert(not err_close, err_close)
					return callback(data)
				end)
			end)
		end)
	end)
end

function M._async_read_json(file, callback)
	M._async_read(file, function(buffer)
		local success, data = pcall(vim.json.decode, buffer)
		if not success or not data then
			vim.schedule(function()
				vim.notify(string.format("compl.nvim: Could not decode json file %s", file), vim.log.levels.ERROR)
			end)
			return
		end
		callback(data)
	end)
end

function M._make_position_params()
	if vim.fn.has "nvim-0.11" == 1 then
		return function(client, _)
			return vim.lsp.util.make_position_params(0, client.offset_encoding)
		end
	end
	return vim.lsp.util.make_position_params()
end

function M._make_lsp_server(completion_items)
	return function(dispatchers)
		local closing = false
		local srv = {}

		function srv.request(method, params, callback)
			if method == "initialize" then
				callback(nil, {
					capabilities = {
						completionProvider = true, -- the server has to provide completion support (true or pass options table)
					},
				})
			elseif method == "textDocument/completion" then
				callback(nil, completion_items)
			elseif method == "shutdown" then
				callback(nil, nil)
			end
			return true, 1
		end

		function srv.notify(method, params)
			if method == "exit" then
				dispatchers.on_exit(0, 15)
			end
		end

		function srv.is_closing()
			return closing
		end

		function srv.terminate()
			closing = true
		end

		return srv
	end
end

function M._calculate_frecency_score(frequency, accepted_at)
	frequency, accepted_at = frequency or 0, accepted_at or -1
	return frequency * M._calculate_recency_weight(accepted_at)
end

function M._calculate_recency_weight(accepted_at)
	if accepted_at < 0 then
		return 1
	end
	local age_in_ms = vim.uv.now() - accepted_at
	local half_life = 10 * 60 * 1000 -- 10mins
	return 100 * math.exp(-math.log(2) * age_in_ms / half_life)
end

return M
