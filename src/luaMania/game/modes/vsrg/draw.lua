local init = function(Column, vsrg, game, luaMania)
--------------------------------
local oy = function(self, time)
	return time / 1000 - self.map.audio:tell()
end
local draw = function(self)
	for hitObjectIndex = self.firstHitObjectIndex, #self.hitObjects do
		local hitObject = self.hitObjects[hitObjectIndex]
		if hitObject then
			if oy(self, hitObject.startTime) > 1 then
				break
			elseif oy(self, hitObject.startTime) < 0 and not hitObject.endTime or hitObject.endTime and oy(self, hitObject.endTime) < 0 then
				hitObject:remove()
				self.firstHitObjectIndex = hitObject.columnIndex
			else
				hitObject:draw((hitObject.key - 1) / 10, oy(self, hitObject.startTime))
			end
		end
	end
end

return draw
--------------------------------
end

return init