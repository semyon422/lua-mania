local mainmenu = {
	[1] = {
		action = function()
			data.ui.mainmenu.logo.x = lg.getWidth() / 2
			data.ui.mainmenu.logo.y = lg.getHeight() / 2
			lg.setColor(220,220,204,255)
			lg.setFont(data.ui.mainmenu.logo.font)
			lg.circle("line", data.ui.mainmenu.logo.x, data.ui.mainmenu.logo.y, data.ui.mainmenu.logo.radius, 90)
			lg.setColor(255,255,255,255)
			lg.printf({{223, 196, 125, 255}, "lua-mania"}, 0, data.ui.mainmenu.logo.y - data.ui.mainmenu.logo.fontsize * (3/4), data.ui.mainmenu.logo.x*2, "center")
			function love.mousepressed(x, y, button, istouch)
				if (x - data.ui.mainmenu.logo.x)^2 + (y - data.ui.mainmenu.logo.y)^2 <= data.ui.mainmenu.logo.radius^2 then
					data.ui.mainmenu.logo.radius = data.ui.mainmenu.logo.radius * 0.70
					data.ui.mainmenu.logo.x = lg.getWidth()/2 - 1.1 * data.ui.mainmenu.logo.radius
					data.ui.mainmenu.state = 2
				end
			end
		end
	},
	[2] = {
		action = function()
			data.ui.mainmenu.button.radius = 1 / 9 * lg.getHeight() * (data.ui.mainmenu.logo.fontsize/(lg.getHeight() / 18))
			data.ui.mainmenu.logo.x = lg.getWidth()/2 - 1.1 * data.ui.mainmenu.logo.radius
			data.ui.mainmenu.logo.y = lg.getHeight() / 2
			
			lg.setColor(220,220,204,255)
			lg.setFont(data.ui.mainmenu.logo.font)
			
			buttons = {
				[1] = {
					text = {{223, 196, 125, 255}, "play"},
					action = function()
						data.ui.simplemenu.state = "songs1"
						data.ui.simplemenu.onscreen = true
						data.ui.state = 2
					end,
					x = lg.getWidth()/2 + 1.1 * data.ui.mainmenu.button.radius,
					y = lg.getHeight()/2 - 1.1 * data.ui.mainmenu.button.radius
				},
				[2] = {
					text = {{223, 196, 125, 255}, "options"},
					action = function()
						data.ui.mainmenu.state = 3
					end,
					x = lg.getWidth()/2 + 1.1 * data.ui.mainmenu.button.radius * 3,
					y = lg.getHeight()/2 - 1.1 * data.ui.mainmenu.button.radius
				},
				[3] = {
					text = {{223, 196, 125, 255}, "exit"},
					action = function()
						love.event.quit()
					end,
					x = lg.getWidth()/2 + 1.1 * data.ui.mainmenu.button.radius,
					y = lg.getHeight()/2 + 1.1 * data.ui.mainmenu.button.radius
				}
			}
			
			lg.setColor(255,255,255,255)
			lg.circle("line", data.ui.mainmenu.logo.x, data.ui.mainmenu.logo.y, data.ui.mainmenu.logo.radius, 90)
			lg.printf({{223, 196, 125, 255}, "lua-mania"}, 0, data.ui.mainmenu.logo.y - data.ui.mainmenu.logo.fontsize * (3/4) * data.ui.mainmenu.logo.scale, data.ui.mainmenu.logo.x * 2 / data.ui.mainmenu.logo.scale, "center", 0, data.ui.mainmenu.logo.scale, data.ui.mainmenu.logo.scale)
			
			for index,button in pairs(buttons) do
				lg.circle("line", button.x, button.y, data.ui.mainmenu.button.radius, 90)
				lg.printf(button.text, 0, (button.y) - data.ui.mainmenu.logo.fontsize * (3/4), (button.x)*2, "center", 0)
			end
			
			function love.mousepressed(x, y, button, istouch)
				if (x - data.ui.mainmenu.logo.x)^2 + (y - data.ui.mainmenu.logo.y)^2 <= data.ui.mainmenu.logo.radius^2 then
					data.ui.mainmenu.logo.radius = data.ui.mainmenu.logo.radius / 0.70
					data.ui.mainmenu.logo.x = lg.getWidth()/2
					data.ui.mainmenu.state = 1
				end
				for index,button in pairs(buttons) do
					if (x - button.x)^2 + (y - button.y)^2 <= data.ui.mainmenu.button.radius^2 then
						button.action()
					end
				end
			end
		end
	},
	[3] = {
		action = function()
			data.ui.mainmenu.button.radius = 1 / 9 * lg.getHeight() * (data.ui.mainmenu.logo.fontsize/(lg.getHeight() / 18))
			data.ui.mainmenu.logo.x = lg.getWidth()/2 - 1.1 * data.ui.mainmenu.logo.radius
			data.ui.mainmenu.logo.y = lg.getHeight() / 2
			
			lg.setColor(220,220,204,255)
			lg.setFont(data.ui.mainmenu.logo.font)
			
			buttons = {
				[1] = {
					text = {{223, 196, 125, 255}, "speed"},
					action = function()
						data.ui.mainmenu.state = 4
					end,
					x = lg.getWidth()/2 - 1.1 * data.ui.mainmenu.button.radius,
					y = lg.getHeight()/2
				},
				[2] = {
					text = {{223, 196, 125, 255}, "back"},
					action = function()
						data.ui.mainmenu.state = 2
					end,
					x = lg.getWidth()/2 + 1.1 * data.ui.mainmenu.button.radius,
					y = lg.getHeight()/2
				}
			}
			
			lg.setColor(255,255,255,255)
			
			for index,button in pairs(buttons) do
				lg.circle("line", button.x, button.y, data.ui.mainmenu.button.radius, 90)
				lg.printf(button.text, 0, (button.y) - data.ui.mainmenu.logo.fontsize * (3/4), (button.x)*2, "center", 0)
			end
			
			function love.mousepressed(x, y, button, istouch)
				for index,button in pairs(buttons) do
					if (x - button.x)^2 + (y - button.y)^2 <= data.ui.mainmenu.button.radius^2 then
						button.action()
					end
				end
			end
		end
	},
	[4] = {
		action = function()
			data.ui.mainmenu.button.radius = 1 / 9 * lg.getHeight() * (data.ui.mainmenu.logo.fontsize/(lg.getHeight() / 18))
			data.ui.mainmenu.logo.x = lg.getWidth()/2 - 1.1 * data.ui.mainmenu.logo.radius
			data.ui.mainmenu.logo.y = lg.getHeight() / 2
			
			lg.setColor(220,220,204,255)
			lg.setFont(data.ui.mainmenu.logo.font)
			
			buttons = {
				[1] = {
					text = {{223, 196, 125, 255}, "+"},
					action = function()
						--data.speed = data.speed + 0.1
					end,
					x = lg.getWidth()/2 - 1.1 * data.ui.mainmenu.button.radius,
					y = lg.getHeight()/2 - 1.1 * data.ui.mainmenu.button.radius,
				},
				[2] = {
					text = {{223, 196, 125, 255}, "-"},
					action = function()
						--data.speed = data.speed - 0.1
					end,
					x = lg.getWidth()/2 + 1.1 * data.ui.mainmenu.button.radius,
					y = lg.getHeight()/2 - 1.1 * data.ui.mainmenu.button.radius,
				},
				[3] = {
					text = {{223, 196, 125, 255}, "back"},
					action = function()
						data.ui.mainmenu.state = 3
					end,
					x = lg.getWidth()/2,
					y = lg.getHeight()/2 + 1.1 * data.ui.mainmenu.button.radius / (2 * 0.5773)
				}
			}
			
			lg.setColor(255,255,255,255)
			
			for index,button in pairs(buttons) do
				lg.circle("line", button.x, button.y, data.ui.mainmenu.button.radius, 90)
				lg.printf(button.text, 0, (button.y) - data.ui.mainmenu.logo.fontsize * (3/4), (button.x)*2, "center", 0)
			end
			
			function love.mousepressed(x, y, button, istouch)
				for index,button in pairs(buttons) do
					if (x - button.x)^2 + (y - button.y)^2 <= data.ui.mainmenu.button.radius^2 then
						button.action()
					end
				end
			end
		end
	},
	
}
return mainmenu
