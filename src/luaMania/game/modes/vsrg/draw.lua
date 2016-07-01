local init = function(vsrg, game)
--------------------------------
local ox = function(hitObject)
	return (hitObject.key - 1) / 10
end
local oy = function(hitObject)
	return hitObject.startTime / 1000 - game.map.audio:tell()
end
local draw = function(column)
	for hitObjectIndex = column.firstHitObjectIndex, #column.hitObjects do
		local hitObject = column.hitObjects[hitObjectIndex]
		if hitObject then
			if oy(hitObject) > 1 then
				break
			elseif oy(hitObject) >= 0 then
				hitObject:draw(ox, oy)
			else
				hitObject:remove()
				column.firstHitObjectIndex = hitObject.index
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