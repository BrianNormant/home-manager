-- Inspiration from
-- https://www.reddit.com/r/neovim/comments/1jxgcml/convert_code_to_image_while_preserving_neovim/



vim.api.nvim_create_autocmd("Colorscheme", {
	pattern = "*",
	callback = function(_)
		local snippets_opts = {
			font = "FiraCode Nerd Font Mono Ret",
			size = 20,
			zoom = 3,
			width = 75,
			fg_color       = vim.api.nvim_get_hl(0, { name = "Normal"}).fg,
			bg_color_dark  = vim.api.nvim_get_hl(0, { name = "Normal"}).bg,
			bg_color_light = vim.api.nvim_get_hl(0, { name = "Visual"}).bg,
		}
		local snippets_context_css = string.format([[
		* {
			font-family: '%s';
			font-size: %dpx;
		}
		body {
			margin: 0;
			color: #%06x;
		}
		.container {
			background-color: #%06x;
			padding: 3rem;
		}
		pre {
			background-color: #%06x;
			border-radius: 0.5rem;
			padding: 1rem 1rem 0 1rem;
		}
		]], snippets_opts.font,
			snippets_opts.size,
			snippets_opts.bg_color_light, snippets_opts.bg_color_light,
			snippets_opts.bg_color_dark)

		_G.snippets = function(range)
			local html_opts = {
				range = range,
				number_lines = true,
			}
			require("ibl").update { enabled = false } -- ibl breaks file with tabs
			vim.o.list = false

			local html = require("tohtml").tohtml(0, html_opts)

			require("ibl").update { enabled = true } -- ibl breaks file with tabs
			vim.o.list = true


			local text = {}
			local has_edited_font = false
			local has_edited_body = false
			local has_edited_cw = false

			for _, line in ipairs(html) do
				if line:match("^%* {.*}$") ~= nil and not has_edited_font then
					has_edited_font = true
					goto continue
				end
				if line:match("^body {.*}$") ~= nil and not has_edited_body then
					has_edited_body = true
					goto continue
				end
				-- This is to remove highligthing from current word
				-- or lsp documents highlight
				if not has_edited_cw and line:match("^%.CurrentWord {.*}$") ~= nil then
					has_edited_cw = true
					goto continue
				end
				if line:match("^%s*<pre>") ~= nil then
					table.insert(text, "<div class='container'><pre>")
					goto continue
				end

				table.insert(text, line)

				if line:match("<style>") ~= nil then
					for l in string.gmatch(snippets_context_css, "[^\n]+") do
						table.insert(text, l)
					end
				end
				if line:match("^</pre>") ~= nil then
					table.insert(text, "</div>")
				end
				::continue::
			end

			-- vim.cmd "tabnew"
			-- local bufnr = vim.api.nvim_create_buf(false, true)
			-- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, text)
			-- vim.api.nvim_win_set_buf(0, bufnr)

			local out = vim.system({
				"wkhtmltoimage",
				"--disable-smart-width",
				"--zoom",
				string.format("%d", snippets_opts.zoom),
				"--width",
				string.format("%d", snippets_opts.zoom * snippets_opts.size * snippets_opts.width),
				"-",
				"-",
			}, { stdin = text }):wait()
			if out.code ~= 0 then
				vim.notify("Failed to generate snippets", vim.log.levels.ERROR)
			end
			vim.system({"wl-copy", "-t", "image/png"}, { stdin = out.stdout }, function(obj)
				if obj.code ~= 0 then
					vim.notify("Failed to put snippets into clipboard", vim.log.levels.ERROR)
				else
					vim.notify("Copied snippets to clipboard", vim.log.levels.INFO)
				end
			end)

		end

		_G.visual_snippets = function()
			local range = {
				vim.fn.getpos("v")[2],
				vim.fn.getpos(".")[2],
			}
			local l1 = math.min(range[1], range[2])
			local l2 = math.max(range[1], range[2])
			_G.snippets { l1, l2 }
		end

		_G.window_snippets = function()
			_G.snippets {
				vim.fn.getpos("w0")[2],
				vim.fn.getpos("w$")[2],
			}
		end

		vim.keymap.set("n", "<leader>W", _G.snippets,        {desc = "Create a Snippets of the window view"})
		vim.keymap.set("n", "<leader>w", _G.window_snippets, {desc = "Create a Snippets of the whole file"})
		vim.keymap.set("v", "<leader>w", _G.visual_snippets, {desc = "Create a Snippets of the visual selection"})
	end
})
