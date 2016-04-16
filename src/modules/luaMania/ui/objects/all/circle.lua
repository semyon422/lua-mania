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
	table.insert(luaMania.ui.output.objects[data.layer], {
		class = "circle",
		x = data.x, y = data.y,
		r = data.r
	})
	table.insert(luaMania.ui.output.objects[data.layer], {
		class = "text",
		x = data.x - love.graphics.getWidth()/2, y = data.y,
		text = "\nmove me",
		align = "center"
	})
	luaMania.ui.input.callbacks[data.name] = {
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