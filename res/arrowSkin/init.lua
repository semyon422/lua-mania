local init = function(...)
--------------------------------
local skin = {}
skin.path = "res/arrowSkin/"

local newImage = love.graphics.newImage

local leftArrow = newImage(skin.path .. "vsrg/arrows/note/left.png")
local upArrow = newImage(skin.path .. "vsrg/arrows/note/up.png")
local downArrow = newImage(skin.path .. "vsrg/arrows/note/down.png")
local rightArrow = newImage(skin.path .. "vsrg/arrows/note/right.png")

local holdTail = newImage(skin.path .. "vsrg/arrows/hold/holdTail.png")
local holdBody = newImage(skin.path .. "vsrg/arrows/hold/holdBody.png")

local columnWidth = 0.09
local columnStart = 0.075
local columnColor = {31, 31, 31, 127}
local hitPosition = 0

skin.get = function(key, data)
	if key == "noteImage" then
		if data.keymode == 4 then
			if data.key == 1 then return leftArrow
			elseif data.key == 2 then return upArrow
			elseif data.key == 3 then return downArrow
			elseif data.key == 4 then return rightArrow
			end
		else
			return downArrow
		end
	elseif key == "holdBodyImage" then
		return holdBody
	elseif key == "holdHeadImage" then
		return skin.get("noteImage", {keymode = data.keymode, key = data.key})
	elseif key == "holdTailImage" then
		return holdTail
	elseif key == "columnWidth" then
		return columnWidth
	elseif key == "columnStart" then
		return skin.getColumnStart(data.key)
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
