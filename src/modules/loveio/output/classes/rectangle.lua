local function rectangle(source)
	source.mode = source.mode or "fill"
	source.x = tonumber(source.x) or 0
	source.y = tonumber(source.y) or 0
	source.w = tonumber(source.w) or 0
	source.h = tonumber(source.h) or 0

	source.alpha = tonumber(source.alpha) or 255
	source.color = source.color or {}
	source.color[1] = tonumber(source.color[1]) or 255
	source.color[2] = tonumber(source.color[2]) or 255
	source.color[3] = tonumber(source.color[3]) or 255
	source.color[4] = tonumber(source.color[4]) or source.alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(source.color)
	love.graphics.rectangle(source.mode, source.x, source.y, source.w, source.h)
	love.graphics.setColor(oldColor)
end

return rectangle