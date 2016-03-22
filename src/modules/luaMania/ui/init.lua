local ui = {
	state = "mainMenu",
	mode = 0,
	
	states = {
		mainMenu = require("luaMania.ui.states.mainMenu"),
		songList = require("luaMania.ui.states.songList"),
	},
	
	update = function()
		luaMania.ui.states[luaMania.ui.state].update()
	end,
	
	songList = {
		playbutton = {
			radius = 1/6 * love.graphics.getHeight(),
			fontsize = love.graphics.getHeight() / 18,
			font = love.graphics.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", love.graphics.getHeight() / 18),
			x = love.graphics.getWidth() / 6,
			y = love.graphics.getHeight() / 2,
			scale = 1
		},
		scroll = 0,
		height = 1/8,
		offset = 16,
		buttonCount = 5,
		fontsize = love.graphics.getHeight() / 27,
		font = love.graphics.newFont("res/fonts/OpenSans/OpenSansLight/OpenSansLight.ttf", love.graphics.getHeight() / 27),
		current = 1,
	},
	
}

ui.keyboard = {
	{
		keys = {"return"},
		actionHit = function()
			
		end
	},
	{
		keys = {"up"},
		actionHit = function()
			if ui.states.songList.cachePosition < #luaMania.data.cache then
				ui.states.songList.cachePosition = ui.states.songList.cachePosition + 1
			end
		end
	},
	{
		keys = {"down"},
		actionHit = function()
			if ui.states.songList.cachePosition > 1 then
				ui.states.songList.cachePosition = ui.states.songList.cachePosition - 1
			end
		end
	}
}

return ui