--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function convertBeatmap(self, cache)
	if cache.format == "osu" then
		local convert = require("src.converters.osu.osu" .. cache.mode)
		convert(self, cache)
	elseif cache.format == "lm" then
		local convert = require "src.converters.lm2lua"
		convert(self, cache)
	end
end

return convertBeatmap