local init = function(...)
--------------------------------
local fileTree = ui.classes.List:new({
	x = 0, y = 0.2, w = 0.3, h = 0.6, layer = 2,
	showingItemsCount = 6,
	items = {}
})
fileTree.backWay = {}
fileTree.genItems = function(path)
	local items = {}
	
	fileTreeCache:update(fileTreeCacheRules)
	for filePath, object in pairs(fileTreeCache.list) do
		if love.filesystem.isDirectory(filePath)
			and (string.sub(filePath, 1, string.len(path)) == path)
			and not string.find(string.sub(filePath, string.len(path) + 1, -1), "/") then
			table.insert(items, {
				title = object.title,
				action = function()
					table.insert(fileTree.backWay, fileTreeCacheRules.path)
					fileTreeCacheRules.path = filePath .. "/"
					fileTree.items = fileTree.genItems(filePath .. "/")
					fileTree:reload()
				end
			})
		elseif love.filesystem.isFile(filePath)
			and (string.sub(filePath, 1, string.len(path)) == path)
			and not string.find(string.sub(filePath, string.len(path) + 1, -1), "/") then
			if not mapCache.list[filePath] then
				mapCache:addObject(filePath, mapCacheCallback(filePath))
				uiBase.mapList.list = uiBase.mapList:genList(mapCache.list)
				uiBase.mapList:reload()
			end
			table.insert(items, {
				title = object.title,
				action = function() end
			})
		end
	end
	table.insert(items, {
		title = "..",
		action = function()
			fileTreeCacheRules.path = fileTree.backWay[#fileTree.backWay] or fileTreeCacheRules.path
			fileTree.backWay[#fileTree.backWay] = nil
			fileTree.items = fileTree.genItems(fileTreeCacheRules.path)
			fileTree:reload()
		end
	})
	table.sort(items, function(a, b)
		return a.title < b.title
	end)
	
	return items
end

return fileTree
--------------------------------
end

return init