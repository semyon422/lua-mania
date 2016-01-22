local circlemenu = {
	["mainmenu1"] = {
		action = function()
			lg.setColor(220,220,204,255)
			lg.setFont(data.mainmenu.logofont)
			lg.circle("line", data.mainmenu.coordX, data.mainmenu.coordY, data.mainmenu.logoradius, 90)
			lg.setColor(255,255,255,255)
			lg.printf({{223, 196, 125, 255}, "lua-mania"}, 0, data.mainmenu.coordY - data.mainmenu.logofontsize * (3/4) * data.mainmenu.logoscale, data.mainmenu.coordX*2/data.mainmenu.logoscale, "center", 0, data.mainmenu.logoscale, data.mainmenu.logoscale)
			function love.mousepressed(x, y, button, istouch)
				if (x - data.mainmenu.coordX)^2 + (y - data.mainmenu.coordY)^2 <= data.mainmenu.logoradius^2 then
					data.mainmenu.logoradius = data.mainmenu.logoradius * 0.70
					data.mainmenu.coordX = lg.getWidth()/2 - 1.1 * data.mainmenu.logoradius
					data.ui.currentcircleMenu = "mainmenu2"
				end
			end
		end
	},
	["mainmenu2"] = {
		action = function()
			lg.setColor(220,220,204,255)
			lg.setFont(data.mainmenu.logofont)
			lg.circle("line", data.mainmenu.coordX, data.mainmenu.coordY, data.mainmenu.logoradius, 90)
			lg.circle("line", data.mainmenu.buttoncoords[1][1], data.mainmenu.buttoncoords[1][2], data.mainmenu.buttonradius, 90)
			lg.circle("line", data.mainmenu.buttoncoords[2][1], data.mainmenu.buttoncoords[2][2], data.mainmenu.buttonradius, 90)
			lg.circle("line", data.mainmenu.buttoncoords[3][1], data.mainmenu.buttoncoords[3][2], data.mainmenu.buttonradius, 90)
			lg.setColor(255,255,255,255)
			lg.printf({{223, 196, 125, 255}, "lua-mania"}, 0, data.mainmenu.coordY - data.mainmenu.logofontsize * (3/4) * data.mainmenu.logoscale, data.mainmenu.coordX*2/data.mainmenu.logoscale, "center", 0, data.mainmenu.logoscale, data.mainmenu.logoscale)
			lg.printf({{223, 196, 125, 255}, "play"}, 0, data.mainmenu.buttoncoords[1][2] - data.mainmenu.logofontsize * (3/4), data.mainmenu.buttoncoords[1][1]*2, "center", 0)
			lg.printf({{223, 196, 125, 255}, "options"}, 0, data.mainmenu.buttoncoords[2][2] - data.mainmenu.logofontsize * (3/4), data.mainmenu.buttoncoords[2][1]*2, "center", 0)
			lg.printf({{223, 196, 125, 255}, "exit"}, 0, data.mainmenu.buttoncoords[3][2] - data.mainmenu.logofontsize * (3/4), data.mainmenu.buttoncoords[3][1]*2, "center", 0)
			function love.mousepressed(x, y, button, istouch)
				if (x - data.mainmenu.coordX)^2 + (y - data.mainmenu.coordY)^2 <= data.mainmenu.logoradius^2 then
					data.mainmenu.logoradius = data.mainmenu.logoradius / 0.70
					data.mainmenu.coordX = lg.getWidth()/2
					data.ui.currentcircleMenu = "mainmenu1"
				end
				for i = 1, #data.mainmenu.buttoncoords do
					if (x - data.mainmenu.buttoncoords[i][1])^2 + (y - data.mainmenu.buttoncoords[i][2])^2 <= data.mainmenu.buttonradius^2 then
						data.mainmenu.buttonactions[i]()
					end
				end
			end
		end
	},
	
}

return circlemenu
