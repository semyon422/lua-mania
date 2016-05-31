local mapList = {}

mapList.data = {
	name = "mapList",
	buttonCount = 16
}
mapList.update = function(command)
	local data = mapList.data
	if command == "close" then
		objects[data.name] = nil
		return
	end
	for button = 0, data.buttonCount do
		local position = luaMania.cache.position + button
		if luaMania.cache.data[position] ~= nil then
			loveio.output.objects[data.name .. "button" .. button] = {
				class = "rectangle",
				x = 2 * love.graphics.getWidth() / 3, y = 0 + button * (love.graphics.getHeight() / (data.buttonCount + 1)),
				w = love.graphics.getWidth() / 3, h = love.graphics.getHeight() / (data.buttonCount + 1),
				layer = 3,
				mode = "line"
			}
			loveio.output.objects[data.name .. "text" .. button] = {
				class = "text",
				x = 2 * love.graphics.getWidth() / 3, y = 0 + button * (love.graphics.getHeight() / (data.buttonCount + 1)),
				layer = 3,
				text = luaMania.cache.data[position].version
			}
		end
	end
	loveio.input.callbacks[data.name] = {
		keypressed = function(key)
			if key == "return" then
				objects.gameState.data.state = "game"
				objects.gameState.data.switched = false
			elseif key == "up" then
				if luaMania.cache.position < #luaMania.cache.data then
					luaMania.cache.position = luaMania.cache.position + 1
				end
			elseif key == "down" then
				if luaMania.cache.position >= 2 then
					luaMania.cache.position = luaMania.cache.position - 1
				end
			end
		end
	}
end

return mapList