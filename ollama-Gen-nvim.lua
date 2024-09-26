-- https://github.com/mobily/.nvim/blob/main/lua/pickers/ollama.lua
-- Custom UI for picking prompt with Gen.nvim

local utils = {}

function utils.kpairs(t)
  local index
  return function()
    local value
    while true do
      index, value = next(t, index)
      if type(index) ~= "number" or math.floor(index) ~= index then
        break
      end
    end
    return index, value
  end
end

function utils.ireduce(tbl, func, acc)
  for i, v in ipairs(tbl) do
    acc = func(acc, v, i)
  end
  return acc
end

function utils.kreduce(tbl, func, acc)
  for i, v in pairs(tbl) do
    if type(i) == "string" then
      acc = func(acc, v, i)
    end
  end
  return acc
end

function utils.reduce(tbl, func, acc)
  for i, v in pairs(tbl) do
    acc = func(acc, v, i)
  end
  return acc
end

function utils.find_index(tbl, func)
  for index, item in ipairs(tbl) do
    if func(item, index) then
      return index
    end
  end

  return nil
end

function utils.isome(tbl, func)
  for index, item in ipairs(tbl) do
    if func(item, index) then
      return true
    end
  end

  return false
end

function utils.ifind(tbl, func)
  for index, item in ipairs(tbl) do
    if func(item, index) then
      return item
    end
  end

  return nil
end

function utils.find_last_index(tbl, func)
  for index = #tbl, 1, -1 do
    if func(tbl[index], index) then
      return index
    end
  end
end

function utils.slice(tbl, startIndex, endIndex)
  local sliced = {}
  endIndex = endIndex or #tbl

  for index = startIndex, endIndex do
    table.insert(sliced, tbl[index])
  end

  return sliced
end

function utils.concat(...)
  local concatenated = {}

  for _, tbl in ipairs({ ... }) do
    for _, value in ipairs(tbl) do
      table.insert(concatenated, value)
    end
  end

  return concatenated
end

function utils.kmap(tbl, func)
  return utils.kreduce(tbl, function(new_tbl, value, key)
    table.insert(new_tbl, func(value, key))
    return new_tbl
  end, {})
end

function utils.imap(tbl, func)
  return utils.ireduce(tbl, function(new_tbl, value, index)
    table.insert(new_tbl, func(value, index))
    return new_tbl
  end, {})
end

function utils.ieach(tbl, func)
  for index, element in ipairs(tbl) do
    func(element, index)
  end
end

function utils.keach(tbl, func)
  for key, element in utils.kpairs(tbl) do
    func(element, key)
  end
end

function utils.keys(tbl)
  local keys = {}
  for key, _ in utils.kpairs(tbl) do
    table.insert(keys, key)
  end
  return keys
end

function utils.indexes(tbl)
  local indexes = {}
  for key, _ in ipairs(tbl) do
    table.insert(indexes, key)
  end
  return indexes
end

function utils.bind(func, ...)
  local boundArgs = { ... }

  return function(...)
    return func(utils.unpack(boundArgs), ...)
  end
end

function utils.ifilter(tbl, pred_fn)
  return utils.ireduce(tbl, function(new_tbl, value, index)
    if pred_fn(value, index) then
      table.insert(new_tbl, value)
    end
    return new_tbl
  end, {})
end

function utils.ireject(tbl, pred_fn)
  return utils.ifilter(tbl, function(value, index)
    return not pred_fn(value, index)
  end)
end

function utils.kfilter(tbl, pred_fn)
  return utils.kreduce(tbl, function(new_tbl, value, key)
    if pred_fn(value, key) then
      new_tbl[key] = value
    end
    return new_tbl
  end, {})
end

function utils.kreject(tbl, pred_fn)
  return utils.kfilter(tbl, function(value, index)
    return not pred_fn(value, index)
  end)
end

function utils.switch(param, t)
  local case = t[param]
  if case then
    return case()
  end
  local defaultFn = t["default"]
  return defaultFn and defaultFn() or nil
end

function utils.trim(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

function utils.ignore() end

function utils.always(value)
  return function()
    return value
  end
end

function utils.identity(value)
  return value
end

function utils.debounce(fn, ms)
  local timer = vim.loop.new_timer()

  local function wrapped_fn(...)
    local args = { ... }
    timer:stop()
    timer:start(ms, 0, function()
      pcall(
        vim.schedule_wrap(function(...)
          fn(...)
          timer:stop()
        end),
        select(1, utils.unpack(args))
      )
    end)
  end
  return wrapped_fn, timer
end

utils.pack = table.pack or function(...)
  return { n = select("#", ...), ... }
end

---@diagnostic disable-next-line: deprecated
utils.unpack = table.unpack or unpack

function utils.eq(x, y)
  return x == y
end

function utils.constant(x)
  return function()
    return x
  end
end

function utils.clamp(value, min, max)
  return math.min(math.max(value, min), max)
end

function utils.isa(object, class)
  local mt = getmetatable(object)

  if mt and object then
    return type(object) == "table" and mt.__index == class
  end

  return false
end

function utils.default_to(value, default_value)
  return vim.F.if_nil(value, default_value)
end

function utils.merge(fst, snd)
  return vim.tbl_extend("force", fst, snd)
end

function utils.deep_merge(fst, snd)
  return vim.tbl_deep_extend("force", fst, snd)
end

function utils.preserve_cursor_position(fn)
  local line, col = utils.unpack(vim.api.nvim_win_get_cursor(0))

  fn()

  vim.schedule(function()
    local lastline = vim.fn.line("$")

    if line > lastline then
      line = lastline
    end

    vim.api.nvim_win_set_cursor(0, { line, col })
  end)
end

function utils.log(...)
  local is_fidget_installed, fidget = pcall(require, "fidget")
  local debug_value = vim.inspect({ ... })

  if is_fidget_installed then
    return fidget.notify(debug_value)
  end

  vim.notify(debug_value)
end

vim.g.genui = function()
  local Text = require("nui.text")
  local n = require("nui-components")
  
  local fn = utils
  local gen = require("gen")
  
  local M = {}
  if M.renderer then
    return M.renderer:focus()
  end

  local register = vim.fn.getreg('"')
  local diags = vim.lsp.diagnostic.get_line_diagnostics()

  local default_signal_value = {
    selected_option = "chat",
    select_size = 8,
    chat = "",
    question = "",
    text = register,
    code = register,
    diags = diags,
    preview_content = "",
    issue = table.concat(
      fn.ireduce(diags, function(acc, diag)
        fn.ieach(vim.split(diag.message, "\n"), function(message)
          table.insert(acc, fn.trim(message))
        end)
        return acc
      end, {}),
      "\n"
    ),
    is_preview_visible = false,
  }
  local default_size = {
    width = 80,
    height = 40,
  }

  if M.last_signal_value then
    M.last_signal_value.text = default_signal_value.text
    M.last_signal_value.code = default_signal_value.code
    M.last_signal_value.diags = default_signal_value.diags
    M.last_signal_value.issue = default_signal_value.issue
  end

  local renderer = n.create_renderer(M.last_renderer_size or default_size)

  local signal = n.create_signal(M.last_signal_value or default_signal_value)

  renderer:add_mappings({
    {
      mode = { "n", "i" },
      key = "<leader>c",
      handler = function()
        renderer:close()
      end,
    },
    {
      mode = { "n", "i" },
      key = "<C-g>",
      handler = function()
        local state = signal:get_value()

        local prompt = fn.switch(state.selected_option, {
          ["chat"] = function()
            return state.chat
          end,
          ["ask"] = function()
            return "Regarding the following text:\n" .. state.text .. "\n" .. state.question
          end,
          ["enhance-grammar"] = function()
            return "Modify the following text to improve grammar and spelling, just output the final text in English without additional quotes around it:\n"
              .. state.text
          end,
          ["enhance-wording"] = function()
            return "Modify the following text to use better wording, just output the final text without additional quotes around it:\n"
              .. state.text
          end,
          ["make-concise"] = function()
            return "Modify the following text to make it as simple and concise as possible, just output the final text without additional quotes around it:\n"
              .. state.text
          end,
          ["generate-simple-description"] = function()
            return "Provide a simple and concise description of the following code:\n" .. state.code
          end,
          ["generate-detailed-description"] = function()
            return "Provide a detailed description of the following code:\n" .. state.code
          end,
          ["suggest-better-naming"] = function()
            return "Take all variable and function names, and provide only a list with suggestions with improved naming:\n"
              .. state.code
          end,
          ["review-code"] = function()
            return "Review the following code and make concise suggestions, only output the result in format:\n```"
              .. vim.bo.filetype
              .. "\n"
              .. state.code
              .. "\n```"
          end,
          ["simplify-code"] = function()
            return "Simplify the following code, only output the result in format:\n```"
              .. vim.bo.filetype
              .. "\n"
              .. state.code
              .. "\n```"
          end,
          ["improve-code"] = function()
            return "Improve the following code, only output the result in format:\n```"
              .. vim.bo.filetype
              .. "\n"
              .. state.code
              .. "\n```"
          end,
          ["issue"] = function()
            local content = table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false), "\n")

            return "Provide more a simple and concise insight about the following issue, try to fix it\n"
              .. state.issue
              .. "\nin the following code\n```"
              .. vim.bo.filetype
              .. "\n"
              .. content
              .. "\n```"
          end,
        })

        renderer:set_size({ width = 140 })
        signal.is_preview_visible = true

        renderer:schedule(function()
          local preview_component = renderer:get_component_by_id("preview")

          gen.float_win = preview_component.winid
          gen.result_buffer = preview_component.bufnr
          gen.exec({ prompt = prompt })
        end)
      end,
    },
  })

  renderer:on_unmount(function()
    local preview_component = renderer:get_component_by_id("preview")
    local content = preview_component:get_content()

    M.last_signal_value = signal:get_value()
    M.last_signal_value.preview_content = #content > 0 and content .. "\n\n---\n" or content
    M.last_renderer_size = renderer:get_size()
    M.renderer = nil
  end)

  M.renderer = renderer

  local data = {
    n.option("chit-chat", { id = "chat" }),
    n.option("ask regarding the following text/code", { id = "ask" }),
    n.separator("󰦨 text "),
    n.option("modify the following text to improve grammar and spelling", { id = "enhance-grammar" }),
    n.option("modify the following text to use better wording", { id = "enhance-wording" }),
    n.option("modify the following text to make it as simple and concise as possible", { id = "make-concise" }),
    n.separator("󰅪 code "),
    n.option("generate a simple and concise description of the following code", { id = "generate-simple-description" }),
    n.option("generate a detailed description of the following code", { id = "generate-detailed-description" }),
    n.option("use better names for all provided variables and functions", { id = "suggest-better-naming" }),
    n.option("review the following code and make concise suggestions", { id = "review-code" }),
    n.option("simplify the following code", { id = "simplify-code" }),
    n.option("improve the following code", { id = "improve-code" }),
  }

  if #diags > 0 then
    table.insert(data, 3, n.option("learn more about the following issue", { id = "issue" }))
  end

  local is_preview_hidden = signal.is_preview_visible:map(function(value)
    return not value
  end)

  local body = n.rows(
    n.columns(
      n.rows(
        { flex = 1 },
        n.select({
          id = "type",
          size = signal.select_size,
          autofocus = true,
          border_label = "Hey, Ollama, I'd like to…",
          data = data,
          selected = signal.selected_option,
          on_select = function(node)
            signal.selected_option = node.id
          end,
          on_blur = function()
            signal.select_size = 1
          end,
          on_focus = function()
            signal.select_size = 8
          end,
        }),
        n.text_input({
          flex = 1,
          border_label = {
            text = "Issue",
            icon = "",
          },
          wrap = true,
          value = signal.issue,
          on_change = function(value)
            signal.issue = value
          end,
          hidden = signal.selected_option:map(function(value)
            return #diags == 0 or not (value == "issue")
          end),
        }),
        n.text_input({
          flex = 1,
          id = "chat",
          border_label = {
            text = "Chat",
            icon = "󰭻",
          },
          value = signal.chat,
          on_change = function(value)
            signal.chat = value
          end,
          wrap = true,
          hidden = signal.selected_option:map(function(value)
            return not (value == "chat")
          end),
        }),
        n.text_input({
          flex = 1,
          id = "question",
          border_label = {
            text = "Question",
            icon = "",
          },
          value = signal.question,
          on_change = function(value)
            signal.question = value
          end,
          wrap = true,
          hidden = signal.selected_option:map(function(value)
            return not (value == "ask")
          end),
        }),
        n.text_input({
          flex = 2,
          id = "text",
          border_label = {
            text = "Text",
            icon = "󰦨",
          },
          value = signal.text,
          on_change = function(value)
            signal.text = value
          end,
          wrap = true,
          hidden = signal.selected_option:map(function(value)
            return not fn.isome({
              "ask",
              "enhance-grammar",
              "enhance-wording",
              "make-concise",
            }, function(key)
              return key == value
            end)
          end),
        }),
        n.text_input({
          flex = 1,
          id = "code",
          border_label = {
            text = "Code",
            icon = "",
          },
          value = signal.code,
          on_change = function(value)
            signal.code = value
          end,
          filetype = vim.bo.filetype,
          hidden = signal.selected_option:map(function(value)
            return not fn.isome({
              "generate-simple-description",
              "generate-detailed-description",
              "suggest-better-naming",
              "review-code",
              "simplify-code",
              "improve-code",
            }, function(key)
              return key == value
            end)
          end),
        })
      ),
      n.paragraph({
        id = "preview",
        lines = signal.preview_content,
        flex = 2,
        border_label = {
          text = Text("Preview", "NuiComponentsBorderLabel"),
          icon = "",
          align = "center",
        },
        border_style = "rounded",
        hidden = is_preview_hidden,
      })
    ),
    n.columns(
      {
        flex = 0,
        hidden = is_preview_hidden,
      },
      n.gap({ flex = 1 }),
      n.button({
        label = "Reset",
        border_style = "none",
        on_press = function()
          local type_component = renderer:get_component_by_id("type")
          local preview_component = renderer:get_component_by_id("preview")

          preview_component:clear()
          type_component:focus()

          signal:set_value(default_signal_value)
          renderer:set_size(default_size)

          gen.float_win = nil
          gen.result_buffer = nil
        end,
      }),
      n.gap(1),
      n.button({
        label = "Clear",
        border_style = "none",
        on_press = function()
          local preview_component = renderer:get_component_by_id("preview")
          preview_component:clear()
        end,
      })
    )
  )

  renderer:render(body)
end
