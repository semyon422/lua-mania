helpers = require("helpers")
Profiler = require("Profiler")
log = helpers.logger.log

configManager = require("configManager")
mainConfig = configManager.load("config.txt")

cacheManager = require("cacheManager")
mainCache = cacheManager.load("cache.lua")

windowManager = require("windowManager")

loveio = require("loveio")
loveio.init()

pos = loveio.output.Position:new({
	ratios = {0.01, 4/3}, resolutions = {{1, 1}, {1, 1}}
})

ui = require("ui")
uiBase = require("uiBase")()

cli = require("cli")
mainCli = cli.Cli:new({binds = {}})

osu = require("osu")
bms = require("bms")
lmx = require("lmx")

game = require("game")()

game.gameState:insert(loveio.objects)

dofile("src/postInit.lua")