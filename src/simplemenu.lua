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
