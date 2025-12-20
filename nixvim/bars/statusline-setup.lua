-- center text with padding on both sides
local function center(text, padding, width)
	local cnt = math.floor((width - #text) / 2)
	local r = string.rep(padding, cnt)
		.. text
		.. string.rep(padding, cnt)
	if #r == width - 1 then
		return r .. padding
	else
		return r
	end
end

vim.cmd [[
	highlight! StatusNormal    guifg=#ECE1D7
	highlight! StatusBold      guifg=#ECE1D7 gui=bold
	highlight! StatusItalic    guifg=#ECE1D7 gui=italic
	highlight! StatusGray      guifg=#a39482 gui=bold
	highlight! StatusViolet    guifg=#C594B8
	highlight! StatusRed       guifg=#E06C75
	highlight! StatusRedBold   guifg=#E06C75 gui=bold
	highlight! StatusRedItalic guifg=#E06C75 gui=italic
	highlight! StatusYellow    guifg=#EBC06D gui=bold
	highlight! StatusGreen     guifg=#78997A gui=bold
	highlight! StatusOrange    guifg=#E49B5D
	highlight! StatusBlue      guifg=#7C8EC0
]]

local mk_mode = function(name, hl, icon)
	return {
		padding_right = " ",
		padding_left = " ",
		text = center(name, " ", 18),
		hl = hl,
		icon = icon,
	}
end

---@diagnostic disable-next-line: undefined-global
statusline.setup {
	default = {
		components = {
			{
				kind = "mode",
				["^n$"] = mk_mode("NORMAL", "StatusGray", "  "),
				-- Normal Operator Pending
				["^no$"]   = mk_mode("OPERATOR", "StatusViolet", "𝛌  "),
				["^nov$"]  = mk_mode("OPERATOR_Char", "StatusViolet", "𝛌 󰀫"), -- force movement to be charwise
				["^noV$"]  = mk_mode("OPERATOR_Line", "StatusViolet", "𝛌 "), -- force movement to be linewise
				["^no$"] = mk_mode("OPERATOR_Block", "StatusViolet", "𝛌 󰒉"), -- force movement to be block wise
				-- Insert
				["^i$"]  = mk_mode("INSERT", "StatusNormal", " 󰗧 "),
				["^ix$"] = mk_mode("INS-COMPL", "StatusItalic", " 󰓭 "),
				["^ic$"] = mk_mode("INS-OMNICOMP", "StatusBold", " 󰧑 "),
				-- Replace
				["^R$"]  = mk_mode("REPLACE", "StatusRed", " ⎵ "),
				["^Rx$"] = mk_mode("REPLACE-COMPL", "StatusRedItalic", " 󰓭 "),
				["^Rc$"] = mk_mode("REPLACE-OMNICOMP", "StatusRedBold", " 󰧑 "),
				-- Virtual Replace
				["^Rv$"]  = mk_mode("v_REPLACE", "StatusRed", " ⎵ "),
				["^Rvx$"] = mk_mode("v_REPLACE-COMPL", "StatusRedItalic", " 󰓭 "),
				["^Rvc$"] = mk_mode("v_REPLACE-OMNICOMP", "StatusRedBold", " 󰧑 "),
				-- Visual
				["^v$"]  = mk_mode("VISUAL", "StatusYellow", "  "),
				["^V$"]  = mk_mode("VISUAL_Line", "StatusYellow", " "),
				["^$"] = mk_mode("VISUAL_Block", "StatusYellow", " 󰒉"),
				-- Select
				["^s$"]  = mk_mode("SELECT", "StatusGreen", " 󱩼 "),
				["^S$"]  = mk_mode("SELECT_Line", "StatusGreen", "󱩼 "),
				["^$"] = mk_mode("SELECT_Block", "StatusGreen", "󱩼 󰒉"),
				-- Terminal
				["^t$"]  = mk_mode("Insert-TERM", "StatusOrange", " 󰗧"),
				["^nt$"] = mk_mode("Normal-TERM", "StatusOrange", " "),
				-- Vim Command
				["^c$"]  = mk_mode("COMMAND", "StatusBlue", " "),
				-- Select One-Shot Visual (<C-o>)
				["^vs$"]  = mk_mode("V->SELECT", "StatusGreen", " 󱩼"),
				["^Vs$"]  = mk_mode("V_l->SELECT", "StatusGreen", "󱩼 "),
				["^s$"] = mk_mode("V_b->SELECT", "StatusGreen", "󱩼 󰒉"),
				-- One-Shot (<C-o>)
				["^niI$"] = mk_mode("N->INSERT", "StatusNormal", "󰗧 󰑘"),
				["^niR$"] = mk_mode("N->REPLACE", "StatusRed", "⎵ 󰑘"),
				["^niV$"] = mk_mode("N->v_REPLACE", "StatusRed", " 󰑘"),
				["^ntT$"] = mk_mode("N->TERMINAL", "StatusOrange", " 󰑘"),

				-- Others
				["!"]    = mk_mode("WAIT", "NvimInternalError", " 󰔟 "),
				["^r$"]  = mk_mode("Prompt", "StatusViolet", "  "),
				["^rm$"] = mk_mode("MORE", "StatusViolet", " 󰉸 "),
				["^r?$"] = mk_mode("CONFIRM", "StatusViolet", "y/n"),
			},
			{ kind = "section", hl = "StatusLine" },
			{
				kind = "custom",
				value = function()
					-- show the where in the file in % wee are
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					local total = vim.fn.line("$")
					local percent = math.floor(row / total * 100)
					return string.format("%3d %% : %d/%d", percent, row, total)
				end,
				hl = "StatusGray",
			},
			{ kind = "empty", hl = "StatusLine", },
			{
				kind = "custom",
				value = function()
					local ft = vim.bo.filetype
---@diagnostic disable-next-line: undefined-global
					local icon,_,_ = MiniIcons.get('filetype', ft)
					return icon
				end
			},
			{
				kind = "bufname",
				condition = function (_, win) return vim.api.nvim_win_get_width(win) >= 42 end,
				max_len = 25,
				default = {
					padding_left = " ",
					padding_right = " ",
					icon = " ",
					nomodifiable_icon = "󰌾 ",
				},
				["^$"] = {
					padding_left = " ",
					padding_right = " ",
					icon = " ",
					nomodifiable_icon = "󰌾 ",
					text = "[No Name]",
				},
			},
			{
				kind = "custom",
				value = function()
					if vim.v.hlsearch == 0 then
						return ' '
					end
					local sh = vim.fn.getreg('/')
					if sh ~= '' then
						return " (/" .. sh .. ") "
					else
						return " (noh)"
					end
				end,
			},
			{ kind = "empty", hl = "StatusLine", },
			{
				kind = "custom",

				condition = function (_, window)
					if window ~= vim.api.nvim_get_current_win() then
						return true;
					else
						return vim.api.nvim_win_get_width(window) > math.ceil(vim.o.columns * 0.5);
					end
				end,

				value = function (buffer)
					local clients = vim.lsp.get_clients({ bufnr = buffer });

					if #clients == 0 or vim.b[buffer].lsp_loader_state then
						return "";
					end

					local name_maps = {
						default = { icon = "󰒋 ", hl = "BarsFt0" },
						lua_ls = { icon = " ", name = "LuaLS", hl = "BarsFt5" },
						html = { icon = " ", name = "HTML", hl = "BarsFt2" },
						emmet_language_server = { icon = "󱡴 ", name = "Emmet", hl = "BarsFt4" },
					}
					local output = "";

					for c, client in ipairs(clients) do
						local name = client.name or "";

						if name_maps[name] then
							if name_maps[name].hl then
								output = output .. string.format("%%#%s#", name_maps[name].hl);
							end

							output = output .. (c > 1 and "" or " ").. name_maps[name].icon .. name_maps[name].name .. " ";
						else
							if name_maps.default.hl then
								output = output .. string.format("%%#%s#", name_maps.default.hl);
							end

							output = output .. (c > 1 and "" or " ") .. name_maps.default.icon .. name .. " ";
						end
					end

					return output;
				end
			},
			{
				kind = "custom",
				value = function()
					local r = ""
					if vim.env.TMUX then
						r = r .. "TMUX"
					end
					if vim.env.IN_NIX_SHELL and vim.env.IN_NIX_SHELL:match("impure") then
						if vim.env.PROJECT then
							r = r .. "|" .. vim.env.PROJECT
						else
							r = r .. "|IMPURE"
						end
					end
					if r ~= "" then
						return r
					else
						return vim.env.HOSTNAME
					end
				end
			}
		},
	},
}
