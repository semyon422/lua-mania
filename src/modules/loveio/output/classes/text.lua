local function text(source)
	local x = math.floor(pos.x2X(tonumber(source.x), true)) or 0
	local y = math.floor(pos.y2Y(tonumber(source.y), true)) or 0
	local limit = math.floor(pos.x2X(tonumber(source.limit)) or loveio.output.position.w)
	local r = tonumber(source.r) or 0
	local xAlign = source.xAlign or "left"
	local yAlign = source.yAlign or "bottom"
	local sx = tonumber(source.sx) or 1
	local sy = tonumber(source.sy) or source.sy
	local kx = tonumber(source.kx) or 0
	local ky = tonumber(source.ky) or 0

	local text = tostring(source.text) or ""
	local lineCount = #explode("\n", text)
	local font = source.font or love.graphics.getFont()
	if source.yAlign == "center" then
		y = math.floor(y - (font:getHeight() / 2) * lineCount)
	elseif source.yAlign == "top" then
		y = math.floor(y - font:getHeight() * lineCount)
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