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
uiClass = {}
uiClass.__index = uiClass

function uiClass.new(init)
	local self = setmetatable({}, uiClass)
	self.data = init
	return self
end

function uiClass.welcome(self)

end

function uiClass.mainMenu(self)

end

function uiClass.options(self)

end

function uiClass.songs(self)

end

function uiClass.play(self)

end

function uiClass.pause(self)

end

function uiClass.fail(self)

end

--menuItems = {
--	[1] = {
--		picture = "back.png",
--		action = function() end
--	}
--}

function uiClass.menu(self)
	local mode = self.data.mode --portrait / album
	local buttoncount = self.data.buttoncount
	local buttoncount = #self.data.menu[self.data.currentMenu]
	local offset = self.data.offset
	local menuItems = self.data.menu[self.data.currentMenu]
	self.data.buttoncoords = {}

	local buttonheight = nil
	
	if mode == "album" and self.data.menuState then
		
	elseif self.data.menuState then
		buttonheight = (love.graphics.getWidth() - offset * love.graphics.getHeight()) / buttoncount - offset * love.graphics.getHeight()
		love.graphics.setColor(34, 39, 43, 128)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getHeight(), love.graphics.getWidth())
		
		for i = 1, buttoncount do
			love.graphics.setColor(40, 44, 53, 128)
			love.graphics.rectangle("fill", offset * love.graphics.getHeight(), offset * love.graphics.getHeight() + (i - 1) * (offset * love.graphics.getHeight() + buttonheight), love.graphics.getHeight() - 2 * offset * love.graphics.getHeight(), buttonheight)
			love.graphics.setColor(255,255,255,255)
			centreX = love.graphics.getHeight() / 2
			centreY = offset * love.graphics.getHeight() + (i - 1) * (offset * love.graphics.getHeight() + buttonheight) + buttonheight / 2
			if menuItems[i].picture ~= nil then
				scale = (love.graphics.getHeight() - 2 * offset * love.graphics.getHeight()) / menuItems[i].picture:getWidth()
				menuItems[i].picture:setFilter("linear","nearest")
				love.graphics.draw(menuItems[i].picture, centreX, centreY, 0, scale, scale, menuItems[i].picture:getWidth()/2, menuItems[i].picture:getHeight()/2)
			else
				love.graphics.print(menuItems[i].text, offset * love.graphics.getHeight(), offset * love.graphics.getHeight() + (i - 1) * (offset * love.graphics.getHeight() + buttonheight))
			end
			self.data.buttoncoords[i] = {
				{offset * love.graphics.getHeight() + (i - 1) * (offset * love.graphics.getHeight() + buttonheight), offset * love.graphics.getHeight()},
				{offset * love.graphics.getHeight() + (i - 1) * (offset * love.graphics.getHeight() + buttonheight) + buttonheight, love.graphics.getHeight()*(1 - offset)}
			}
		end
		function love.mousepressed(x, y, button, istouch)
			for i = 1, #data.ui.buttoncoords do
				if x > data.ui.buttoncoords[i][1][1] and y > data.ui.buttoncoords[i][1][2] and x < data.ui.buttoncoords[i][2][1] and y < data.ui.buttoncoords[i][2][2] then
					menuItems[i].action()
				end
			end
		end
	end
	if self.data.menuState == false then
		function love.mousepressed(x, y, button, istouch)
			self.data.menuState = true
			self.data.currentMenu = "pause"
			osu:pause()
		end
	end
end






