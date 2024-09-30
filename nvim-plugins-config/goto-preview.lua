require('goto-preview').setup {}

--- Keymaps
local legend = {
	keymaps = {
		{"gpd",  function()  require('goto-preview').goto_preview_definition()       end, description="LSP preview definition"},
		{"gpt",  function()  require('goto-preview').goto_preview_type_definition()  end, description="LSP preview type definition"  },
		{"gpi",  function()  require('goto-preview').goto_preview_implementation()   end, description="LSP preview implementation"  },
		{"gpD",  function()  require('goto-preview').goto_preview_declaration()      end, description="LSP preview declaration"  },
		{"gpr",  function()  require('goto-preview').goto_preview_references()       end, description="LSP preview references"  },
		{"gP",   function()  require('goto-preview').close_all_win()                 end, description="LSP preview window"  },
	},
}
_G.LEGEND_append(legend)
