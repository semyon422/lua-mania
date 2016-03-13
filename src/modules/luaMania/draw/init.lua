local draw = {}

draw.drawable = require("luaMania.draw.drawable")
draw.rectangle = require("luaMania.draw.rectangle")
draw.circle = require("luaMania.draw.circle")
draw.text = require("luaMania.draw.text")

draw.allObjects = function()
	local objects = luaMania.graphics.objects
	
	for layer = 1, #objects do
		for index = 1, #objects[layer] do
			draw[objects[layer][index].class](objects[layer][index])
			objects[layer][index] = nil
		end
	end
end

return draw