local input = {}

input.navigation = require("loveio.input.navigation")

input.callbackNames = {
	"keypressed",
	"keyreleased",
	"mousepressed",
	"mousemoved",
	"mousereleased",
	"wheelmoved",
	"resize"
}

input.callbacks = {}

input.init = function()
	for _, name in pairs(input.callbackNames) do
		input.callbacks[name] = input.callbacks[name] or {}
		if string.sub(name, 1, 5) == "mouse" then
			love[name] = function(...)
				local maxLayer = 1
				for objectName, object in pairs(loveio.objects) do
					if object.accesable and object.layer and object.layer > maxLayer then
						maxLayer = object.layer
					end
				end
				for callbackName, callback in pairs(input.callbacks[name]) do
					if loveio.objects[callbackName] and (loveio.objects[callbackName].layer == maxLayer or not loveio.objects[callbackName].accesable) then callback(...) end
				end
			end
		else
			love[name] = function(...)
				for _, callback in pairs(input.callbacks[name]) do
					callback(...)
				end
			end
		end
	end
end

return input
