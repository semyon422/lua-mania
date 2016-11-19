local init = function()
--------------------------------
local game = loveio.LoveioObject:new()

game.path = "game/"

game.gameState = require(game.path .. "gameState")(game)

game.cachePosition = 1

game.modes = {}
game.modes.vsrg = require(game.path .. "/modes/vsrg")(game)
game.modes.lmx = require(game.path .. "/modes/lmx")(game)
game.formats = {
	["bms"] = bms,
	["osu"] = osu,
	["lmx"] = lmx
}
game.load = function()
	local cachedObject = mainCache[game.cachePosition]
	local format = cachedObject.format
	local mode = cachedObject.mode
	game.newGame = game.modes[mode]:new():insert(loveio.objects)
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