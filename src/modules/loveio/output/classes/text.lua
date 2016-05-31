local function text(source)
	local x = tonumber(source.x) or 0
	local y = tonumber(source.y) or 0
	local limit = tonumber(source.limit) or love.graphics.getWidth()
	local xAlign = source.xAlign or "left"
	local yAlign = source.yAlign or "bottom"
	local r = tonumber(source.r) or 0
	local sx = tonumber(source.sx) or 1
	local sy = tonumber(source.sy) or source.sy
	local kx = tonumber(source.kx) or 0
	local ky = tonumber(source.ky) or 0

	local text = source.text or ""
	local font = source.font or love.graphics.getFont()
	if source.yAlign == "center" then
		y = source.y - font:getHeight() / 2
	elseif source.yAlign == "top" then
		y = source.y - font:getHeight()
	end
	if source.xAlign == "center" then
		x = source.x - love.graphics.getWidth() / 2
	end
	
	local multipleColors = source.multipleColors or false
	local alpha = tonumber(source.alpha) or 255
	local color = source.color or {}
	color[1] = tonumber(color[1]) or 255
	color[2] = tonumber(color[2]) or 255
	color[3] = tonumber(color[3]) or 255
	color[4] = tonumber(color[4]) or alpha
	
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(font)
	local multipleColors = multipleColors or love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf({color, text}, x, y, limit, xAlign, r, sx, sy, ox, oy, kx, ky)
	love.graphics.setColor(oldColor)
	love.graphics.setFont(oldFont)
end

return text