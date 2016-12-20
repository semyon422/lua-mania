local init = function(...)
--------------------------------
local skin = {}
skin.path = "res/defaultSkin/"

local note = love.graphics.newImage(skin.path .. "vsrg/circle/3fff9f.png")
local headAndTail = love.graphics.newImage(skin.path .. "vsrg/arrow/ffffff.png")
local body = love.graphics.newImage(skin.path .. "vsrg/hold/ffffff.png")

local columnWidth = 0.09
local columnStart = 0.075
local columnColor = {31, 31, 31, 127}
local hitPosition = 0

skin.get = function(key, data)
	if key == "noteImage" then
		return note
	elseif key == "holdBodyImage" then
		return body
	elseif key == "holdHeadImage" or key == "holdTailImage" then
		return headAndTail
	elseif key == "columnStart" then
		return skin.getColumnStart(data.key)
	elseif key == "columnWidth" then
		return columnWidth
	elseif key == "columnColor" then
		return columnColor
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
