local cache = {}

cache.lookup = function(path, list)
	local list = list or {}
	for _, filaName in pairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.isDirectory(path .. filaName) then
			cache.lookup(path .. filaName .. "/", list)
		elseif love.filesystem.isFile(path .. filaName) then
			table.insert(list, path .. filaName)
		end
	end
	return list
end
	
cache.generate = function(rules)
	local cachedObjects = {}
	
	local rules = rules or {}
	local path = rules.path or "."
	local sort = rules.sort
	local callback = rules.callback or function(filePath) return {filePath = filePath} end
	
	local list = cache.lookup(path)
	for _, filePath in pairs(list) do
		local cachedObject = callback(filePath)
		if cachedObject then
			table.insert(cachedObjects, cachedObject)
		end
	end
	if sort then table.sort(cachedObjects, sort) end
	
	return cachedObjects
end

cache.save = function(cachedObjects, filePath)

end

cache.load = function(filePath)

end

return cache
