local loveio = {}

loveio.input = require("loveio.input")
loveio.output = require("loveio.output")

loveio.init = function(objects)
	loveio.objects = objects or {}
	local objects = loveio.objects
	love.update = function(dt)
		for _, object in pairs(objects) do
			if object.update then object.update() end
		end
	end
	loveio.input.init()
	loveio.output.init()
end

return loveio