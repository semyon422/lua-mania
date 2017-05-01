require("lmfw")
require("rglib")
require("tweaks")

mainConfig = configManager.Config:new():load("config.txt")

mapCache = cacheManager.Cache:new():load("mapCache.lua")

loveio.init()

defaultPos = loveio.output.Position:new({
	ratios = {0.01, mainConfig:get("position.ratio", 4/3)}, resolutions = {{1, 1}, {1, 1}}
})

uiBase = require("uiBase")()

mainCli = cli.Cli:new({binds = {}})

game = require("game")()

game.gameState:insert(loveio.objects)

dofile("src/postInit.lua")
