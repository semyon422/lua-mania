local menu = {
	["mainMenu"] = {
		title = "lua-mania",
		[1] = {
			text = "play",
			action = function() data.ui.currentMenu = "songs1" end
		},
		[2] = {
			text = "options",
			action = function() data.ui.currentMenu = "options" end
		},
		[3] = {
			text = "exit",
			action = function() love.event.quit() end
		}
	},
	["pause"] = {
		title = "pause",
		[1] = {
			text = "continue",
			action = function() osu:play(); data.ui.menuState = false end
		},
		[2] = {
			text = "retry",
			action = function() osu:start(); data.ui.menuState = false end
		},
		[3] = {
			text = "back to menu",
			action = function() osu:stop(); data.ui.currentMenu = "songs1" end
		}
	},
	["options"] = {
		title = "options",
		[1] = {
			text = "speed",
			action = function() data.ui.currentMenu = "speed"; end
		},
		[2] = {
			text = "debug",
			action = function() data.ui.currentMenu = "debug" end
		},
		[3] = {
			text = "skin",
			action = function() data.ui.currentMenu = "skin" end
		},
		[4] = {
			text = "back",
			action = function() data.ui.currentMenu = "mainMenu" end
		}
	},
	["speed"] = {
		title = "speed",
		[1] = {
			text = "speed up",
			action = function() data.speed = data.speed + 0.1 end
		},
		[2] = {
			text = "speed down",
			action = function() if data.speed > 0.2 then data.speed = data.speed - 0.1 end end
		},
		[3] = {
			text = "back",
			action = function() data.ui.currentMenu = "options" end
		}
	},
	["debug"] = {
		title = "speed",
		[1] = {
			text = "enable",
			action = function() data.debug = true end
		},
		[2] = {
			text = "disable",
			action = function() data.debug = false end
		},
		[3] = {
			text = "back",
			action = function() data.ui.currentMenu = "options" end
		}
	},
	["skin"] = {
		title = "skin",
		[1] = {
			text = "skin 1",
			action = function() osu:loadSkin("res/Skins/skin-1") end
		},
		[2] = {
			text = "skin 2",
			action = function() osu:loadSkin("res/Skins/skin-2") end
		},
		[3] = {
			text = "back",
			action = function() data.ui.currentMenu = "options" end
		}
	},
	["songs1"] = {
		title = "songs page 1",
		[1] = {
			text = "The First Part of Touhou EX Boss Rush!!",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(1,1)
				osu:play()
			end
		},
		[2] = {
			text = "Space Time",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(2,1)
				osu:play()
			end
		},
		[3] = {
			text = "Achromat",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(3,1)
				osu:play()
			end
		},
		[4] = {
			text = "Speedcore 300",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(4,1)
				osu:play()
			end
		},
		[5] = {
			text = "Kanshou no Matenrou",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(5,1)
				osu:play()
			end
		},
		[6] = {
			text = "next ->",
			action = function() data.ui.currentMenu = "songs2" end
		},
	},
	["songs2"] = {
		title = "songs page 2",
		[1] = {
			text = "C18H27NO3",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(6,1)
				osu:play()
			end
		},
		[2] = {
			text = "Deconstruction Star",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(7,1)
				osu:play()
			end
		},
		[3] = {
			text = "B.B.K.K.B.K.K.",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(8,1)
				osu:play()
			end
		},
		[4] = {
			text = "The Empress",
			action = function() 
				data.ui.menuState = false
				osu:reloadBeatmap(9,1)
				osu:play()
			end
		},
		[5] = {
			text = "main menu",
			action = function() data.ui.currentMenu = "mainMenu" end
		},
		[6] = {
			text = "back <-",
			action = function() data.ui.currentMenu = "songs1" end
		},
	},
	
}

return menu
