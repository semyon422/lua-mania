local init = function(vsrg, game, luaMania)
--------------------------------
local Column = loveio.LoveioObject:new()

Column.update = require("luaMania/game/modes/vsrg/update")(Column, vsrg, game, luaMania)
Column.draw = require("luaMania/game/modes/vsrg/draw")(Column, vsrg, game, luaMania)

Column.remove = function(self)
	self:draw(true)
end

Column.load = function(self, key)
	local map = game.map
	
	self.key = key
	self.hitObjects = {}
	self.timingPoints = map.timingPoints
	
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
			hitObject.columnIndex = #self.hitObjects + 1
			hitObject.column = self
			table.insert(self.hitObjects, vsrg.HitObject:new(hitObject))
		end
	end
	self.firstHitObjectIndex = 1
	
	loveio.output.objects["column" .. self.key] = loveio.output.classes.Rectangle:new({
		color = {0,0,0,127},
		x = 0.1 * (self.key - 1),
		y = 0,
		w = 0.1,
		h = 1,
		layer = 2
	})
	
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
	
end

return Column
--------------------------------
end

return init