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
	self.data.circlemenu[self.data.currentcircleMenu].action()
	--self:menu()
end

function uiClass.options(self)

end

function uiClass.songs(self)
	self:menu()
end

function uiClass.play(self)

end

function uiClass.pause(self)

end

function uiClass.fail(self)

end


function uiClass.menu(self)
	local mode = self.data.mode
	local buttoncount = self.data.buttoncount
	local buttoncount = #self.data.menu[self.data.currentMenu]
	local offset = self.data.offset
	local menuItems = self.data.menu[self.data.currentMenu]
	self.data.buttoncoords = {}

	local buttonheight = nil
	
	if self.data.menuState then
		buttonheight = (data.height - offset * data.width) / buttoncount - offset * data.width
		--lg.setColor(220, 220, 206, 128)
		--lg.rectangle("fill", 0, 0, data.width, data.height)
		
		for i = 1, buttoncount do
			lg.setColor(206, 223, 153, 128)
			lg.rectangle("fill", offset * data.width, offset * data.width + (i - 1) * (offset * data.width + buttonheight), data.width - 2 * offset * data.width, buttonheight)
			lg.setColor(255,255,255,255)
			centreX = data.width / 2
			centreY = offset * data.width + (i - 1) * (offset * data.width + buttonheight) + buttonheight / 2
			if menuItems[i].picture ~= nil then
				scale = (data.width - 2 * offset * data.width) / menuItems[i].picture:getWidth()
				menuItems[i].picture:setFilter("linear","nearest")
				lg.draw(menuItems[i].picture, centreX, centreY, 0, scale, scale, menuItems[i].picture:getWidth()/2, menuItems[i].picture:getHeight()/2)
			else
				lg.print(menuItems[i].text, offset * data.width, offset * data.width + (i - 1) * (offset * data.width + buttonheight))
			end
			if self.data.mode == 1 then
				self.data.buttoncoords[i] = {
					{offset * lg.getHeight() + (i - 1) * (offset * lg.getHeight() + buttonheight), offset * lg.getHeight()},
					{offset * lg.getHeight() + (i - 1) * (offset * lg.getHeight() + buttonheight) + buttonheight, lg.getHeight()*(1 - offset)}
				}
			elseif self.data.mode == 0 then
				self.data.buttoncoords[i] = {
					{offset * lg.getWidth(), offset * lg.getWidth() + (i - 1) * (offset * lg.getWidth() + buttonheight)},
					{lg.getWidth()*(1 - offset), offset * lg.getWidth() + (i - 1) * (offset * lg.getWidth() + buttonheight) + buttonheight}
				}
			end
		end
		function love.mousepressed(x, y, button, istouch)
			for i = 1, #data.ui.buttoncoords do
				if x > data.ui.buttoncoords[i][1][1] and y > data.ui.buttoncoords[i][1][2] and x < data.ui.buttoncoords[i][2][1] and y < data.ui.buttoncoords[i][2][2] then
					menuItems[i].action()
				end
			end
		end
	end
	if self.data.menuState == false and data.beatmap.audio then
		function love.mousepressed(x, y, button, istouch)
			self.data.menuState = true
			self.data.currentMenu = "pause"
			osu:pause()
		end
	end
end
