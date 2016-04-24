local function rectangle(source)
	source.mode = tonumber(source.mode) or "fill"
	source.vertices = source.vertices or {}

	source.alpha = tonumber(source.alpha) or 255
	source.color = source.color or {}
	source.color[1] = tonumber(source.color[1]) or 255
	source.color[2] = tonumber(source.color[2]) or 255
	source.color[3] = tonumber(source.color[3]) or 255
	source.color[4] = tonumber(source.color[4]) or source.alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(source.color)
	love.graphics.polygon(source.mode, source.vertices)
	love.graphics.setColor(oldColor)
end

return rectangle