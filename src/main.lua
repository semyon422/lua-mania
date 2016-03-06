--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
function love.load()
	lg = love.graphics
	lm = love.mouse
	pathprefix = "src/"
	mappathprefix = ""
	require(pathprefix .. "osu")
	require(pathprefix .. "ui")
	data = {
		ui = {
			state = 1,
			mode = 0,
			debug = false,
			ruler = false,
			
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
			songlist = {
				playbutton = {
					radius = 1/6 * lg.getHeight(),
					fontsize = lg.getHeight() / 18,
					font = lg.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", lg.getHeight() / 18),
					x = lg.getWidth() / 6,
					y = lg.getHeight() / 2,
					scale = 1
				},
				scroll = 0,
				height = 1/8,
				offset = 16,
				buttonCount = 5,
				fontsize = lg.getHeight() / 27,
				font = lg.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", lg.getHeight() / 27),
				current = 1,
			},
		},
		drawedNotes = 0,
		skin = {},
		keyboard = require(pathprefix .. "keyboard"),
		beatmap = {},
		play = 0,
		dt = 0,
		height = lg.getWidth(),
		width = lg.getHeight(),
		beatradius = 1,
		autoplay = 0,
		cache = {},
		BMFList = {},
		currentbeatmap = 1,
		keylocks = {},
		keyhits = {},
		config = {
			backgroundDarkness = 0,
			speed = 1,
			globalscale = 1,
			offset = 0,
			hitPosition = 100,
			pitch = 1,
			preview = 2000,
			fullscreen = false,
			skinname = "res/Skins/skin-1",
		},
		cursor = {
			x = 0,
			y = 0,
			radiusin = 10,
			radiusout = 20,
		},
		od = {16, 64, 97, 127, 151, 188},
		--od = {1, 2, 3, 4, 5, 200},
		--od = {1, 2, 3, 4, 200, 202},
		stats = {
			currentTime = 0,
			hits = {0,0,0,0,0,0},
			mismatch = {},
			averageMismatch = {
				value = 0,
				count = 0,
				maxCount = 20
			},
			lastHit = 0,
			combo = 0,
			maxcombo = 0,
			speed = nil
		},
		audioFormats = {"wav","ogg","mp3"},
		objects = {}
	}
	data.font = lg.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", lg.getWidth()/24)
	lg.setFont(data.font)
	osu = osuClass.new(data)
	ui = uiClass.new(data)
	
	osu:loadSkin(data.config.skinname)
	
	if love.system.getOS() == "Windows" then
		mappathprefix = ""
		data.ui.mode = 0
	elseif love.system.getOS() == "Android" then
		mappathprefix = "/sdcard/lovegame/"
		data.ui.mode = 1
		data.config.hitPosition = lg.getWidth() * 1/10
	else
		mappathprefix = ""
	end
	
	osu:genCache()
	
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
	data.height = lg.getHeight()
	data.width = lg.getWidth()
	data.config.globalscale = 2
	local globalscale = data.config.globalscale
	
	osu:drawObjects()
	data.objects = {{},{},{},{},{}}
	
	if data.ui.state == 1 then
		ui:mainmenu()
	elseif data.ui.state == 2 then
		ui:songs()
	elseif data.ui.state == 3 then
		if data.ui.mode == 1 then
			data.height = lg.getWidth()
			data.width = lg.getHeight()
			data.skin.config.ColumnStart[data.beatmap.info.keymode] = 0
			data.config.globalscale = lg.getHeight()/(skin.config.ColumnWidth[data.beatmap.info.keymode][1]*data.beatmap.info.keymode)
			lg.rotate(-math.pi/2)
			lg.translate(-lg.getHeight(), 0)
		end
		osu:getObjects()
		osu:drawHUD()
		ui:simplemenu()
		keymode = data.beatmap.info.keymode
		lg.setColor(223, 196, 125, 128)
		lg.line(globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode]), data.height - data.config.hitPosition - data.config.offset*data.config.speed, globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode] + keymode*skin.config.ColumnWidth[keymode][1]), data.height - data.config.hitPosition - data.config.offset*data.config.speed)
		lg.setColor(220,220,204,255)
		lg.line(globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode]), data.height - data.config.hitPosition, globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode] + keymode*skin.config.ColumnWidth[keymode][1]), data.height - data.config.hitPosition)
		
		--lg.setColor(255,255,0,255)
		--lg.line(globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode]), lg.getHeight() - data.config.hitPosition/data.config.speed, globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode] + keymode*skin.config.ColumnWidth[keymode][1]), lg.getHeight() - data.config.hitPosition/data.config.speed)
		
		if data.ui.mode == 1 then 
			lg.setColor(220,220,204,255)
			lg.circle("line", data.width-data.cursor.y, data.cursor.x, data.cursor.radiusout, 90)
			lg.setColor(223, 196, 125, 255)
			lg.circle("line", data.width-data.cursor.y, data.cursor.x, data.cursor.radiusin, 90)
			lg.setColor(255,255,255,255)
		end
	end
	
	if data.ui.ruler then ui:ruler() end
	if data.ui.state ~= 3 or data.ui.mode == 0 then
		lg.setColor(220,220,204,255)
		lg.circle("line", data.cursor.x, data.cursor.y, data.cursor.radiusout, 90)
		lg.setColor(223, 196, 125, 255)
		lg.circle("line", data.cursor.x, data.cursor.y, data.cursor.radiusin, 90)
		lg.setColor(255,255,255,255)
	end
end

function love.mousemoved(x, y, dx, dy)
	data.cursor.x = x
	data.cursor.y = y
end