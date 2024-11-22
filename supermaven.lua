local vim = vim
local CompletionPreview = require("supermaven-nvim.completion_preview")

local label_text = function(text)
  local shorten = function(str)
    local short_prefix = string.sub(str, 0, 20)
    local short_suffix = string.sub(str, string.len(str) - 15, string.len(str))
    local delimiter = " ... "
    return short_prefix .. delimiter .. short_suffix
  end

  text = text:gsub("^%s*", "")
  return string.len(text) > 40 and shorten(text) or text
end

--- @class blink.cmp.Source
local supermaven = {}

function supermaven.new()
	return setmetatable({}, { __index = supermaven })
end

function supermaven:get_trigger_characters()
	return { "*" } -- Try to fetch suggestion on every keystroke
end

function supermaven:resolve(item, callback)
	callback(item)
end

function supermaven:get_completions(context, callback)

	local inlay_instance = CompletionPreview:get_inlay_instance()
	CompletionPreview:dispose_inlay()
	if not inlay_instance then
		callback({
			is_incomplete_backward = false,
			is_incomplete_forward = false,
			context = context,
			items = {},
		})
	end

	local params = vim.lsp.util.make_position_params()
	params.context = {
		triggerKind = context.trigger.kind
	}
	if context.trigger.kind == vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter then
		params.context.triggerCharacter = context.trigger.character
	end

	local cursor = {
		line = params.position.line,
		col = params.position.character,
	}

	local completion_text = inlay_instance.line_before_cursor .. inlay_instance.completion_text
	local preview_text = completion_text
	local split = vim.split(completion_text, "\n", { plain = true })
	local label = label_text(split[1])

	local range = {
		start = {
			line = cursor.line,
			character = math.max(cursor.col - inlay_instance.prior_delete - #inlay_instance.line_before_cursor - 1, 0),
		},
		["end"] = {
			line = cursor.line,
			character = vim.fn.col("$"),
		}
	}

	local items = {{
		label = label,
		kind = vim.lsp.protocol.CompletionItemKind.Text,
		textEdit = {
			range = range,
			newText = completion_text,
		},
		documentation = {
			kind = "markdown",
			value = "```" .. vim.bo.filetype .. "\n" .. preview_text .. "\n```",
		},
		dup = 0,
		cusor_column = cursor.col,
		blink = { source = "Supermaven", },
	}}

	callback({
		is_incomplete_backward = false,
		is_incomplete_forward = false,
		context = context,
		items = items,
	})
	return function() end
end

return supermaven
