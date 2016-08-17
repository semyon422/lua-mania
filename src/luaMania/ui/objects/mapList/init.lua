local mapList = ui.classes.List:new({
	name = "mapList",
	x = 0.5,
	y = 0.05,
	w = 0.45,
	h = 0.9,
	xAlign = "left",
	showingItemsCount = 12,
	items = {},
	insert = {table = objects, onCreate = false}
})

mapList.reload = function(self)
	self:unload()
	
	for cacheIndex, cacheItem in pairs(luaMania.cache.data) do
		self.items[cacheIndex] = {
			title = cacheItem.title .. " - " .. cacheItem.version,
			action = function()
				luaMania.cache.position = cacheIndex
				objects.gameState.data.state = "game"
				objects.gameState.data.switched = false
			end
		}
	end
	self:load()
end

return mapList