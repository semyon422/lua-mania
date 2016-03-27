--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local playing = {}

playing.load = function(position)
	luaMania.state.map = luaMania.games.osu.beatmap.import(luaMania.data.cache[luaMania.state.cachePosition].pathFile)
end
playing.isLoaded = false

playing.update = function()
	luaMania.state.cachePosition = 1
	if not playing.isLoaded then
		playing.isLoaded = true
		playing.load(luaMania.state.cachePosition)
		luaMania.modes[luaMania.modes.current].convert()
	end
	luaMania.modes[luaMania.modes.current].getObjects()
	
	luaMania.graphics.objects[1] = luaMania.graphics.objects[1] or {}
	table.insert(luaMania.graphics.objects[1], {
		class = "rectangle",
		w = love.graphics.getWidth(),
		h = love.graphics.getHeight(),
		color = {47, 47, 47}})
end

return playing
