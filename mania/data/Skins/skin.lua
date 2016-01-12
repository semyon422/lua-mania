--[[
semyon422's tools and games based on love2d - useful tools and game ports
Copyright (C) 2016 Semyon Jolnirov

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
local skin = {
	Colours = {
		[1] = {
			Colour = {0,0,0,150},
			ColourLight = {255,255,255,150},
			NoteImage = "mania/note/white.png",
			NoteImageH = "mania/note/white.png",
			NoteImageL = "mania/sustain/white-0.png",
			KeyImage = "mania/key/white.png",
			KeyImageD = "mania/key/white-down.png"
		},
		[2] = {
			Colour = {15,10,12,150},
			ColourLight = {84,227,255,150},
			NoteImage = "mania/note/blue.png",
			NoteImageH = "mania/note/blue.png",
			NoteImageL = "mania/sustain/blue-0.png",
			KeyImage = "mania/key/blue.png",
			KeyImageD = "mania/key/blue-down.png"
		},
		[3] = {
			Colour = {12,15,10,150},
			ColourLight = {141,255,84,150},
			NoteImage = "mania/note/green.png",
			NoteImageH = "mania/note/green.png",
			NoteImageL = "mania/sustain/green-0.png",
			KeyImage = "mania/key/green.png",
			KeyImageD = "mania/key/green-down.png"
		},
		[4] = {
			Colour = {14,10,15,150},
			ColourLight = {198,84,255,150},
			NoteImage = "mania/note/purple.png",
			NoteImageH = "mania/note/purple.png",
			NoteImageL = "mania/sustain/purple-0.png",
			KeyImage = "mania/key/purple.png",
			KeyImageD = "mania/key/purple-down.png"
		}
	},
	ColourColumnLine = {255,255,255,100},
	ColumnLineWidth = {
		[1] = {0,0},
		[2] = {0,0,0},
		[3] = {0,0,0,0},
		[4] = {0,0,0,0,0},
		[5] = {0,0,0,0,0,0},
		[6] = {0,0,0,0,0,0,0},
		[7] = {0,0,0,0,0,0,0,0},
		[8] = {0,0,0,0,0,0,0,0,0},
		[9] = {0,0,0,0,0,0,0,0,0,0},
		[10] = {0,0,0,0,0,1,0,0,0,0,0},
		[12] = {0,0,0,0,0,0,0,0,0,0,0,0,0},
		[14] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		[18] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	},
	ColumnWidth = {
		[1] = {36},
		[2] = {36,36},
		[3] = {36,36,36},
		[4] = {36,36,36,36},
		[5] = {36,36,36,36,36},
		[6] = {36,36,36,36,36,36},
		[7] = {36,36,36,36,36,36,36},
		[8] = {36,36,36,36,36,36,36,36},
		[9] = {36,36,36,36,36,36,36,36,36},
		[10] = {36,36,36,36,36,36,36,36,36,36},
		[12] = {36,36,36,36,36,36,36,36,36,36,36,36},
		[14] = {36,36,36,36,36,36,36,36,36,36,36,36,36,36},
		[16] = {36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36},
		[18] = {36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36}
	},

	ManiaColours = {
		[1] = {3},
		[2] = {4,4},
		[3] = {4,3,4},
		[4] = {4,1,1,4},
		[5] = {4,1,3,1,4},
		[6] = {4,2,1,1,2,4},
		[7] = {4,2,1,3,1,2,4},
		[8] = {4,1,2,1,1,2,1,4},
		[9] = {4,1,2,1,3,1,2,1,4},
		[10] = {4,2,1,2,3,3,2,1,2,4},
		[12] = {4,1,2,1,2,1,1,2,1,2,1,4},
		[14] = {4,2,1,2,1,2,1,1,2,1,2,1,2,4},
		[16] = {4,1,2,1,2,1,2,1,1,2,1,2,1,2,1,4},
		[18] = {4,2,1,2,1,2,1,2,1,1,2,1,2,1,2,1,2,4}
	},

	background = {
		draw = false, -- true -  рисует фон, false - нет
		colour = {0, 0, 0} -- цвет фона, RGB
	},
	--stretch = false, -- растянуть?
	ColumnStart = {
		[1] = 409, --16+18
		[2] = 391, --14+18
		[3] = 373, --12+18
		[4] = 355, --10+18
		[5] = 337, --8+18
		[6] = 319, --6+18
		[7] = 301, --4+18
		[8] = 283, --2+18
		[9] = 265, --0+18
		[10] = 247, --0+36
		[12] = 211, --0+36
		[14] = 175, --0+36
		[16] = 139, --0+36
		[18] = 103
	}

}

return skin