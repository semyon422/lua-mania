local background = {
	update = function()
		loveio.output.objects.background = {
			class = "rectangle",
			layer = 1,
			x = 0, y = 0,
			w = love.graphics.getWidth(), h = love.graphics.getHeight(),
			color = {63, 63, 63}
		}
	end
}

return background