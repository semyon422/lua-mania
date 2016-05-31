local function polygon(source)
	local mode = tonumber(source.mode) or "fill"
	local vertices = source.vertices or {}

	local alpha = tonumber(source.alpha) or 255
	local color = source.color or {}
	color[1] = tonumber(color[1]) or 255
	color[2] = tonumber(color[2]) or 255
	color[3] = tonumber(color[3]) or 255
	color[4] = tonumber(color[4]) or alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(color)
	love.graphics.polygon(mode, vertices)
	love.graphics.setColor(oldColor)
end

return polygon