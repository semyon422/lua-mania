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
	lg = love.graphics
	lm = love.mouse
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
		--globalscale = lg.getHeight()/(36*4),
		globalscale = 1,
		mode = "pc",
		play = 0,
		offset = {
			x = 100,
			y =  0
		},
		dt = 0,
		hud = {
			frame = 0,
			fps = 0,
			mode = "normal"
		},
		height = lg.getWidth(),
		width = lg.getHeight(),
		
		cache = require "res.Songs.cache",
		currentmapset = 2,
		currentbeatmap = 1,
		fontsize = lg.getWidth()/16,
		debugscale = 1,
		mark = 0,
		marks = {0,0,0,0,0,0},
		combo = 0,
		keylocks = {},
		stage = 1, --1-mm, 2-sl, 3-p
		mainmenu = {
			logoradius = 1/3*lg.getHeight(),
			logofontsize = lg.getHeight()/18,
			logofont = lg.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", lg.getHeight()/18),
			logoscale = 1,
			coordX = lg.getWidth()/2,
			coordY = lg.getHeight()/2,
			buttonradius = 1/9*lg.getHeight(),
		},
		cursor = {
			mx = 0,
			my = 0,
			radiusin = 10,
			radiusout = 20,
		},
		od = {16, 64, 97, 127, 151, 188}
	}
	data.mainmenu.buttoncoords = {
		[1] = {lg.getWidth()/2 + 1.1 * data.mainmenu.buttonradius, lg.getHeight()/2 - 1.1 * data.mainmenu.buttonradius},
		[2] = {lg.getWidth()/2 + 1.1 * lg.getHeight()/3, lg.getHeight()/2 - 1.1 * data.mainmenu.buttonradius},
		[3] = {lg.getWidth()/2 + 1.1 * data.mainmenu.buttonradius, lg.getHeight()/2 + 1.1 * data.mainmenu.buttonradius},
	}
	data.mainmenu.buttonactions = {
		[1] = function() data.ui.currentMenu = "songs1"; data.ui.menuState = true; data.stage = 2 end,
		[2] = function() data.ui.currentMenu = "options"; data.ui.menuState = true end,
		[3] = function() love.event.quit() end,
	}
	data.font = lg.newFont("res/OpenSansLight.ttf", lg.getWidth()/24)
	lg.setFont(data.font)
	osu = osuClass.new(data)
	ui = uiClass.new(data.ui)
	
	
	osu:loadSkin("res/Skins/skin-1")
	--data.menu.sprite = lg.newImage("res/mania-menu.png")
	--data.menu.backsprite = lg.newImage("res/back.png")
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
	
	lg.setBackgroundColor(63,63,63)
	lg.setColor(255,255,255,255)
	love.mouse.setVisible(false)
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
		data.height = lg.getWidth()
		data.width = lg.getHeight()
		data.globalscale = lg.getHeight()/(36*4)
		lg.rotate(-math.pi/2)
		lg.translate(-lg.getHeight(), 0)
	else
		data.height = lg.getHeight()
		data.width = lg.getWidth()
		data.globalscale = 2
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
	
	lg.setColor(220,220,204,255)
	lg.circle("line", data.cursor.mx, data.cursor.my, data.cursor.radiusout, 90)
	lg.setColor(223, 196, 125, 255)
	lg.circle("line", data.cursor.mx, data.cursor.my, data.cursor.radiusin, 90)
	lg.setColor(255,255,255,255)
end

function love.mousemoved(x, y, dx, dy)
	data.cursor.mx = x
	data.cursor.my = y
end