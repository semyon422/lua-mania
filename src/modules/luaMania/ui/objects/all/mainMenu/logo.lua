local logo = {}

logo.data = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2,
	r = 100,
	layer = 2,
	pressed = false,
	name = "logo"
}
logo.data.font = love.graphics.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", 36)
logo.data.fontHeight = logo.data.font:getHeight()

logo.update = function()
	local data = logo.data
	table.insert(luaMania.ui.output.objects[data.layer], {
		class = "circle",
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2,
		r = 100,
		color = {220, 220, 204},
		mode = "line"
	})
	table.insert(luaMania.ui.output.objects[data.layer], {
		class = "text",
		align = "center",
		x = data.x - love.graphics.getWidth()/2,
		y = love.graphics.getHeight() / 2 - data.fontHeight / 2,
		text = "lua-mania",
		color = {223, 196, 125},
		font = logo.data.font
	})
	luaMania.ui.input.callbacks[data.name] = {
		resize = function(w, h)
			logo.data.x = love.graphics.getWidth() / 2
			logo.data.y = love.graphics.getHeight() / 2
		end
	}
end

return logo