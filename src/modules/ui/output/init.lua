local output = {}

output.objects = {{},{},{},{}}

output.drawable = require("ui.output.drawable")
output.rectangle = require("ui.output.rectangle")
output.circle = require("ui.output.circle")
output.text = require("ui.output.text")

output.draw = function()
	local objects = output.objects
	for layer = 1, #objects do
		if objects[layer] ~= nil then
			for index = 1, #objects[layer] do
				output[objects[layer][index].class](objects[layer][index])
				objects[layer][index] = nil
			end
		end
	end
end

function love.draw()
	output.draw()
end

return output