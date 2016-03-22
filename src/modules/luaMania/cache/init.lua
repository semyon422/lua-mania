--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local cache = {}

cache.lmCache = require "luaMania.cache.lmCache"
cache.osuCache = require "luaMania.cache.osuCache"
cache.songsPath = "res/Songs"
cache.generate = require("luaMania.cache.generate")


return cache
