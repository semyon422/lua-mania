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

function uiClass.mainmenu(self)
	data.ui.mainmenu.menu[data.ui.mainmenu.state].action()
	--self:menu()
end

function uiClass.options(self)

end

function uiClass.songs(self)
	if data.cache[data.ui.songlist.current] == nil then
		lg.setColor(255,255,255,255)
		lg.printf({{223, 196, 125, 255}, "Add beatmaps to res/Songs"}, 0, lg.getHeight()/2 - data.ui.mainmenu.logo.fontsize * (3/4), lg.getWidth(), "center")
		function love.mousepressed(x, y, button, istouch)
		end
	else
		data.ui.songlist.buttonHeight = (lg.getHeight() - 2*lg.getHeight()*data.ui.songlist.height - data.ui.songlist.offset)/5 - data.ui.songlist.offset,
		lg.setColor(255,255,255,255)
		lg.setFont(data.ui.songlist.font)
		for i = 1, #data.cache do
			if i + data.ui.songlist.scroll == 3 then
				lg.setColor(220,220,204,255)
				lg.rectangle("line", 1/3*lg.getWidth(), data.ui.songlist.scroll*(data.ui.songlist.offset + data.ui.songlist.buttonHeight) + data.ui.songlist.offset*i + lg.getHeight()*data.ui.songlist.height + (i-1)*data.ui.songlist.buttonHeight, 2/3*lg.getWidth(), data.ui.songlist.buttonHeight)
				lg.setColor(255,255,255,255)
				lg.printf({{223, 196, 125, 255}, data.cache[i].artist .. " - " .. data.cache[i].title .. " - " .. data.cache[i].difficulity}, math.ceil(1/3*lg.getWidth()), data.ui.songlist.scroll*(data.ui.songlist.offset + data.ui.songlist.buttonHeight) + data.ui.songlist.offset*i + lg.getHeight()*data.ui.songlist.height + (i-1)*data.ui.songlist.buttonHeight, lg.getWidth())
				data.ui.songlist.current = i
			else
				lg.setColor(220,220,204,255)
				lg.rectangle("line", 1/2*lg.getWidth(), data.ui.songlist.scroll*(data.ui.songlist.offset + data.ui.songlist.buttonHeight) + data.ui.songlist.offset*i + lg.getHeight()*data.ui.songlist.height + (i-1)*data.ui.songlist.buttonHeight, 1/2*lg.getWidth(), data.ui.songlist.buttonHeight)
				lg.setColor(255,255,255,255)
				lg.printf({{223, 196, 125, 255}, data.cache[i].artist .. " - " .. data.cache[i].title .. " - " .. data.cache[i].difficulity}, 1/2*lg.getWidth(), data.ui.songlist.scroll*(data.ui.songlist.offset + data.ui.songlist.buttonHeight) + data.ui.songlist.offset*i + lg.getHeight()*data.ui.songlist.height + (i-1)*data.ui.songlist.buttonHeight, lg.getWidth())
			end
		end
		
		
		lg.setColor(63,63,63, 192)
		lg.rectangle("fill", 0, 0,  lg.getWidth(), lg.getHeight()*data.ui.songlist.height)
		lg.rectangle("fill", 0, lg.getHeight()*((1/data.ui.songlist.height-1)/(1/data.ui.songlist.height)),  lg.getWidth(), lg.getHeight()*data.ui.songlist.height)
		lg.setColor(255,255,255,255)
		
		lg.printf({{223, 196, 125, 255},
			data.cache[data.ui.songlist.current].source .. " - " .. data.cache[data.ui.songlist.current].artist .. " - " .. data.cache[data.ui.songlist.current].title .. " [" .. data.cache[data.ui.songlist.current].difficulity .. "] " .. data.cache[data.ui.songlist.current].creator
		}, 0, 0, lg.getWidth())
		
		
		
		lg.setColor(255,255,255,255)
		lg.line(0, lg.getHeight()*data.ui.songlist.height, lg.getWidth(), lg.getHeight()*data.ui.songlist.height)
		lg.line(0, lg.getHeight()*((1/data.ui.songlist.height-1)/(1/data.ui.songlist.height)), lg.getWidth(), lg.getHeight()*((1/data.ui.songlist.height-1)/(1/data.ui.songlist.height)))
		
		lg.setColor(255,255,255,255)
		
		data.ui.songlist.playbutton.x = data.width / 6
		data.ui.songlist.playbutton.y = data.height / 2
		lg.setColor(220,220,204,255)
		lg.setFont(data.ui.songlist.playbutton.font)
		lg.circle("line", data.ui.songlist.playbutton.x, data.ui.songlist.playbutton.y, data.ui.songlist.playbutton.radius, 90)
		lg.setColor(255,255,255,255)
		lg.printf({{223, 196, 125, 255}, "play"}, 0, data.ui.songlist.playbutton.y - data.ui.songlist.playbutton.fontsize * (3/4), data.ui.songlist.playbutton.x*2, "center")
		function love.mousepressed(x, y, button, istouch)
			if (x - data.ui.songlist.playbutton.x)^2 + (y - data.ui.songlist.playbutton.y)^2 <= data.ui.songlist.playbutton.radius^2 then
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = data.ui.songlist.current
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		end
		function love.wheelmoved(x, y)
			if y > 0 then
				if data.ui.songlist.scroll < 2 and data.ui.songlist.scroll >= -#data.cache + 3 then data.ui.songlist.scroll = data.ui.songlist.scroll + 1 end
			elseif y < 0 then
				if data.ui.songlist.scroll <= 2 and data.ui.songlist.scroll > -#data.cache + 3 then data.ui.songlist.scroll = data.ui.songlist.scroll - 1 end
			end
		end
	end
end

function uiClass.play(self)

end

function uiClass.pause(self)

end

function uiClass.fail(self)

end

function uiClass.ruler(self)
	local step = 100
	lg.setColor(220,220,204,255)
	for i = 1, math.ceil(lg.getHeight()/step) do
		lg.line(0, step * i, lg.getWidth(),  step * i)
	end
	for i = 1, math.ceil(lg.getWidth()/step) do
		lg.line(step * i, 0, step * i, lg.getHeight())
	end
end


function uiClass.simplemenu(self)
	lg.setFont(data.ui.mainmenu.logo.font)
	local mode = data.ui.mode
	local buttoncount = 3
	local offset = data.ui.simplemenu.offset
	local menuItems = data.ui.simplemenu.menu[data.ui.simplemenu.state]
	data.ui.buttoncoords = {}

	local buttonheight = nil
	
	if data.ui.simplemenu.onscreen then
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
			if data.ui.mode == 1 then
				data.ui.buttoncoords[i] = {
					{offset * lg.getHeight() + (i - 1) * (offset * lg.getHeight() + buttonheight), offset * lg.getHeight()},
					{offset * lg.getHeight() + (i - 1) * (offset * lg.getHeight() + buttonheight) + buttonheight, lg.getHeight()*(1 - offset)}
				}
			elseif data.ui.mode == 0 then
				data.ui.buttoncoords[i] = {
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
	if data.ui.simplemenu.onscreen == false and data.beatmap.audio then
		function love.mousepressed(x, y, button, istouch)
			data.ui.simplemenu.onscreen = true
			data.ui.simplemenu.state = "pause"
			osu:pause()
		end
	end
end
