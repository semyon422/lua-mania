local circle = {}

circle.data = {
	name = "circle",
	x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2,
	r = 40,
	isPressed = false,
	pressedDeltaX = 0,
	pressedDeltaY = 0,
	layer = 2
}
circle.update = function()
	local data = circle.data
	loveio.output.objects[data.name .. "circle"] = {
		class = "circle",
		x = data.x, y = data.y,
		r = data.r,
		layer = data.layer,
		color = {31,31,31}
	}
	loveio.output.objects[data.name .. "text"] = {
		class = "text",
		x = data.x, y = data.y,
		text = "move me",
		xAlign = "center",
		yAlign = "center",
		color = {255,255,255},
		layer = data.layer
	}
	loveio.input.callbacks[data.name] = {
		mousepressed = function(x, y, button)
			if (x - data.x)^2 + (y - data.y)^2 <= data.r^2 then
				data.isPressed = true
				data.pressedDeltaX = x - data.x
				data.pressedDeltaY = y - data.y
			end
		end,
		mousemoved = function(x, y, button)
			if data.isPressed then
				data.x = x - data.pressedDeltaX
				data.y = y - data.pressedDeltaY
			end
		end,
		mousereleased = function(x, y, button)
			data.isPressed = false
		end
	}
end

return circle