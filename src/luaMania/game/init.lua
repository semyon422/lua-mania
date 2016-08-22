local init = function(luaMania)
--------------------------------
local game = loveio.LoveioObject:new()

game.path = "luaMania/game/"
game.modes = {}
game.modes.vsrg = require(game.path .. "/modes/vsrg")(game, luaMania)

game.load = function()
	local newGame = game.modes.vsrg:new({
		name = "newGame",
		insert = {table = objects, onCreate = true}
	})
	newGame.map = osu.beatmap:new():import(luaMania.cache.data[luaMania.cache.position].filePath)
	newGame.map:set("CircleSize", math.ceil(newGame.map:get("CircleSize")))
	
	game.loaded = true
end
game.unload = function()
	if objects.newGame then objects.newGame:unload() end
end

return game
--------------------------------
end

return init