local function drawable(source)
	local x = tonumber(source.x) or 0
	local y = tonumber(source.y) or 0
	local r = tonumber(source.r) or 0
	local sx = tonumber(source.sx) or 1
	local sy = tonumber(source.sy) or sx

	local alpha = tonumber(source.alpha) or 255
	local color = source.color or {}
	color[1] = tonumber(color[1]) or 255
	color[2] = tonumber(color[2]) or 255
	color[3] = tonumber(color[3]) or 255
	color[4] = tonumber(color[4]) or alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(color)
	love.graphics.draw(source.drawable, x, y, r, sx, sy)
	love.graphics.setColor(oldColor)
end

return drawable