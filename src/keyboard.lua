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
local keyboard = {
	maniaLayouts = {
		[1] = {"space"},
		[2] = {"r", "o"},
		[3] = {"r", "space", "o"},
		[4] = {"e", "r", "o", "p"},
		[5] = {"e", "r", "space", "o", "p"},
		[6] = {"w", "e", "r", "o", "p", "["},
		[7] = {"w", "e", "r", "space", "o", "p", "["},
		[9] = {"q", "w", "e", "r", "o", "p", "[", "]"},
		[9] = {"q", "w", "e", "r", "space", "o", "p", "[", "]"},
		[10] = {"q","w","e","r","lalt","space","o","p","[","]"},
		[18] = {"q","q","q","q","q","q","q","q","q","q","q","q","q","q","q","q","q","q"}
	},
	key = {
		["back"] = {"escape",
			action = function()
				if data.ui.state == 2 then
					data.ui.simplemenu.onscreen = false
					data.ui.state = 1
				elseif data.ui.state == 3 then
					if data.ui.simplemenu.onscreen == true then
						data.ui.simplemenu.onscreen = false
						osu:play()
					else
						data.ui.simplemenu.onscreen = true
						data.ui.simplemenu.state = "pause"
						osu:pause()
					end
				end
			end
		},
		["retry"] = {"`",
			action = function()
				if data.ui.state == 3 then
					osu:stop()
					data.beatmap = {}
					osu:reloadBeatmap()
					osu:start()
					data.ui.simplemenu.onscreen = false
				end
			end
		},
		["speedup"] = {"f4",
			action = function()
				if data.ui.state == 3 then
					data.config.speed = data.config.speed + 0.1
				end
			end
		},
		["speeddown"] = {"f3",
			action = function()
				if data.ui.state == 3 then
					if data.config.speed > 0.2 then data.config.speed = data.config.speed - 0.1 end
				end
			end
		},
		["offsetup"] = {"=",
			action = function()
				if data.ui.state == 3 then
					data.config.offset = data.config.offset + 5
				end
			end
		},
		["offsetdown"] = {"-",
			action = function()
				if data.ui.state == 3 then
					data.config.offset = data.config.offset - 5
				end
			end
		},
		["songup"] = {"up",
			action = function()
				if data.ui.state == 2 then
					if data.ui.songlist.scroll < 2 and data.ui.songlist.scroll >= -#data.cache + 3 then data.ui.songlist.scroll = data.ui.songlist.scroll + 1 end
				end
			end
		},
		["songdown"] = {"down",
			action = function()
				if data.ui.state == 2 then
					if data.ui.songlist.scroll <= 2 and data.ui.songlist.scroll > -#data.cache + 3 then data.ui.songlist.scroll = data.ui.songlist.scroll - 1 end
				end
			end
		},
		["enter"] = {"return",
			action = function()
				if data.ui.state == 2 then
					data.ui.simplemenu.onscreen = false
					data.currentbeatmap = data.ui.songlist.current
					osu:reloadBeatmap()
					osu:play()
					data.ui.state = 3
				end
			end
		},
		["autoplay"] = {"f10",
			action = function()
				if data.ui.state == 3 then
					if data.autoplay == 0 then
						data.autoplay = 1
					elseif data.autoplay == 1 then
						data.autoplay = 0
					end
				end
			end
		},
		["fullscreen"] = {"f11",
			action = function()
				if data.config.fullscreen == false then
					data.config.fullscreen = true
				elseif data.config.fullscreen == true then
					data.config.fullscreen = false
				end
				love.window.setFullscreen(data.config.fullscreen, "desktop")
				--love.window.setFullscreen(data.config.fullscreen, "exclusive")
			end
		},
		["c1"] = {"lctrl", "z",
			action = function()
				if data.ui.state == 3 then
					function love.wheelmoved(x, y)
					end
				end
			end
		},
		["c2"] = {"lctrl", "q",
			action = function()
				if data.ui.state == 3 then
					function love.wheelmoved(x, y)
						if y > 0 then
							data.config.hitPosition = data.config.hitPosition + 5
						elseif y < 0 then
							data.config.hitPosition = data.config.hitPosition - 5
						end
					end
				end
			end
		},
		["c3"] = {"lctrl", "w",
			action = function()
				if data.ui.state == 3 then
					function love.wheelmoved(x, y)
						if y > 0 then
							data.config.pitch = data.config.pitch + 0.1
						elseif y < 0 then
							if data.config.pitch > 0.2 then
								data.config.pitch = data.config.pitch - 0.1
							end
						end
					end
				end
			end
		},
	}
}

return keyboard