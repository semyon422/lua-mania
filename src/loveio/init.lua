local loveio = {}

loveio.LoveioObject = require("loveio.LoveioObject")(loveio)

loveio.input = require("loveio.input")(loveio)
loveio.output = require("loveio.output")(loveio)

loveio.init = function(objects)
	loveio.objects = objects or {}
	local objects = loveio.objects
	love.update = function(dt)
		loveio.dt = dt
		for _, object in pairs(objects) do
			if object.update then object:update() end
		end
	end
	loveio.input.init()
	loveio.output.init()
end

return loveio