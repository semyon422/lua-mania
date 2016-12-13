local init = function()
--------------------------------
local game = loveio.LoveioObject:new()

game.path = "game/"

game.gameState = require(game.path .. "gameState")(game)

game.modes = {}
game.modes.vsrg = require(game.path .. "/modes/vsrg")(game)
game.modes.lmx = require(game.path .. "/modes/lmx")(game)
game.formats = {
	["bms"] = bms,
	["osu"] = osu,
	["lmx"] = lmx
}
game.load = function()
	local object = game.object
	local format = object.format
	local mode = object.mode
	game.newGame = game.modes[mode]:new():insert(loveio.objects)
	game.newGame.map = game.formats[format].Beatmap:new():import(object.filePath)
	
	game.loaded = true
end
game.unload = function()
	if game.newGame then game.newGame:remove() end
end

return game
--------------------------------
end

return init
