--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function generate()
	local path = luaMania.cache.songsPath
	for _, folder in pairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.isDirectory(path .. "/" .. folder) then
			for _, file in pairs(love.filesystem.getDirectoryItems(path .. "/" .. folder)) do
				if love.filesystem.isFile(path .. "/" .. folder .. "/" .. file) then
					if string.sub(file, -4, -1) == ".osu" then
						luaMania.cache.osuCache({folder, file, "osu"})
					end
					if string.sub(file, -3, -1) == ".lm" then
						luaMania.cache.lmCache({folder, file, "lm"})
					end
				end
			end
		end
	end
end

return generate