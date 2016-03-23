--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local playing = {}

playing.load = function()
	luaMania.map = luaMania.games[luaMania.games.current].beatmap.import(luaMania.data.cache[1].pathFile)
end
playing.isLoaded = false

playing.update = function()
	if not playing.isLoaded then
		playing.isLoaded = true
		playing.load()
	end
	luaMania.games[luaMania.games.current].getObjects()
	
	luaMania.graphics.objects[1] = luaMania.graphics.objects[1] or {}
	table.insert(luaMania.graphics.objects[1], {
		class = "rectangle",
		w = love.graphics.getWidth(),
		h = love.graphics.getHeight(),
		color = {47, 47, 47}})
end

return playing
