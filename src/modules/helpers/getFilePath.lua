local function getFilePath(filename, rules)
	local filePath = nil
	
	local rules = rules or {
		formats = {"wav", "mp3", "ogg"},
		paths = {"res/skin/hitSounds"},
		--default = "res/default"
	}
	
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
	
	if not filePath then print("file " .. filename .. " not found!") end
	--if not filePath then filePath = rules.default end
	return filePath
end

return getFilePath