--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local mainMenu = {}

mainMenu.state = 1

mainMenu.buttons = {
	[1] = {
		[1] = {
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2,
			r = 50,
			type = "line",
			color = {220, 220, 204},
			text = "lua-mania",
			textColor = {223, 196, 125},
			font = luaMania.graphics.fonts.logo
		}
	}
}


	
mainMenu.states = {
	[1] = {
		draw = {{{	class = "rectangle",
					w = love.graphics.getWidth(),
					h = love.graphics.getHeight(),
					color = {63, 63, 63}}},
				{{	class = "circle",
					x = mainMenu.buttons[1][1].x,
					y = mainMenu.buttons[1][1].y,
					r = mainMenu.buttons[1][1].r,
					color = mainMenu.buttons[1][1].color,
					type = mainMenu.buttons[1][1].type},
				{	class = "text",
					align = "center",
					y = mainMenu.buttons[1][1].y - mainMenu.buttons[1][1].font.fontsize * (3/4),
					text = mainMenu.buttons[1][1].text,
					color = mainMenu.buttons[1][1].textColor}}},
		actionState = 0,
		action = function()
			function love.mousepressed(x, y, button, istouch)
				if (x - mainMenu.buttons[1][1].x)^2 + (y - mainMenu.buttons[1][1].y)^2 <= mainMenu.buttons[1][1].radius^2 then
					mainMenu.state = 2
				end
			end
			mainMenu.states[1].actionState = 1
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
	}
}

mainMenu.update = function()
	if mainMenu.states[1].actionState == 0 then
		mainMenu.states[mainMenu.state].action()
	end
	
	for layer = 1, #mainMenu.states[mainMenu.state].draw do
		for index = 1, #mainMenu.states[mainMenu.state].draw[layer] do
			luaMania.graphics.objects[layer] = luaMania.graphics.objects[layer] or {}
			table.insert(luaMania.graphics.objects[layer], mainMenu.states[mainMenu.state].draw[layer][index])
		end
	end
end

return mainMenu
