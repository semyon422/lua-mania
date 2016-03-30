local function circle(source)
	if source.object then
		source.x = source.object.x
		source.y = source.object.y
		source.r = source.object.r
		source.color = source.object.color
		source.alpha = source.object.alpha
	end
	source.type = source.type or "fill"
	source.x = tonumber(source.x) or 0
	source.y = tonumber(source.y) or 0
	source.r = tonumber(source.r) or 0

	source.alpha = tonumber(source.alpha) or 255
	source.color = source.color or {}
	source.color[1] = tonumber(source.color[1]) or 255
	source.color[2] = tonumber(source.color[2]) or 255
	source.color[3] = tonumber(source.color[3]) or 255
	source.color[4] = tonumber(source.color[4]) or source.alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(source.color)
	love.graphics.circle(source.type, source.x, source.y, source.r)
	love.graphics.setColor(oldColor)
end

return circle