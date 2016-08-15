local init = function(loveio)
--------------------------------
local input = {}

input.navigation = require("loveio.input.navigation")(input, loveio)

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
		love[name] = function(...)
			for _, callback in pairs(input.callbacks[name]) do
				callback(...)
			end
		end
	end
end

return input
--------------------------------
end

return init