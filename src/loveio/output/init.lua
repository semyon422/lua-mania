local output = {}

output.objects = {}

output.position = require("loveio.output.position")

output.classes = {
	drawable = require("loveio.output.classes.drawable"),
	rectangle = require("loveio.output.classes.rectangle"),
	circle = require("loveio.output.classes.circle"),
	text = require("loveio.output.classes.text"),
	polygon = require("loveio.output.classes.polygon")
}

output.draw = function()
	local objects = output.objects
	local minLayer = 1
	local maxLayer = 1
	for _, object in pairs(objects) do
		if object.layer and object.layer < minLayer then minLayer = object.layer end
		if object.layer and object.layer > maxLayer then maxLayer = object.layer end
	end
	for layer = minLayer, maxLayer do
		for objectIndex, object in pairs(objects) do
			if object.layer == layer then
				output.classes[object.class](object)
				if object.remove then objects[objectIndex] = nil end
			end
		end
	end
end

output.init = function()
	love.draw = output.draw
end

return output