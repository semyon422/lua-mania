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
	pathprefix = "src/mania/"
	mappathprefix = ""
	require(pathprefix .. "osu")
	data = {
		mania = {},
		ui = {},
		skin = {},
		keyboard = require(pathprefix .. "keyboard"),
		darkness = 60,
		beatmap = {},
		scroll = 0,
		speed = 1,
		offset = 0,
		--globalscale = 1.56,
		globalscale = love.graphics.getHeight()/(36*4),
		
		play = 0,
		offset = {
		--	x = skin.config.Mania[tonumber(Map.General["CircleSize"]) .. "K"].Column.Start,
			x = 100,
			y = 0
		},
		dt = 0,
		hud = {
			frame = 0,
			fps = 0,
			mode = "normal"
		},
		height = love.graphics.getWidth(),
		width = love.graphics.getHeight(),
		menukeystate = 0,
		menustate = 0,
		menustatename = "rotation: stop start pause play",
		menunextstatename = "stop",
		menu = {
			state = "hidden",
			control = "touch", --or "button",
			buttons = {
				{
					name = "stop",
					coords = {{1/8*love.graphics.getHeight(), 1/8*love.graphics.getHeight()}, {4/8*love.graphics.getHeight(), 4/8*love.graphics.getHeight()}},
					action = function() osu:stop() end 
				},
				{
					name = "pause",
					coords = {{4/8*love.graphics.getHeight(), 1/8*love.graphics.getHeight()}, {7/8*love.graphics.getHeight(), 4/8*love.graphics.getHeight()}},
					action = function() osu:pause() end 
				},
				{
					name = "start",
					coords = {{1/8*love.graphics.getHeight(), 4/8*love.graphics.getHeight()}, {4/8*love.graphics.getHeight(), 7/8*love.graphics.getHeight()}},
					action = function() osu:start() end 
				},
				{
					name = "play",
					coords = {{4/8*love.graphics.getHeight(), 4/8*love.graphics.getHeight()}, {7/8*love.graphics.getHeight(), 7/8*love.graphics.getHeight()}},
					action = function() osu:play() end 
				},
				{
					name = "back",
					coords = {{love.graphics.getHeight(), 0}, {love.graphics.getWidth(), love.graphics.getHeight()}},
					action = function() data.menu.state = "hidden" end 
				},
			},
			sprite = nil,
		},
		cache = require "res.Songs.cache",
		currentmapset = 1,
		currentbeatmap = 1,
	}
	osu = osuClass.new(data)
	
	
	osu:loadSkin("res/Skins/skin")
	data.menu.sprite = love.graphics.newImage("res/mania-menu.png")
	data.menu.backsprite = love.graphics.newImage("res/back.png")
	if love.system.getOS() == "Windows" then
		mappathprefix = ""
	elseif love.system.getOS() == "Android" then
		mappathprefix = "/sdcard/lovegame/"
	else
		mappathprefix = ""
	end
	
osu:loadBeatmap(mappathprefix .. "res/Songs/" .. data.cache[data.currentmapset].folder, data.cache[data.currentmapset].maps[data.currentbeatmap])
	
	
	data.beatmap.audio = love.audio.newSource("res/Songs/" .. data.cache[data.currentmapset].folder .. "/" .. data.cache[data.currentmapset].audio)
	--beatmap.files.mp3:play()
	--beatmap.files.mp3:pause()
	
	loaded = true
end
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
function love.update(dt)
	if loaded ~= true then love.load() end
	data.dt = dt
	--data.update.truedt = dt

	osu:keyboard()
	

	osu:updateHUD()
end
function love.draw()
	--data.ui.bg(menu_background, darkness)
	love.graphics.rotate(-math.pi/2)
	love.graphics.translate(-love.graphics.getHeight(), 0)
	osu:drawBackground()
	osu:drawUI()
	osu:drawNotes()
	osu:drawHUD()
	osu:drawMenu()
end
function love.mousepressed(x, y, button, istouch)
	if data.menu.control == "touch" then
		if data.menu.state == "hidden" then
			data.menu.state = "onscreen"
		elseif data.menu.state == "onscreen" then
			for index,button in pairs(data.menu.buttons) do
				if x > button.coords[1][1] and y > button.coords[1][2] and x < button.coords[2][1] and y < button.coords[2][2] then
					button.action()
				end
			end
		elseif data.menu.state == "minimized" then
		
		end
	end
end
