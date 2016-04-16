local input = {}

input.callbacks = {}

function love.keypressed(key)
	for _, callback in pairs(input.callbacks) do
		if callback.keypressed then callback.keypressed(key) end
	end
end
function love.keyreleased(key)
	for _, callback in pairs(input.callbacks) do
		if callback.release then callback.release(key) end
	end
end
function love.mousepressed(x, y, button)
	for _, callback in pairs(input.callbacks) do
		if callback.mousepressed then callback.mousepressed(x, y, button) end
	end
end
function love.mousemoved(x, y, button)
	for _, callback in pairs(input.callbacks) do
		if callback.mousemoved then callback.mousemoved(x, y, button) end
	end
end
function love.mousereleased(x, y, button)
	for _, callback in pairs(input.callbacks) do
		if callback.mousereleased then callback.mousereleased(x, y, button) end
	end
end
function love.wheelmoved(x, y)
	for _, callback in pairs(input.callbacks) do
		if callback.wheelmoved then callback.wheelmoved(x, y) end
	end
end
function love.resize(w, h)
	for _, callback in pairs(input.callbacks) do
		if callback.resize then callback.resize(x, y) end
	end
end

return input
