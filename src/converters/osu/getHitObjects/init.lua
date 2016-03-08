--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getHitObjects(fileLines, first, last, cache)
	data.beatmap.info.mode = tonumber(data.beatmap.info.mode)
	if data.beatmap.info.mode == 0 then
		osu.getObjects = require "src.objectsHandlers.mania.getObjects"
		require("src.converters.osu.getHitObjects.standart")(fileLines, first, last, cache)
	elseif data.beatmap.info.mode == 1 then
		osu.getObjects = require "src.objectsHandlers.mania.getObjects"
		require("src.converters.osu.getHitObjects.taiko")(fileLines, first, last, cache)
	elseif data.beatmap.info.mode == 2 then
		osu.getObjects = require "src.objectsHandlers.mania.getObjects"
		--require("src.converters.osu.getHitObjects.catchTheBeat")(fileLines, first, last, cache)
		require("src.converters.osu.getHitObjects.standart")(fileLines, first, last, cache)
	elseif data.beatmap.info.mode == 3 then
		osu.getObjects = require "src.objectsHandlers.mania.getObjects"
		require("src.converters.osu.getHitObjects.mania")(fileLines, first, last, cache)
	end
end

return getHitObjects
