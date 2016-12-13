require("lmfw")
require("rglib")

mainConfig = configManager.Config:new():load("config.txt")

mainCache = cacheManager.Cache:new():load("cache.lua")

loveio.init()

pos = loveio.output.Position:new({
	ratios = {0.01, mainConfig:get("position.ratio", 4/3)}, resolutions = {{1, 1}, {1, 1}}
})

uiBase = require("uiBase")()

mainCli = cli.Cli:new({binds = {}})

game = require("game")()

game.gameState:insert(loveio.objects)

dofile("src/postInit.lua")
