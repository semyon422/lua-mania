local function rectangle(source)
	local mode = source.mode or "fill"
	local x = pos.x2X(tonumber(source.x), true) or 0
	local y = pos.y2Y(tonumber(source.y), true) or 0
	local w = pos.x2X(tonumber(source.w)) or 0
	local h = pos.y2Y(tonumber(source.h)) or 0
	
	local alpha = tonumber(source.alpha) or 255
	local color = source.color or {}
	color[1] = tonumber(color[1]) or 255
	color[2] = tonumber(color[2]) or 255
	color[3] = tonumber(color[3]) or 255
	color[4] = tonumber(color[4]) or alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(color)
	love.graphics.rectangle(mode, x, y, w, h)
	love.graphics.setColor(oldColor)
end

return rectangle