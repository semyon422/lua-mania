local init = function(input, loveio)
--------------------------------
local mouse = {}

mouse.x = 0
mouse.y = 0
mouse.X = 0
mouse.Y = 0

input.callbacks.mousemoved["loveio.input.mouse"] = function(mx, my)
	mouse.X = mx
	mouse.Y = my
	mouse.x = loveio.output.position.X2x(mx, true)
	mouse.y = loveio.output.position.Y2y(my, true)
end
	
return mouse
--------------------------------
end

return init
