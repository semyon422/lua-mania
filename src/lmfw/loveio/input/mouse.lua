local init = function(input, loveio)
--------------------------------
local mouse = {}

mouse.x = 0
mouse.y = 0

input.callbacks.mousemoved["loveio.input.mouse"] = function(mx, my)
	mouse.x = mx
	mouse.y = my
end
	
return mouse
--------------------------------
end

return init
