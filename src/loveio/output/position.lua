local init = function(loveio)
--------------------------------
local position = {}

position.dimensions = 4 / 3
position.x = 0
position.y = 0
position.w = love.graphics.getWidth()
position.h = love.graphics.getHeight()
position.realWidth = love.graphics.getWidth()
position.realHeight = love.graphics.getHeight()
position.object = {}
position.object.loaded = false
position.object.update = function(command)
	if position.realWidth ~= love.graphics.getWidth() or position.realHeight ~= love.graphics.getHeight() then
		position.realWidth = love.graphics.getWidth()
		position.realHeight = love.graphics.getHeight()
		local w = position.realWidth
		local h = position.realHeight
		if w / h > position.dimensions then
			position.h = h
			position.w = h * position.dimensions
			position.x = (w - position.w) / 2
			position.y = 0
		elseif w / h < position.dimensions then
			position.w = w
			position.h = w / position.dimensions
			position.y = (h - position.h) / 2
			position.x = 0
		else
			position.w = w
			position.h = h
			position.y = 0
			position.x = 0
		end
	end
end

position.x2y = function(x)
	if not x then return end
	position.object.update()
	return x * position.dimensions
end
position.y2x = function(y)
	if not y then return end
	position.object.update()
	return y / position.dimensions
end
position.X2Y = function(X, g)
	if not X then return end
	position.object.update()
	if g then
		return (X - position.x) * position.dimensions
	else
		return X * position.dimensions
	end
end
position.Y2X = function(Y, g)
	if not Y then return end
	position.object.update()
	if g then
		return (Y - position.y) / position.dimensions
	else
		return Y / position.dimensions
	end
end
position.X2x = function(X, g)
	if not X then return end
	position.object.update()
	if g then
		return (X - position.x) / position.w
	else
		return X / position.w
	end
end
position.Y2y = function(Y, g)
	if not Y then return end
	position.object.update()
	if g then
		return (Y - position.y) / position.h
	else
		return Y / position.h
	end
end
position.x2X = function(x, g)
	if not x then return end
	position.object.update()
	if g then
		return position.x + x * position.w
	else
		return x * position.w
	end
end
position.y2Y = function(y, g)
	if not y then return end
	position.object.update()
	if g then
		return position.y + y * position.h
	else
		return y * position.h
	end
end

return position
--------------------------------
end

return init