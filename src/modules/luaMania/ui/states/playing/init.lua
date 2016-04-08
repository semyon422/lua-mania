--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local playing = {}

playing.update = function()
	if not luaMania.modes[luaMania.modes.current].isLoaded then
		luaMania.modes[luaMania.modes.current].isLoaded = true
		luaMania.modes[luaMania.modes.current].load()
	end
	luaMania.modes[luaMania.modes.current].getObjects()
	
	luaMania.graphics.objects[1] = luaMania.graphics.objects[1] or {}
	table.insert(luaMania.graphics.objects[1], {
		class = "rectangle",
		w = love.graphics.getWidth(),
		h = love.graphics.getHeight(),
		color = {47, 47, 47}})
	table.insert(luaMania.graphics.objects[3], {
		class = "text",
		x = 0,
		y = 0,
		text = love.timer.getFPS()
	})
end

return playing
