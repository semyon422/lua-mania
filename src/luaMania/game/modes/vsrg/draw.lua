local init = function(Column, vsrg, game, luaMania)
--------------------------------
local oy = function(time)
	return time / 1000 - game.map.audio:tell()
end
local draw = function(self)
	for hitObjectIndex = self.firstHitObjectIndex, #self.hitObjects do
		local hitObject = self.hitObjects[hitObjectIndex]
		if hitObject then
			if vsrg.removeAll then
				hitObject:remove()
			elseif oy(hitObject.startTime) > 1 then
				break
			elseif oy(hitObject.startTime) < 0 and not hitObject.endTime or hitObject.endTime and oy(hitObject.endTime) < 0 then
				hitObject:remove()
				self.firstHitObjectIndex = hitObject.columnIndex
			else
				hitObject:draw((hitObject.key - 1) / 10, oy(hitObject.startTime))
			end
		end
	end
	if vsrg.removeAll then
		loveio.output.objects["column" .. self.key] = nil
	end
end

return draw
--------------------------------
end

return init