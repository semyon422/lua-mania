game = {}

-- require("game.gameState")
require("game.backgroundManager")
background = game.backgroundManager.Background:new({
	drawable = love.graphics.newImage("res/background.jpg")
})
background:activate()

-- game.modes = {}
-- game.modes.vsrg = require(game.path .. "/modes/vsrg")(game)
-- game.modes.lmx = require(game.path .. "/modes/lmx")(game)
-- game.modes.lmp = require(game.path .. "/modes/lmp")(game)
-- game.formats = {
	-- ["bms"] = bms,
	-- ["osu"] = osu,
	-- ["lmx"] = lmx,
	-- ["lmp"] = lmp,
	-- ["lmn"] = lmn
-- }
-- game.load = function()
	-- local object = game.object
	-- local format = object.format
	-- local mode = object.mode
	-- game.newGame = game.modes[mode]:new():insert(loveio.objects)
	-- game.newGame.map = game.formats[format].Beatmap:new():import(object.filePath)
	
	-- game.loaded = true
-- end
-- game.unload = function()
	-- if game.newGame then game.newGame:remove() end
-- end
