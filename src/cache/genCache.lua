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
local function genCache(self)
	local lmCache = require "src.cache.lmCache"
	local osuCache = require "src.cache.osuCache"
	local path = "res/Songs"
	for _,folder in pairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.isDirectory(path .. "/" .. folder) then
			for _,file in pairs(love.filesystem.getDirectoryItems(path .. "/" .. folder)) do
				if love.filesystem.isFile(path .. "/" .. folder .. "/" .. file) then
					if string.sub(file, -4, -1) == ".osu" then
						osuCache({folder, file, "osu"})
					end
					if string.sub(file, -3, -1) == ".lm" then
						lmCache({folder, file, "lm"})
					end
				end
			end
		end
	end
end

return genCache