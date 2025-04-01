function(virtText, lnum, endLnum, width, truncate, ctx)
	-- include the bottom line in folded text for additional context
	local filling = "   "
	local final_text = vim.trim(vim.api.nvim_buf_get_text(0, endLnum-1, 0, endLnum-1, -1, {})[1])
	local suffix = final_text:format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	table.insert(virtText, {filling, 'Folded'})
	local endVirtText = ctx.get_fold_virt_text(endLnum)
	for i, chunk in ipairs(endVirtText) do
		local chunkText = chunk[1]
		local hlGroup = chunk[2]
		if i == 1 then
			chunkText = chunkText:gsub("^%s+", "")
		end
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(virtText, {chunkText, hlGroup})
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			table.insert(virtText, {chunkText, hlGroup})
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	return virtText
end
