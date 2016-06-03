local function drawable(source)
	local x = pos.x2X(tonumber(source.x), true) or 0
	local y = pos.y2Y(tonumber(source.y), true) or 0
	local r = tonumber(source.r) or 0
	local sx = tonumber(source.sx) or 1
	local sy = tonumber(source.sy) or sx
	local ox = pos.x2X(tonumber(source.ox)) or 0
	local oy = pos.y2Y(tonumber(source.oy)) or ox

	local alpha = tonumber(source.alpha) or 255
	local color = source.color or {}
	color[1] = tonumber(color[1]) or 255
	color[2] = tonumber(color[2]) or 255
	color[3] = tonumber(color[3]) or 255
	color[4] = tonumber(color[4]) or alpha
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(color)
	love.graphics.draw(source.drawable, x, y, r, sx, sy, ox, oy)
	love.graphics.setColor(oldColor)
end

return drawable