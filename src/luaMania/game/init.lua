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
	local newGame = game.modes.vsrg:new({
		name = "newGame",
		insert = {table = objects, onCreate = true}
	})
	local cachedObject = luaMania.cache.data[luaMania.cache.position]
	local format = cachedObject.format
	newGame.map = game.formats[format].Beatmap:new():import(cachedObject.filePath)
	
	game.loaded = true
end
game.unload = function()
	if objects.newGame then objects.newGame:unload() end
end

return game
--------------------------------
end

return init