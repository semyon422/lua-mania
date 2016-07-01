local luaMania = {}

luaMania.ui = require("luaMania.ui")
luaMania.cache = require("luaMania.cache")
luaMania.modes = require("luaMania.game")
luaMania.load = require("luaMania.load")
luaMania.update = require("luaMania.update")

config.luaManiaDefaults = require("luaMania.defaults")
config.luaManiaDefaults.__index = config.luaManiaDefaults
config.luaMania = {}
setmetatable(config.luaMania, config.luaManiaDefaults)

luaMania.skin = require(config.luaMania.skinPath)

return luaMania