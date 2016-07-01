local game = {}

game.path = "luaMania/game/"
game.modes = {
	["vsrg"] = require(game.path .. "/modes/vsrg")(game)
}

game.import = require(game.path .. "import")(game)

game.update = function()
	if not game.loaded then
		local filePath = luaMania.cache.data[luaMania.cache.position].filePath
		game.map = game.import(filePath)
		game.mode = game.modes.vsrg
		game.loaded = true
	end
	game.mode.update(game.map)
	game.mode.draw(game.map)
end

return game