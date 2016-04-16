local logo = {}

logo.data = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2,
	r = 100,
	layer = 2,
	pressed = false,
	name = "logo"
}

logo.update = function()
	local data = logo.data
	table.insert(luaMania.ui.output.objects[data.layer], {
		class = "circle",
		x = data.x, y = data.y,
		r = data.r,
		mode = "line"
	})
end

return logo