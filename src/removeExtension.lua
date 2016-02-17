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
local function removeExtension(self, filename)
	tblFilename = explode(".", filename)
	if #tblFilename == 1 then
		return filename
	else
		local newFilename = ""
		for i,substr in pairs(tblFilename) do
			if i == #tblFilename then break end
			if i == 1 then
				newFilename = newFilename .. substr
			else
				newFilename = newFilename .. "." .. substr
			end
		end
		return newFilename
	end
end

return removeExtension