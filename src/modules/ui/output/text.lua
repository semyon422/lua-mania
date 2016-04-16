local function text(source)
	source.x = tonumber(source.x) or 0
	source.y = tonumber(source.y) or 0
	source.limit = tonumber(source.limit) or love.graphics.getWidth()
	source.align = source.align or "left"
	source.r = tonumber(source.r) or 0
	source.sx = tonumber(source.sx) or 1
	source.sy = tonumber(source.sy) or source.sy
	source.kx = tonumber(source.kx) or 0
	source.ky = tonumber(source.ky) or 0

	source.font = source.font or luaMania.graphics.fonts.default
	
	source.multipleColors = source.multipleColors or false
	
	source.text = source.text or ""
	
	source.alpha = tonumber(source.alpha) or 255
	source.color = source.color or {}
	source.color[1] = tonumber(source.color[1]) or 255
	source.color[2] = tonumber(source.color[2]) or 255
	source.color[3] = tonumber(source.color[3]) or 255
	source.color[4] = tonumber(source.color[4]) or source.alpha
	
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(source.font)
	local multipleColors = source.multipleColors or love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf({source.color, source.text}, source.x, source.y, source.limit, source.align, source.r, source.sx, source.sy, source.ox, source.oy, source.kx, source.ky)
	love.graphics.setColor(oldColor)
	love.graphics.setFont(oldFont)
end

return text