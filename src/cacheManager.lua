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
	local cacheManagerdObjects = {}
	
	local rules = rules or {}
	local path = rules.path or "."
	local sort = rules.sort
	local callback = rules.callback or function(filePath) return {filePath = filePath} end
	
	local list = cacheManager.lookup(path)
	for _, filePath in pairs(list) do
		local cacheManagerdObject = callback(filePath)
		if cacheManagerdObject then
			table.insert(cacheManagerdObjects, cacheManagerdObject)
		end
	end
	if sort then table.sort(cacheManagerdObjects, sort) end
	
	return cacheManagerdObjects
end

cacheManager.save = function(cacheManagerdObjects, filePath)

end

cacheManager.load = function(filePath)

end

return cacheManager
