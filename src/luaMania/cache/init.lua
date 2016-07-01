local cache = {}

cache.data = {}

cache.position = 1 -- remove

cache.callback = require("luaMania.cache.callback")

cache.rules = {
	path = "res/Songs/",
	callback = cache.callback
}


return cache
