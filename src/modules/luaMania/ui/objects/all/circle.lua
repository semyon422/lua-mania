local circle = {
	data = {
		name = "circle",
		x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2,
		r = 40,
		isPressed = false,
		pressedDeltaX = 0,
		pressedDeltaY = 0,
		layer = 2
	},
	update = function()
		local data = luaMania.ui.objects.all["circle"].data
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
		luaMania.ui.input.mouseBinds[data.name] = {
			press = function(x, y, button)
				if (x - data.x)^2 + (y - data.y)^2 <= data.r^2 then
					data.isPressed = true
					data.pressedDeltaX = x - data.x
					data.pressedDeltaY = y - data.y
				end
			end,
			move = function(x, y, button)
				if data.isPressed then
					data.x = x - data.pressedDeltaX
					data.y = y - data.pressedDeltaY
				end
			end,
			release = function(x, y, button)
				data.isPressed = false
			end
		}
	end
}

return circle