local init = function(luaMania)
--------------------------------
local game = loveio.LoveioObject:new()

game.path = "luaMania/game/"
game.modes = {}
game.modes.vsrg = require(game.path .. "/modes/vsrg")(game, luaMania)
game.formats = {
	["bms"] = bms,
	["osu"] = osu
}

game.load = function()
	game.newGame = game.modes.vsrg:new():insert(loveio.objects)
	local cachedObject = luaMania.cache.data[luaMania.cache.position]
	local format = cachedObject.format
	game.newGame.map = game.formats[format].Beatmap:new():import(cachedObject.filePath)
	
	game.loaded = true
end
game.unload = function()
	if game.newGame then game.newGame:remove() end
end

return game
--------------------------------
end

return init