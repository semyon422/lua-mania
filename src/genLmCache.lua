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
local function generateCache(self)
	cache = data.cache
	local BMFList = data.BMFList
	for index,info in pairs(BMFList) do
		local raw = io.open("res/Songs/" .. info[1] .. "/" .. info[2], "r")
		local rawTable = {}
		for line in raw:lines() do
			table.insert(rawTable, line)
		end
		raw:close()
		local title = ""
		local artist = ""
		local audio = ""
		local difficulity = ""
		local creator = ""
		local source = ""
		for gLine = 1, #rawTable do
			if explode(":", tostring(rawTable[gLine]))[1] == "audioFilename" then
				audio = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "title" then
				title = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "artist" then
				artist = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "version" then
				difficulity = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "creator" then
				creator = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
			end
			if explode(":", tostring(rawTable[gLine]))[1] == "source" then
				source = trim(tostring(explode(":", tostring(rawTable[gLine]))[2]))
				if source == "" then source = "No source" end
			end
			if #explode("vent", tostring(rawTable[gLine])) == 2 then
				break
			end
		end
		table.insert(cache, {
			title = title,
			artist = artist,
			difficulity = difficulity,
			audio = audio,
			audioFile = audio,
			pathAudio = "res/Songs/" .. info[1] .. "/" .. audio,
			pathFile = "res/Songs/" .. info[1] .. "/" .. info[2],
			path = "res/Songs/" .. info[1],
			creator = creator,
			source = source
			})
	end
end

return generateCache