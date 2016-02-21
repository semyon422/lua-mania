--[[
lua-mania
Copyright (C) 2016 Semyon Jolnirov (semyon422)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]
local function convertBeatmap(self, cache)
	if cache.format == "osu" then
		local convert = require "src.converters.osu2lua"
		convert(self, cache)
	elseif cache.format == "lm" then
		local convert = require "src.converters.lm2lua"
		convert(self, cache)
	end
end

return convertBeatmap