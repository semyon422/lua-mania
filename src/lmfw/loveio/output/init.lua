local init = function(loveio)
--------------------------------
local output = {}

output.objects = {}

output.Position = require("loveio.output.Position")(output, loveio)

output.classes = {}
output.classes.OutputObject = require("loveio.output.classes.OutputObject")(output, loveio)
output.classes.Drawable = require("loveio.output.classes.Drawable")(output, loveio)
output.classes.DrawableBox = require("loveio.output.classes.DrawableBox")(output, loveio)
output.classes.Quad = require("loveio.output.classes.Quad")(output, loveio)
output.classes.QuadBox = require("loveio.output.classes.QuadBox")(output, loveio)
output.classes.Rectangle = require("loveio.output.classes.Rectangle")(output, loveio)
output.classes.Circle = require("loveio.output.classes.Circle")(output, loveio)
output.classes.Text = require("loveio.output.classes.Text")(output, loveio)
output.classes.TextBox = require("loveio.output.classes.TextBox")(output, loveio)
output.classes.Polygon = require("loveio.output.classes.Polygon")(output, loveio)

output.draw = function()
	local objects = output.objects
	local minLayer = 1
	local maxLayer = 1
	local layers = {}
	for _, object in pairs(objects) do
		if object.layer then
			if object.layer < minLayer then minLayer = object.layer end
			if object.layer > maxLayer then maxLayer = object.layer end
			layers[object.layer] = true
		end
	end
	local layers2 = {}
	for layer in pairs(layers) do
		table.insert(layers2, layer)
	end
	table.sort(layers2)
	for layerIndex, layer in ipairs(layers2) do
		for objectIndex, object in pairs(objects) do
			if object.layer == layer then
				object:draw()
			end
		end
	end
end

output.init = function()
	love.draw = output.draw
end

return output
--------------------------------
end

return init
