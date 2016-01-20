--[[
lua-mania
Copyright (C) 2016 Semyon Jolnirov (semyon422)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
--]]
function love.load()
	data = nil
	data = {
		pathprefix = "src/tests/",
		
		keys = {},
		keyspressed = "keyspressed\n",
		mousepressed = "mousepressed\n",
		mousemoved = "mousemoved\n",
		mousereleased = "mousereleased\n",
		keypressed = "keypressed\n",
		keyreleased = "keyreleased\n",
		touchpressed = "touchpressed\n",
		touchreleased = "touchreleased\n",
		touchmoved = "touchmoved\n",
		isDown = "isDown\n",
		seconds = "click sound seconds\n",
		mx = 0,
		my = 0,
		px = 0,
		py = 0,
		axis1 = "axis1\n",
		axis2 = "axis2\n",
		axis3 = "axis3\n",
		axisn1 = 0,
		axisn2 = 0,
		axisn3 = 0,
	}
	data.audio = love.audio.newSource("res/click.wav")
	
	data.cursor = love.graphics.newImage("res/cursor1.png")
	data.star = love.graphics.newImage("res/cursor2.png")
	love.graphics.setBackgroundColor(34,39,43)
	love.graphics.setColor(255,255,255,255)
	loaded = true
end

function love.update(dt)
	if loaded ~= true then love.load() end
	data.isDown = "isDown "
	data.keyspressed = "keyspressed "
	for index,key in pairs(data.keys) do
		if love.keyboard.isDown(key) then
			data.isDown = data.isDown .. " " .. key
		end
		data.keyspressed = data.keyspressed .. " " .. key
	end
	data.isDown = data.isDown .. "\n"
	data.keyspressed = data.keyspressed .. "\n"
end

function love.draw()
	love.graphics.print(
	"PRESS ESCAPE TO EXIT\n" ..
	tostring("fps=" .. love.timer.getFPS() .. "\n") .. 
	"OS: " .. love.system.getOS() .. "\n" ..
	data.mousepressed ..
	data.mousereleased ..
	data.mousemoved ..
	data.keypressed ..
	data.keyreleased ..
	data.touchpressed ..
	data.touchreleased ..
	data.touchmoved ..
	data.isDown ..
	data.keyspressed ..
	data.axis1 ..
	data.axis2 ..
	data.axis3 ..
	data.seconds,
	0, 0)
	love.graphics.draw(data.cursor, data.mx, data.my, 0, 1, 1, data.cursor:getWidth()/2, data.cursor:getHeight()/2)
	love.graphics.draw(data.star, data.px, data.py, 0, 1, 1, data.star:getWidth()/2, data.star:getHeight()/2)
	data.seconds = "click sound seconds " .. data.audio:tell() .. "\n"
end

function love.mousepressed(x, y, button, istouch)
	data.mousepressed = "mousepressed x=" .. x .. " y=" .. y .. " button=" .. button .. " istouch=" .. tostring(istouch) .. "\n"
	data.px = x
	data.py = y
	data.audio:stop()
	data.audio:play()
end

function love.mousereleased(x, y, button, istouch)
	data.mousereleased = "mousereleased x=" .. x .. " y=" .. y .. " button=" .. button .. " istouch=" .. tostring(istouch) .. "\n"
end

function love.mousemoved(x, y, dx, dy)
	data.mousemoved = "mousemoved x=" .. x .. " y=" .. y .. " dx=" .. dx .. " dy=" .. dy .. "\n"
	data.mx = x
	data.my = y
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	data.keypressed = "keypressed key=" .. key .. "\n"
	inarr = false
	for index,k in pairs(data.keys) do
		if k == key then
			inarr = true
		end
	end
	if inarr == false then
		table.insert(data.keys, key)
	end
	inarr = false
end

function love.keyreleased(key)
	data.keyreleased = "keyreleased key=" .. key .. "\n"
end

function love.touchpressed( id, x, y, pressure )
	data.touchpressed = "touchpressed id=" .. tostring(id) .. " x=" .. x .. " y=" .. y .. " pressure=" .. pressure ..  "\n"
end

function love.touchreleased( id, x, y, pressure )
	data.touchreleased = "touchreleased id=" .. tostring(id) .. " x=" .. x .. " y=" .. y .. " pressure=" .. pressure ..  "\n"
end

function love.touchmoved( id, x, y, pressure )
	data.touchmoved = "touchmoved id=" .. tostring(id) .. " x=" .. x .. " y=" .. y .. " pressure=" .. pressure ..  "\n"
end

function love.joystickaxis( joystick, axis, value )
	if axis == 1 then
		data.axis1 = "axis1 value=" .. value .. "\n"
	end
	if axis == 2 then
		data.axis2 = "axis2 value=" .. value .. "\n"
	end
	if axis == 3 then
		data.axis3 = "axis2 value=" .. value .. "\n"
	end
end

function clean()
	love.load = nil
	love.update = nil
	love.draw = nil
	love.mousepressed = nil
	love.mousereleased = nil
	love.mousemoved = nil
	love.keypressed = nil
	love.keyreleased = nil
	love.touchpressed = nil
	love.touchpressed = nil
	love.touchreleased = nil
	love.touchmoved = nil
	love.joystickaxis = nil
	loaded = nil
	clean = nil
end