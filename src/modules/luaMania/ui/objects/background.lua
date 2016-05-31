local background = {}
background.color = {63, 63, 63}
background.update = function()
	loveio.output.objects.background = {
		class = "rectangle",
		layer = 1,
		x = 0, y = 0,
		w = love.graphics.getWidth(), h = love.graphics.getHeight(),
		color = background.color
	}
end

return background