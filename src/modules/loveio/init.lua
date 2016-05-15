local loveio = {}

loveio.input = require("loveio.input")
loveio.output = require("loveio.output")

loveio.getFilePath = require("loveio.getFilePath")

loveio.init = function(objects)
	loveio.objects = objects or {}
	local objects = loveio.objects
	function love.update(dt)
		for _, object in pairs(objects) do
			object.update(dt)
		end
	end
	loveio.input.init()
	loveio.output.init()
end

return loveio