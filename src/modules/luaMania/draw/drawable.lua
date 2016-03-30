local function drawable(source)
	if source.object then
		source.x = source.object.x
		source.y = source.object.y
		source.r = source.object.r
		source.sx = source.object.sx
		source.sy = source.object.sy
		source.color = source.object.color
		source.alpha = source.object.alpha
	end
	source.x = tonumber(source.x) or 0
	source.y = tonumber(source.y) or 0
	source.r = tonumber(source.r) or 0
	source.sx = tonumber(source.sx) or 1
	source.sy = tonumber(source.sy) or sx

	source.alpha = tonumber(source.alpha) or 255
	source.color = source.color or {}
	source.color[1] = tonumber(source.color[1]) or 255
	source.color[2] = tonumber(source.color[2]) or 255
	source.color[3] = tonumber(source.color[3]) or 255
	source.color[4] = tonumber(source.color[4]) or source.alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(source.color)
	love.graphics.draw(source.drawable, source.x, source.y, source.r, source.sx, source.sy)
	love.graphics.setColor(oldColor)
end

return drawable