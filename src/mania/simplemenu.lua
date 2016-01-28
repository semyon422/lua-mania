local menu = {
	["empty"] = {
		title = "pause",
		[1] = {
			text = "",
			action = function() end
		},
	},
	["pause"] = {
		title = "pause",
		[1] = {
			text = "continue",
			action = function() osu:play(); data.ui.simplemenu.onscreen = false end
		},
		[2] = {
			text = "retry",
			action = function()
				osu:reloadBeatmap()
				osu:start()
				data.ui.simplemenu.onscreen = false
			end
		},
		[3] = {
			text = "back to menu",
			action = function()
				osu:stop()
				data.ui.simplemenu.state = "songs1"
				data.ui.state = 2
				data.beatmap = {}
				data.currentnotes = {{},{},{},{}}
				data.marks = {0,0,0,0,0,0}
				data.combo = 0
			end
		}
	},
	["options"] = {
		title = "options",
		[1] = {
			text = "speed",
			action = function() data.ui.simplemenu.state = "speed"; end
		},
		[2] = {
			text = "debug",
			action = function() data.ui.simplemenu.state = "debug" end
		},
		[3] = {
			text = "skin",
			action = function() data.ui.simplemenu.state = "skin" end
		},
		[4] = {
			text = "back",
			action = function() data.ui.simplemenu.state = "empty"; data.ui.simplemenu.onscreen = false end
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
			action = function() data.ui.simplemenu.state = "options" end
		}
	},
	["debug"] = {
		title = "speed",
		[1] = {
			text = "enable",
			action = function() data.ui.debug = true end
		},
		[2] = {
			text = "disable",
			action = function() data.ui.debug = false end
		},
		[3] = {
			text = "back",
			action = function() data.ui.simplemenu.state = "options" end
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
			action = function() data.ui.simplemenu.state = "options" end
		}
	},
	["songs1"] = {
		title = "songs page 1",
		[1] = {
			text = "The First Part of Touhou EX Boss Rush!!",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 1
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[2] = {
			text = "Space Time",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 2
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[3] = {
			text = "Achromat",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 3
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[4] = {
			text = "Speedcore 300",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 4
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[5] = {
			text = "Kanshou no Matenrou",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 5
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[6] = {
			text = "next ->",
			action = function() data.ui.simplemenu.state = "songs2" end
		},
	},
	["songs2"] = {
		title = "songs page 2",
		[1] = {
			text = "C18H27NO3",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 6
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[2] = {
			text = "Deconstruction Star",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 7
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[3] = {
			text = "B.B.K.K.B.K.K.",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 8
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[4] = {
			text = "The Empress",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 9
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[5] = {
			text = "DJ Nate - Theory of Everything",
			action = function() 
				data.ui.simplemenu.onscreen = false
				data.currentbeatmap = 10
				osu:reloadBeatmap()
				osu:play()
				data.ui.state = 3
			end
		},
		[6] = {
			text = "back <-",
			action = function() data.ui.simplemenu.state = "songs1" end
		},
	},
	
}

return menu
