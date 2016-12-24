local init = function(...)
--------------------------------
local skin = {}
skin.path = "res/defaultSkin/"

local images = {}
local newImage = function(filePath)
	if not images[filePath] then
		images[filePath] = love.graphics.newImage(filePath)
	end
	return images[filePath]
end

local note = love.graphics.newImage(skin.path .. "vsrg/circle/3fff7f.png")
local headAndTail = love.graphics.newImage(skin.path .. "vsrg/tail/ffffff.png")
local body = love.graphics.newImage(skin.path .. "vsrg/body/white/body-0.png")

local columnWidth = 50/640
local columnStart = 0.075
local columnColor = {31, 31, 31, 127}
local hitPosition = 0

local presets = {
	[1] = { --4k 1 4
		columnColor = {0,0,0,223},
		lightColor = {255,255,255,127},
		noteImage = newImage(skin.path .. "vsrg/circle/3fff7f.png"),
		holdHeadImage = newImage(skin.path .. "vsrg/head/ffffff.png"),
		holdTailImage = newImage(skin.path .. "vsrg/tail/ffffff.png"),
		holdBodyImage = newImage(skin.path .. "vsrg/body/white/body-0.png"),
		keyImage = newImage(skin.path .. "vsrg/key/key.png"),
		keyPressedImage = newImage(skin.path .. "vsrg/key/keyD.png")
	},
	[2] = { --4k 2 3
		columnColor = {15,15,15,223},
		lightColor = {255,255,255,127},
		noteImage = newImage(skin.path .. "vsrg/circle/3fff7f.png"),
		holdHeadImage = newImage(skin.path .. "vsrg/head/ffffff.png"),
		holdTailImage = newImage(skin.path .. "vsrg/tail/ffffff.png"),
		holdBodyImage = newImage(skin.path .. "vsrg/body/white/body-0.png"),
		keyImage = newImage(skin.path .. "vsrg/key/key.png"),
		keyPressedImage = newImage(skin.path .. "vsrg/key/keyD.png")
	},
	[5] = { --7k 1 3 5 7
		columnColor = {15,15,15,223},
		lightColor = {255,255,255,127},
		noteImage = newImage(skin.path .. "vsrg/circle/ffffff.png"),
		holdHeadImage = newImage(skin.path .. "vsrg/head/ffffff.png"),
		holdTailImage = newImage(skin.path .. "vsrg/tail/ffffff.png"),
		holdBodyImage = newImage(skin.path .. "vsrg/body/white/body-0.png"),
		keyImage = newImage(skin.path .. "vsrg/key/key.png"),
		keyPressedImage = newImage(skin.path .. "vsrg/key/keyD.png")
	},
	[6] = { --7k 2 6
		columnColor = {0,0,0,223},
		lightColor = {255,255,255,127},
		noteImage = newImage(skin.path .. "vsrg/circle/3f7fff.png"),
		holdHeadImage = newImage(skin.path .. "vsrg/head/3f7fff.png"),
		holdTailImage = newImage(skin.path .. "vsrg/tail/3f7fff.png"),
		holdBodyImage = newImage(skin.path .. "vsrg/body/blue/body-0.png"),
		keyImage = newImage(skin.path .. "vsrg/key/key.png"),
		keyPressedImage = newImage(skin.path .. "vsrg/key/keyD.png")
	},
	[7] = { --7k 4
		columnColor = {31,31,31,223},
		lightColor = {255,255,255,127},
		noteImage = newImage(skin.path .. "vsrg/circle/ffff3f.png"),
		holdHeadImage = newImage(skin.path .. "vsrg/head/ffff3f.png"),
		holdTailImage = newImage(skin.path .. "vsrg/tail/ffff3f.png"),
		holdBodyImage = newImage(skin.path .. "vsrg/body/yellow/body-0.png"),
		keyImage = newImage(skin.path .. "vsrg/key/keyD.png"),
		keyPressedImage = newImage(skin.path .. "vsrg/key/key.png")
	},
}

local config = {
	[1] = {1},
	[2] = {2,2},
	[3] = {2,1,2},
	[4] = {1,2,2,1},
	[5] = {6,5,7,5,6},
	[6] = {5,6,5,5,6,5},
	[7] = {5,6,5,7,5,6,5},
	[8] = {7,5,6,5,7,5,6,5},
	[9] = {6,5,6,5,7,5,6,5,6},
	[10] = {6,5,6,5,7,7,5,6,5,6},
	[12] = {5,6,5,5,6,5,5,6,5,5,6,5},
	[14] = {5,6,5,7,5,6,5,5,6,5,7,5,6,5},
	[16] = {7,5,6,5,7,5,6,5,7,5,6,5,7,5,6,5},
	[18] = {6,5,6,5,7,5,6,5,6,6,5,6,5,7,5,6,5,6},
}

skin.get = function(key, data)
	if key == "noteImage" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.noteImage
	elseif key == "holdBodyImage" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.holdBodyImage
	elseif key == "holdHeadImage" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.holdHeadImage
	elseif key == "holdTailImage" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.holdTailImage
	elseif key == "keyImage" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.keyImage
	elseif key == "keyPressedImage" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.keyPressedImage
	elseif key == "columnStart" then
		return skin.getColumnStart(data.key)
	elseif key == "columnWidth" then
		return columnWidth
	elseif key == "columnColor" then
		local preset = presets[config[data.keymode][data.key]]
		return preset.columnColor
	elseif key == "hitPosition" then
		return hitPosition
	end
end

skin.getColumnStart = function(key)
	return columnStart + columnWidth * (key - 1)
end


return skin
--------------------------------
end

return init
