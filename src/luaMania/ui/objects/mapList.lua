local mapList = ui.classes.List:new({
	x = 0.5,
	y = 0.05,
	w = 0.45,
	h = 0.9,
	xAlign = "left",
	xPadding = 0.9 / 12 / 4,
	showingItemsCount = 12,
	items = {},
	scrollDirection = -1,
	backgroundColor = {255, 255, 255, 31}
})

mapList.reload = function(self)
	self:unload()
	
	for cacheIndex, cacheItem in pairs(luaMania.cache.data) do
		self.items[cacheIndex] = {
			title = cacheItem.title .. " - " .. cacheItem.version,
			action = function()
				luaMania.cache.position = cacheIndex
				luaMania.cli:run("gameState set game")
			end
		}
	end
	self:load()
end

return mapList