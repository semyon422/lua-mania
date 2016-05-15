local function getFilePath(filename, rules)
	local filePath = nil
	if not rules then
		rules = {
			formats = {"wav", "mp3", "ogg"},
			paths = {"res/skin/hitSounds"}
		}
	end
	
	for _, format in ipairs(rules.formats) do
		if string.sub(filename, -3, -1) == format then
			filename = string.sub(filename, 1, -4)
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
	return filePath
end

return getFilePath