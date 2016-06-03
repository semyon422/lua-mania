local position = {}

position.dimensions = 4 / 3
position.x = 0
position.y = 0
position.w = love.graphics.getWidth()
position.h = love.graphics.getHeight()
position.object = {}
position.object.loaded = false
position.object.update = function(command)
	if not position.object.loaded then
		loveio.input.callbacks.position = {
			resize = function()
				local w = love.graphics.getWidth()
				local h = love.graphics.getHeight()
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
				position.w = math.floor(position.w)
				position.h = math.floor(position.h)
				position.y = math.floor(position.y)
				position.x = math.floor(position.x)
			end
		}
	end
end

position.x2y = function(x)
	if not x then return end
	return x * position.dimensions
end
position.y2x = function(y)
	if not y then return end
	return y / position.dimensions
end
position.X2Y = function(X, g)
	if not X then return end
	if g then
		return math.floor((X - position.x) * position.dimensions)
	else
		return math.floor(X * position.dimensions)
	end
end
position.Y2X = function(Y, g)
	if not Y then return end
	if g then
		return math.floor((Y - position.y) / position.dimensions)
	else
		return math.floor(Y / position.dimensions)
	end
end
position.X2x = function(X, g)
	if not X then return end
	if g then
		return (X - position.x) / position.w
	else
		return X / position.w
	end
end
position.Y2y = function(Y, g)
	if not Y then return end
	if g then
		return (Y - position.y) / position.h
	else
		return Y / position.h
	end
end
position.x2X = function(x, g)
	if not x then return end
	if g then
		return math.floor(position.x + x * position.w)
	else
		return math.floor(x * position.w)
	end
end
position.y2Y = function(y, g)
	if not y then return end
	if g then
		return math.floor(position.y + y * position.h)
	else
		return math.floor(y * position.h)
	end
end

return position