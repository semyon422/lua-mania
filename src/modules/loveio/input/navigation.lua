local navigation = {}

navigation.buttons = {
	["up"] = "up",
	["down"] = "down",
	["left"] = "left",
	["right"] = "right",
	["activate"] = "return"
}
navigation.currentPosition = {1, 1}
navigation.oldPosition = {0, 0}
navigation.map = {{"playButton"}}
navigation.move = function(direction)
	local curPos = navigation.currentPosition
	local map = navigation.map
	
	if map[curPos[1]] and map[curPos[1]][curPos[2]] and objects[map[curPos[1]][curPos[2]]] then
		if direction == "activate" then
			objects[map[curPos[1]][curPos[2]]].update("activate")
			return
		end
	end
	if direction == "up" then
		if map[curPos[1] + 1] and map[curPos[1] + 1][curPos[2]] and objects[map[curPos[1] + 1][curPos[2]]] then
			curPos[1] = curPos[1] + 1
		end
	elseif direction == "down" then
		if map[curPos[1] - 1] and map[curPos[1] - 1][curPos[2]] and objects[map[curPos[1] - 1][curPos[2]]] then
			curPos[1] = curPos[1] - 1
		end
	elseif direction == "left" then
		if map[curPos[1]] and map[curPos[1]][curPos[2] - 1] and objects[map[curPos[1]][curPos[2] - 1]] then
			curPos[2] = curPos[2] - 1
		end
	elseif direction == "right" then
		if map[curPos[1]] and map[curPos[1]][curPos[2] + 1] and objects[map[curPos[1]][curPos[2] + 1]] then
			curPos[2] = curPos[2] + 1
		end
	end
	if not map[curPos[1]] and not map[curPos[1]][curPos[1]] and curPos[1] ~= 1 and curPos[2] ~= 1 then
		curPos[1] = 1
		curPos[1] = 1
	end
end
navigation.loaded = false
navigation.object = {}
navigation.object.update = function(command)
	local curPos = navigation.currentPosition
	local oldPos = navigation.oldPosition
	local map = navigation.map
	local curObj = objects[map[curPos[1]][curPos[2]]]
	
	if curObj then
		if curPos[1] ~= oldPos[1] or curPos[2] ~= oldPos[2] then
			loveio.output.objects.selectionObject = {
				class = "rectangle",
				x = curObj.x or 0, y = curObj.y or 0,
				w = curObj.w or 0, h = curObj.h or 0,
				mode = "line"
			}
			oldPos[1] = curPos[1]
			oldPos[2] = curPos[2]
		end
	else
		loveio.output.objects.selectionObject = nil
	end
	if not navigation.loaded then
		loveio.input.callbacks.navigation = {
			keypressed = function(key)
				if key == navigation.buttons.up then
					navigation.move("up")
				elseif key == navigation.buttons.down then
					navigation.move("down")
				elseif key == navigation.buttons.left then
					navigation.move("left")
				elseif key == navigation.buttons.right then
					navigation.move("right")
				elseif key == navigation.buttons.activate then
					navigation.move("activate")
				end
			end
		}
	end
end

return navigation