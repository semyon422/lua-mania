local function getFilePath(filename, rules)
	if not rules then return end
	
	local filename = trim(filename)
	local filePath = nil
	
	for _, format in ipairs(rules.formats) do
		if string.sub(filename, -4, -1) == "." .. format then
			filename = string.sub(filename, 1, -5)
			break
		end
	end
	
	for _, path in ipairs(rules.paths) do
		local continue = false
		for _, format in ipairs(rules.formats) do
			local tempFilePath = path .. "/" .. filename .. "." .. format
			if love.filesystem.exists(tempFilePath) then
				filePath = tempFilePath
				continue = true
				break
			end
		end
		if continue then break end
	end
	
	if not filePath then
		if rules.default then
			return rules.default
		end
	end
	return filePath
end

return getFilePath
