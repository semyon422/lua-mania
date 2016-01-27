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
			state = 1,
			mode = 0,
			debug = false,
			
			mainmenu = {
				state = 1,
				menu = require(pathprefix .. "mainmenu"),
				logo = {
					radius = 1/3 * lg.getHeight(),
					fontsize = lg.getHeight() / 18,
					font = lg.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", lg.getHeight() / 18),
					x = lg.getWidth() / 2,
					y = lg.getHeight() / 2,
					scale = 1
				},
				button = {
					radius = 1 / 9 * lg.getHeight(),
				}
			},
			
			simplemenu = {
				state = "empty",
				menu = require(pathprefix .. "simplemenu"),
				onscreen = false,
				offset = 1/16,
			},
		},
		drawedNotes = 0,
		skin = {},
		keyboard = require(pathprefix .. "keyboard"),
		darkness = 60,
		beatmap = {},
		currentnotes = {{},{},{},{}},
		currentsliders = {},
		scroll = 0,
		speed = 1,
		globalscale = 1,
		play = 0,
		offset = 0,
		hitPosition = 100,
		dt = 0,
		height = lg.getWidth(),
		width = lg.getHeight(),
		
		cache = {},
		BMFList = {},
		currentmapset = 2,
		currentbeatmap = 1,
		fontsize = lg.getWidth()/16,
		debugscale = 1,
		mark = 0,
		marks = {0,0,0,0,0,0},
		averageMs = 0,
		averageOffset = 0,
		averageOffsetCount = 0,
		lastMs = 0,
		mso = 0,
		hitCount = 0,
		combo = 0,
		keylocks = {},
		mainmenu = {
			
		},
		cursor = {
			mx = 0,
			my = 0,
			radiusin = 10,
			radiusout = 20,
		},
		od = {16, 64, 97, 127, 151, 188}
	}
	data.font = lg.newFont("res/OpenSansLight.ttf", lg.getWidth()/24)
	lg.setFont(data.font)
	osu = osuClass.new(data)
	ui = uiClass.new(data.ui)
	
	
	osu:loadSkin("res/Skins/skin-1")
	
	if love.system.getOS() == "Windows" then
		mappathprefix = ""
		data.ui.mode = 0
	elseif love.system.getOS() == "Android" then
		mappathprefix = "/sdcard/lovegame/"
		data.ui.mode = 1
	else
		mappathprefix = ""
	end
	
	osu:getBeatmapFileList()
	
	osu:generateBeatmapCache()
	
	for q,w in pairs(data.cache) do
		print(q .. " => " .. w.title .. " | " .. w.difficulity)
	end
	
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
	
	if data.ui.state == 1 then
		ui:mainmenu()
		ui:simplemenu()
	elseif data.ui.state == 2 then
		ui:songs()
	elseif data.ui.state == 3 then
		osu:drawUI()
		osu:drawNotes()
		osu:drawHUD()
		ui:simplemenu()
		lg.setColor(223, 196, 125, 255)
		--lg.line(0, lg.getHeight() - data.hitPosition - data.offset, lg.getWidth(), lg.getHeight() - data.hitPosition - data.offset)
		lg.setColor(220,220,204,255)
		lg.line(0, lg.getHeight() - data.hitPosition, lg.getWidth(), lg.getHeight() - data.hitPosition)
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