local init = function(luaMania)
--------------------------------
local game = loveio.LoveioObject:new()

game.path = "luaMania/game/"
game.modes = {}
game.modes.vsrg = require(game.path .. "/modes/vsrg")(game, luaMania)

game.load = function()
	local filePath = luaMania.cache.data[luaMania.cache.position].filePath
	game.map = osu.beatmap:new():import(filePath)
	game.mode = game.modes.vsrg
	game.mode.removeAll = false
	game.mode:load()
	game.loaded = true
end

game.update = function()
	game.mode.update()
	game.mode.draw()
end
game.unload = function()
	if game.mode then game.mode:unload() end
end
game.remove = function()
	if game.mode then game.mode:remove() end
end

return game
--------------------------------
end

return init