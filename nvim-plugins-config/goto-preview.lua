local goto_preview = require('goto-preview')

local loaded = false
local lazyload = function ()
	if not loaded then
		goto_preview.setup {
			border = "rounded",
		}
		loaded = true
	end
end

local preview = {
	definition = function ()
		lazyload()
		goto_preview.goto_preview_definition()
	end,
	type_definition = function ()
		lazyload()
		goto_preview.goto_preview_type_definition()
	end,
	implementation = function ()
		lazyload()
		goto_preview.goto_preview_implementation()
	end,
	declaration = function ()
		lazyload()
		goto_preview.goto_preview_declaration()
	end,
	references = function ()
		lazyload()
		goto_preview.goto_preview_references()
	end,
	close = function()
		if loaded then
			goto_preview.close_all_win()
		end
	end
}


--- Keymaps
local legend = {
	keymaps = {
		{"gpd",  function()  preview.definition()       end, description="LSP preview definition"},
		{"gpt",  function()  preview.type_definition()  end, description="LSP preview type definition"  },
		{"gpi",  function()  preview.implementation()   end, description="LSP preview implementation"  },
		{"gpD",  function()  preview.declaration()      end, description="LSP preview declaration"  },
		{"gpr",  function()  preview.references()       end, description="LSP preview references"  },
		{"gP",   function()  preview.close()                 end, description="LSP preview window"  },
	},
}
_G.LEGEND_append(legend)
