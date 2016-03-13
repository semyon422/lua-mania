--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
function love.load()
	pathprefix = "src/"
	mappathprefix = ""
	luaMania = require("luaMania")
	luaMania.load()
	
	love.mouse.setVisible(false)
end
function love.update(dt)
	luaMania.update()
	-- data.dt = dt
	-- osu:keyboard()
end
function love.draw()
	luaMania.draw.allObjects()
	-- data.height = lg.getHeight()
	-- data.width = lg.getWidth()
	-- data.config.globalscale = 2
	-- local globalscale = data.config.globalscale
	
	-- if data.ui.state == 1 then
		-- ui:mainmenu()
	-- elseif data.ui.state == 2 then
		-- ui:songs()
	-- elseif data.ui.state == 3 then
		-- if data.ui.mode == 1 then
			-- data.height = lg.getWidth()
			-- data.width = lg.getHeight()
			-- data.skin.config.ColumnStart[data.beatmap.info.keymode] = 0
			-- data.config.globalscale = lg.getHeight()/(skin.config.ColumnWidth[data.beatmap.info.keymode][1]*data.beatmap.info.keymode)
			-- lg.rotate(-math.pi/2)
			-- lg.translate(-lg.getHeight(), 0)
		-- end
		-- osu:getObjects()
		-- osu:printDebugInfo()
		-- ui:simplemenu()
		-- keymode = data.beatmap.info.keymode
		-- lg.setColor(223, 196, 125, 128)
		-- lg.line(globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode]), data.height - data.config.hitPosition - data.config.offset*data.config.speed, globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode] + keymode*skin.config.ColumnWidth[keymode][1]), data.height - data.config.hitPosition - data.config.offset*data.config.speed)
		-- lg.setColor(220,220,204,255)
		-- lg.line(globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode]), data.height - data.config.hitPosition, globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode] + keymode*skin.config.ColumnWidth[keymode][1]), data.height - data.config.hitPosition)
		
		-- lg.setColor(255,255,0,255)
		-- lg.line(globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode]), lg.getHeight() - data.config.hitPosition/data.config.speed, globalscale*(skin.config.ColumnLineWidth[keymode][1] + skin.config.ColumnStart[keymode] + keymode*skin.config.ColumnWidth[keymode][1]), lg.getHeight() - data.config.hitPosition/data.config.speed)
		
		-- if data.ui.mode == 1 then 
			-- lg.setColor(220,220,204,255)
			-- lg.circle("line", data.width-data.cursor.y, data.cursor.x, data.cursor.radiusout, 90)
			-- lg.setColor(223, 196, 125, 255)
			-- lg.circle("line", data.width-data.cursor.y, data.cursor.x, data.cursor.radiusin, 90)
			-- lg.setColor(255,255,255,255)
		-- end
	-- end
	
	-- osu:drawObjects()
	-- data.objects = {{},{},{},{},{}}
	
	-- if data.ui.ruler then ui:ruler() end
	-- if luaMania.data.ui.state ~= 3 or luaMania.data.ui.mode == 0 then
		-- lg.setColor(220,220,204,255)
		-- lg.circle("line", data.cursor.x, data.cursor.y, data.cursor.radiusout, 90)
		-- lg.setColor(223, 196, 125, 255)
		-- lg.circle("line", data.cursor.x, data.cursor.y, data.cursor.radiusin, 90)
		-- lg.setColor(255,255,255,255)
	-- end
	-- if data.stats.x ~= nil then
		-- lg.circle("fill", data.stats.x, data.height, 20)
	-- end
end

function love.mousemoved(x, y, dx, dy)
	luaMania.graphics.cursor.x = x
	luaMania.graphics.cursor.y = y
end