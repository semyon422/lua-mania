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
local skin = {
	Colours = {
		[1] = {
			Colour = {0,0,0,150},
			ColourLight = {255,255,255,150},
			NoteImage = "mania/NoteImage/white.png",
			NoteImageL = "mania/NoteImageL/white.png",
			KeyImage = "mania/KeyImage/white.png",
			KeyImageD = "mania/KeyImageD/white.png"
		},
		[2] = {
			Colour = {0,0,12,150},
			ColourLight = {127,127,255,150},
			NoteImage = "mania/NoteImage/blue.png",
			NoteImageL = "mania/NoteImageL/blue.png",
			KeyImage = "mania/KeyImage/blue.png",
			KeyImageD = "mania/KeyImageD/blue.png"
		},
		[3] = {
			Colour = {0,12,0,150},
			ColourLight = {127,255,127,150},
			NoteImage = "mania/NoteImage/green.png",
			NoteImageL = "mania/NoteImageL/green.png",
			KeyImage = "mania/KeyImage/green.png",
			KeyImageD = "mania/KeyImageD/green.png"
		},
		[4] = {
			Colour = {12,12,12,150},
			ColourLight = {127,127,127,150},
			NoteImage = "mania/NoteImage/grey.png",
			NoteImageL = "mania/NoteImageL/grey.png",
			KeyImage = "mania/KeyImage/grey.png",
			KeyImageD = "mania/KeyImageD/grey.png"
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
		[4] = {1,2,3,4},
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