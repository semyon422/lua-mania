local init = function(game)
--------------------------------
local fileFormats = {
	["osu"] = require(game.path .. "import/osu")
}

local import = function(filePath)
	local mapFormat = string.sub(filePath, -3, -1)
	for fileFormat, import in pairs(fileFormats) do
		if mapFormat == fileFormat then
			return import(filePath)
		end
	end
end

return import
--------------------------------
end

return init