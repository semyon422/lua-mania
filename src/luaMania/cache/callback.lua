local osuCache = require "luaMania.cache.osuCache"

local function callback(filePath)
	if love.filesystem.isFile(filePath) then
		if string.sub(filePath, -4, -1) == ".osu" then
			return osuCache(filePath)
		end
	end
end

return callback