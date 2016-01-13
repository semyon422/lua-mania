--[[
semyon422's tools and games based on love2d - useful tools and game ports
Copyright (C) 2016 Semyon Jolnirov

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
		pathprefix = "src/menu/",
		
		menuitems = {"tests", "mania"},
		menupictures = {},
		menubuttons = {},
	}
	loaded = true
end

function love.update(dt)
	if loaded ~= true then love.load() end
	data.offset = love.graphics.getWidth()/16
	data.buttonheight = (love.graphics.getHeight() - data.offset) / #data.menuitems - data.offset
	for i = 0, #data.menuitems - 1 do
		data.menubuttons[i + 1] = {
			{data.offset, data.offset + i * (data.offset + data.buttonheight)}, {love.graphics.getWidth() - data.offset, data.offset + i * (data.offset + data.buttonheight) + data.buttonheight}
		}
		data.menupictures[i + 1] =  love.graphics.newImage("res/menuitem-" .. data.menuitems[i + 1] .. ".png")
	end
end

function love.draw()
	
	love.graphics.setBackgroundColor(34,39,43)
	for i = 0, #data.menuitems - 1 do
		love.graphics.setColor(40,44,53)
		love.graphics.rectangle("fill", data.offset, data.offset + i * (data.offset + data.buttonheight), love.graphics.getWidth() - 2 * data.offset, data.buttonheight)
		love.graphics.setColor(255,255,255,255)
		data.menupicturescale = data.buttonheight / data.menupictures[i + 1]:getHeight()
		love.graphics.draw(data.menupictures[i + 1], data.menubuttons[i + 1][1][1] + (data.menubuttons[i + 1][2][1] - data.menubuttons[i + 1][1][1])/2, data.menubuttons[i + 1][1][2] + (data.menubuttons[i + 1][2][2] - data.menubuttons[i + 1][1][2])/2, 0, data.menupicturescale, data.menupicturescale, data.menupictures[i + 1]:getWidth()/2, data.menupictures[i + 1]:getHeight()/2)
	end
	
end

function love.mousepressed(x, y, button, istouch)
	for i = 1, #data.menubuttons do
		if x > data.menubuttons[i][1][1] and y > data.menubuttons[i][1][2] and x < data.menubuttons[i][2][1] and y < data.menubuttons[i][2][2] then
			clean()
			require("src." .. data.menuitems[i] .. ".main")
		end
	end
end
--[[
function love.touchpressed( id, x, y, pressure )
	for i = 1, #menubuttons do
		if x > menubuttons[i][1][1] and y > menubuttons[i][1][2] and x < menubuttons[i][2][1] and y < menubuttons[i][2][2] then
			loaded = nil
			require(menuitems[i] .. ".main")
		end
	end
end
]]--

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function clean()
	love.load = nil
	love.update = nil
	love.draw = nil
	love.mousepressed = nil
	love.keypressed = nil
	loaded = nil
	clean = nil
end










