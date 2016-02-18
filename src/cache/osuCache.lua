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
local function osuCache(info)
	cache = data.cache
	local raw = io.open("res/Songs/" .. info[1] .. "/" .. info[2], "r")
	local rawTable = {}
	for line in raw:lines() do
		table.insert(rawTable, line)
	end
	raw:close()
	local title = ""
	local artist = ""
	local audio = ""
	local version = ""
	local creator = ""
	local source = ""
	for globalLine,line in pairs(rawTable) do
		if string.sub(line, 1, 13) == "AudioFilename" then
			audio = trim(string.sub(line, 15, -1))
		end
		if string.sub(line, 1, 6) == "Title:" then
			title = trim(string.sub(line, 7, -1))
		end
		if string.sub(line, 1, 7) == "Artist:" then
			artist = trim(string.sub(line, 8, -1))
		end
		if string.sub(line, 1, 7) == "Version" then
			version = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 7) == "Creator" then
			creator = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 6) == "Source" then
			source = trim(string.sub(line, 8, -1))
			if source == "" then source = "No source" end
		end
		if string.sub(line, 1, -1) == "[TimingPoints]" then
			break
		end
	end
	table.insert(cache, {
		title = title,
		artist = artist,
		version = version,
		audio = audio,
		audioFile = audio,
		pathAudio = "res/Songs/" .. info[1] .. "/" .. audio,
		pathFile = "res/Songs/" .. info[1] .. "/" .. info[2],
		path = "res/Songs/" .. info[1],
		creator = creator,
		source = source,
		format = info[3]
	})
end

return osuCache