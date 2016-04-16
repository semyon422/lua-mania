local input = {}

input.keyBinds = {}
input.mouseBinds = {}

function love.keypressed(key)
	for _, keyBind in pairs(input.keyBinds) do
		keyBind.press(key)
	end
end
function love.keyreleased(key)
	for _, keyBind in pairs(input.keyBinds) do
		keyBind.release(key)
	end
end
function love.mousepressed(x, y, button)
	for _, mouseBind in pairs(input.mouseBinds) do
		mouseBind.press(x, y, button)
	end
end
function love.mousemoved(x, y, button)
	for _, mouseBind in pairs(input.mouseBinds) do
		mouseBind.move(x, y, button)
	end
end
function love.mousereleased(x, y, button)
	for _, mouseBind in pairs(input.mouseBinds) do
		mouseBind.release(x, y, button)
	end
end
function love.wheelmoved(x, y)
	for _, mouseBind in pairs(input.mouseBinds) do
		mouseBind.wheel(x, y)
	end
end

return input
