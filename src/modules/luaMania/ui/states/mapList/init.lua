--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local mapList = {}

mapList.update = function()
	local buttons = {}
		for i = 1, #luaMania.data.cache do
			if i == luaMania.state.cachePosition then
				table.insert(buttons, {objects = {
						[2] = {{
								class = "text",
								align = "left",
								text = luaMania.data.cache[i].title .. " - " .. luaMania.data.cache[i].version,
								color = {223, 196, 125}
							}}}})
			else
				table.insert(buttons, {objects = {
						[2] = {{
								class = "text",
								align = "left",
								y = 100,
								text = luaMania.data.cache[i].title,
								color = {223, 196, 125}
							}}}})
			end
		end
	
	for buttonIndex, button in pairs(buttons) do
		for layerIndex, layer in pairs(button.objects) do
			for objectIndex, object in pairs(layer) do
				luaMania.graphics.objects[layerIndex] = luaMania.graphics.objects[layerIndex] or {}
				table.insert(luaMania.graphics.objects[layerIndex], object)
			end
		end
	end
	luaMania.graphics.objects[1] = luaMania.graphics.objects[1] or {}
	table.insert(luaMania.graphics.objects[1], {
		class = "rectangle",
		w = love.graphics.getWidth(),
		h = love.graphics.getHeight(),
		color = {47, 47, 47}})

	table.insert(luaMania.keyboard.events,
	{
		keys = {"return"},
		actionHit = function()
			if luaMania.ui.state == "mapList" then
				luaMania.ui.state = "playing"
			elseif luaMania.ui.state == "mainMenu" then
				luaMania.ui.state = "mapList"
			end
		end
	})
	table.insert(luaMania.keyboard.events,
	{
		keys = {"up"},
		actionHit = function()
			if luaMania.ui.state == "mapList" then
				if luaMania.state.cachePosition < #luaMania.data.cache then
					luaMania.state.cachePosition = luaMania.state.cachePosition + 1
				end
			end
		end
	})
	table.insert(luaMania.keyboard.events,
	{
		keys = {"down"},
		actionHit = function()
			if luaMania.ui.state == "mapList" then
				if luaMania.state.cachePosition > 1 then
					luaMania.state.cachePosition = luaMania.state.cachePosition - 1
				end
			end
		end
	})
end

return mapList
