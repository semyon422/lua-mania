local init = function(input, loveio)
--------------------------------
local mouse = {}

mouse.X = 0
mouse.Y = 0

input.callbacks.mousemoved["loveio.input.mouse"] = function(mx, my)
	mouse.X = mx
	mouse.Y = my
end
	
return mouse
--------------------------------
end

return init
