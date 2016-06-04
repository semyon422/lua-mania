local function text(source)
	local x = pos.x2X(tonumber(source.x), true) or 0
	local y = pos.y2Y(tonumber(source.y), true) or 0
	local limit = pos.x2X(tonumber(source.limit)) or loveio.output.position.w
	local r = tonumber(source.r) or 0
	local xAlign = source.xAlign or "left"
	local yAlign = source.yAlign or "bottom"
	local sx = tonumber(source.sx) or 1
	local sy = tonumber(source.sy) or source.sy
	local kx = tonumber(source.kx) or 0
	local ky = tonumber(source.ky) or 0

	local text = source.text or ""
	local font = source.font or love.graphics.getFont()
	if source.yAlign == "center" then
		y = math.floor(y - font:getHeight() / 2)
	elseif source.yAlign == "top" then
		y = math.floor(y - font:getHeight())
	end
	if source.xAlign == "center" then
		-- x = math.floor(x - limit / 2)
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