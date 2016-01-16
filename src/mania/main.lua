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
	pathprefix = "src/mania/"
	mappathprefix = ""
	require(pathprefix .. "osu")
	require(pathprefix .. "ui")
	data = {
		mania = {},
		ui = {
			menu = require(pathprefix .. "menu"),
			currentMenu = "mainMenu",
			mode = "portrait",
			buttoncount = 6,
			offset = 1/16,
			menuState = true,
		},
		skin = {},
		keyboard = require(pathprefix .. "keyboard"),
		darkness = 60,
		beatmap = {},
		scroll = 0,
		speed = 1,
		globalscale = love.graphics.getHeight()/(36*4),
		mode = "smartphone",
		play = 0,
		offset = {
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
		
		cache = require "res.Songs.cache",
		currentmapset = 1,
		currentbeatmap = 1,
		font = love.graphics.newFont("res/OpenSansLight.ttf", love.graphics.getWidth()/16),
	}
	love.graphics.setFont(data.font)
	osu = osuClass.new(data)
	ui = uiClass.new(data.ui)
	
	
	osu:loadSkin("res/Skins/skin")
	--data.menu.sprite = love.graphics.newImage("res/mania-menu.png")
	--data.menu.backsprite = love.graphics.newImage("res/back.png")
	if love.system.getOS() == "Windows" then
		mappathprefix = ""
	elseif love.system.getOS() == "Android" then
		mappathprefix = "/sdcard/lovegame/"
	else
		mappathprefix = ""
	end
	
	osu:loadBeatmap(mappathprefix .. "res/Songs/" .. data.cache[data.currentmapset].folder, data.cache[data.currentmapset].maps[data.currentbeatmap])
	
	data.beatmap.audio = love.audio.newSource("res/Songs/" .. data.cache[data.currentmapset].folder .. "/" .. data.cache[data.currentmapset].audio)
	
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
	
	osu:keyboard()
end
function love.draw()
	love.graphics.rotate(-math.pi/2)
	love.graphics.translate(-love.graphics.getHeight(), 0)
	osu:drawBackground()
	osu:drawUI()
	osu:drawNotes()
	osu:drawHUD()
	--osu:drawMenu()
	ui:menu()
end