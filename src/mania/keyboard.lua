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
		[10] = {"q","w","e","r","alt","space","o","p","[","]"}
	},
	key = {
		pause = "escape",
		retry = "`",
		speedup = "f4",
		speeddown = "f3",
		offsetup = "=",
		offsetdown = "-",
		songup = "up",
		songdown = "down",
		enter = "return",
	}
}

return keyboard