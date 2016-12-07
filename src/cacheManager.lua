local cacheManager = {}

cacheManager.lookup = function(path, list)
	local list = list or {}
	for _, filaName in pairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.isDirectory(path .. filaName) then
			cacheManager.lookup(path .. filaName .. "/", list)
		elseif love.filesystem.isFile(path .. filaName) then
			table.insert(list, path .. filaName)
		end
	end
	return list
end
	
cacheManager.generate = function(rules)
	local objects = {}
	
	local rules = rules or {}
	local path = rules.path or "."
	local sort = rules.sort
	local callback = rules.callback or function(filePath) return {filePath = filePath} end
	
	local list = cacheManager.lookup(path)
	for _, filePath in pairs(list) do
		local object = callback(filePath)
		if object then
			object.type = "cacheItem"
			table.insert(objects, object)
		end
	end
	if sort then table.sort(objects, sort) end
	
	return objects
end

cacheManager.save = function(objects, filePath)
	local file = io.open(filePath, "w")
	
	file:write("local cache = {}\n")
	for index, object in ipairs(objects) do
		file:write("cache[#cache + 1] = {")
		for key, value in pairs(object) do
			if type(value) == "string" or type(value) == "number" then
				file:write(key .. " = " .. string.format("%q", value) .. ", ")
			end
		end
		file:write("}\n")
	end
	file:write("return cache")
end

cacheManager.load = function(filePath)
	local status, cache = pcall(loadfile(filePath))

	if status then
		return cache or {}
	else
		return {}
	end
end

return cacheManager
