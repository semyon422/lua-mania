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
				data.ui.state = 2
			end
		}
	},
}
return menu
