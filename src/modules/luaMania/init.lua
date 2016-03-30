local luaMania = {}

luaMania.graphics = require("luaMania.graphics")
luaMania.audio = require("luaMania.audio")
luaMania.ui = require("luaMania.ui")
luaMania.config = require("luaMania.config")
luaMania.cache = require("luaMania.cache")
luaMania.keyboard = require("luaMania.keyboard")
luaMania.modes = require("luaMania.modes")
luaMania.load = require("luaMania.load")
luaMania.update = require("luaMania.update")
luaMania.draw = require("luaMania.draw") -- OK
luaMania.state = {
	cachePosition = 1,
	stats = {}
}

return luaMania