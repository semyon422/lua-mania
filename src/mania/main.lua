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
			circlemenu = require(pathprefix .. "circlemenu"),
			currentMenu = "mainMenu",
			mode = 0,
			buttoncount = 6,
			offset = 1/16,
			menuState = false,
			currentcircleMenu = "mainmenu1"
		},
		debug = false,
		drawedNotes = 0,
		skin = {},
		keyboard = require(pathprefix .. "keyboard"),
		darkness = 60,
		beatmap = {},
		currentnotes = {{},{},{},{}},
		currentsliders = {},
		scroll = 0,
		speed = 1,
		globalscale = love.graphics.getHeight()/(36*4),
		mode = "pc",
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
		currentmapset = 2,
		currentbeatmap = 1,
		fontsize = love.graphics.getWidth()/16,
		debugscale = 1,
		mark = 0,
		marks = {0,0,0,0,0,0},
		combo = 0,
		keylocks = {},
		stage = 1, --1-mm, 2-sl, 3-p
		mainmenu = {
			logoradius = 1/3*love.graphics.getHeight(),
			logofontsize = love.graphics.getHeight()/18,
			logofont = love.graphics.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", love.graphics.getHeight()/18),
			logoscale = 1,
			coordX = love.graphics.getWidth()/2,
			coordY = love.graphics.getHeight()/2,
			buttonradius = 1/9*love.graphics.getHeight(),
		}
	}
	data.mainmenu.buttoncoords = {
		[1] = {love.graphics.getWidth()/2 + 1.1 * data.mainmenu.buttonradius, love.graphics.getHeight()/2 - 1.1 * data.mainmenu.buttonradius},
		[2] = {love.graphics.getWidth()/2 + 1.1 * love.graphics.getHeight()/3, love.graphics.getHeight()/2 - 1.1 * data.mainmenu.buttonradius},
		[3] = {love.graphics.getWidth()/2 + 1.1 * data.mainmenu.buttonradius, love.graphics.getHeight()/2 + 1.1 * data.mainmenu.buttonradius},
	}
	data.mainmenu.buttonactions = {
		[1] = function() data.ui.currentMenu = "songs1"; data.ui.menuState = true; data.stage = 2 end,
		[2] = function() data.ui.currentMenu = "options"; data.ui.menuState = true end,
		[3] = function() love.event.quit() end,
	}
	data.font = love.graphics.newFont("res/OpenSansLight.ttf", love.graphics.getWidth()/24)
	love.graphics.setFont(data.font)
	osu = osuClass.new(data)
	ui = uiClass.new(data.ui)
	
	
	osu:loadSkin("res/Skins/skin-1")
	--data.menu.sprite = love.graphics.newImage("res/mania-menu.png")
	--data.menu.backsprite = love.graphics.newImage("res/back.png")
	if love.system.getOS() == "Windows" then
		mappathprefix = ""
		data.ui.mode = 0
	elseif love.system.getOS() == "Android" then
		mappathprefix = "/sdcard/lovegame/"
		data.ui.mode = 1
	else
		mappathprefix = ""
	end
	
	--osu:loadBeatmap(mappathprefix .. "res/Songs/" .. data.cache[data.currentmapset].folder, data.cache[data.currentmapset].maps[data.currentbeatmap])
	
	--data.beatmap.audio = love.audio.newSource("res/Songs/" .. data.cache[data.currentmapset].folder .. "/" .. data.cache[data.currentmapset].audio)
	
	love.graphics.setBackgroundColor(63,63,63)
	love.graphics.setColor(255,255,255,255)
	loaded = true
end
function love.update(dt)
	if loaded ~= true then love.load() end
	data.dt = dt
	osu:keyboard()
	osu:beat(0)
	
end
function love.draw()
	if data.ui.mode == 1 then
		data.height = love.graphics.getWidth()
		data.width = love.graphics.getHeight()
		data.globalscale = love.graphics.getHeight()/(36*4)
		love.graphics.rotate(-math.pi/2)
		love.graphics.translate(-love.graphics.getHeight(), 0)
	else
		data.height = love.graphics.getHeight()
		data.width = love.graphics.getWidth()
		data.globalscale = love.graphics.getWidth()/(36*4)
	end
	--osu:drawBackground()
	if data.stage == 1 then
	ui:mainMenu()
	ui:menu()
	elseif data.stage == 2 then
	ui:songs()
	
	elseif data.stage == 3 then
	osu:drawUI()
	osu:drawNotes()
	osu:drawHUD()
	ui:menu()
	
	end
end