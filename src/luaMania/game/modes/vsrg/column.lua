local init = function(vsrg, game)
--------------------------------
local Column = {}

Column.update = require("luaMania/game/modes/vsrg/update")(vsrg, game)
Column.draw = require("luaMania/game/modes/vsrg/draw")(vsrg, game)

Column.new = function(self, key)
	local column = {}
	setmetatable(column, self)
	self.__index = self
	
	local map = game.map
	
	column.key = key
	column.hitObjects = {}
	column.timingPoints = map.timingPoints
	
	local interval = 512 / map:get("CircleSize")
	for hitObjectIndex, hitObject in ipairs(map.hitObjects) do
		hitObject.key = hitObject.key or 0
		if hitObject.key == 0 then
			for newKey = 1, map:get("CircleSize") do
				if hitObject.x >= interval * (newKey - 1) and hitObject.x < newKey * interval then
					hitObject.key = newKey
					break
				end
			end
		end
		if hitObject.key == key then
			hitObject.columnIndex = #column.hitObjects + 1
			hitObject.column = column
			table.insert(column.hitObjects, vsrg.HitObject:new(hitObject))
		end
	end
	column.firstHitObjectIndex = 1
	
	-- loveio.input.callbacks.keypressed["vsrgColumn" .. key] = function(key)
		-- for keybind, keynum in pairs(mania.keys.binds) do
			-- if key == keybind then
				-- mania.keys.pressed[keynum] = true
				-- for _, filename in pairs(mania.map.hitSoundsQueue[keynum][1][1]) do
					-- mania.map.hitSounds[filename]:clone():play()
				-- end
				-- if mania.map.objects.current[keynum] then
					-- mania.keys.hitted[keynum] = true
					-- mania.hit(mania.map.objects.current[keynum].startTime - mania.map.stats.currentTime, keynum)
				-- end
			-- end
		-- end
	-- end
	-- loveio.input.callbacks.keyreleased["vsrgColumn" .. key] = function(key)
		-- for keybind, keynum in pairs(mania.keys.binds) do
			-- if key == keybind then
				-- mania.keys.pressed[keynum] = nil
				-- mania.keys.hitted[keynum] = nil
			-- end
		-- end
	-- end
	
	return column
end

return Column
--------------------------------
end

return init