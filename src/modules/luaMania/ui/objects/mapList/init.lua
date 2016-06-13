local mapList = {}

mapList.data = {
	name = "mapList",
	buttonCount = 24,
	buttonKeys = {}
}
mapList.update = function(command)
	local data = mapList.data
	if command == "close" then
		for keyIndex, key in pairs(data.buttonKeys) do
			objects[key].update("close")
		end
		objects[data.name] = nil
		return
	end
	for button = 1, data.buttonCount do
		local map = luaMania.cache.data[luaMania.cache.position + button]
		if map ~= nil and not objects[data.name .. "button" .. button] then
			table.insert(data.buttonKeys, data.name .. "button" .. button)
			ui.classes.button:new({
				name = data.name .. "button" .. button, apply = true,
				x = 0.7, y = (button - 1) * (1 / (data.buttonCount + 1) + pos.Y2y(2)),
				w = 1, h = 1 / (data.buttonCount + 1),
				value = map.title .. " - " .. map.version,
				xAlign = "left",
				action = function()
					luaMania.cache.position = button
					objects.gameState.data.state = "game"
					objects.gameState.data.switched = false
				end
			})
		end
	end
	-- loveio.input.callbacks[data.name] = {
		-- keypressed = function(key)
			-- if key == "return" then
				-- objects.gameState.data.state = "game"
				-- objects.gameState.data.switched = false
			-- elseif key == "up" then
				-- if luaMania.cache.position < #luaMania.cache.data then
					-- luaMania.cache.position = luaMania.cache.position + 1
				-- end
			-- elseif key == "down" then
				-- if luaMania.cache.position >= 2 then
					-- luaMania.cache.position = luaMania.cache.position - 1
				-- end
			-- end
		-- end
	-- }
end

return mapList