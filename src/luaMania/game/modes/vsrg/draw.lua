local init = function(vsrg, game)
--------------------------------
local oy = function(time)
	return time / 1000 - game.map.audio:tell()
end
local draw = function(column)
	for hitObjectIndex = column.firstHitObjectIndex, #column.hitObjects do
		local hitObject = column.hitObjects[hitObjectIndex]
		if hitObject then
			if oy(hitObject.startTime) > 1 then
				break
			elseif oy(hitObject.startTime) < 0 and not hitObject.endTime or hitObject.endTime and oy(hitObject.endTime) < 0 then
				hitObject:remove()
				column.firstHitObjectIndex = hitObject.columnIndex
			else
				hitObject:draw((hitObject.key - 1) / 10, oy(hitObject.startTime))
			end
		end
	end
	table.insert(loveio.output.objects, {
		class = "rectangle",
		color = {0,0,0,127},
		x = 0.1 * (column.key - 1),
		y = 0,
		w = 0.1,
		h = 1,
		layer = 2,
		remove = true
	})
end

return draw
--------------------------------
end

return init