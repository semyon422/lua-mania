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
local function explode(divider, input)
	if (divider == "") then
		return false
	end
	local position = 0
	local output = {}
	
	for endchar,startchar in	function()
									return string.find(input, divider, position, true)
								end
	do
		table.insert(output, string.sub(input, position, endchar - 1))
		position = startchar + 1
	end
	table.insert(output, string.sub(input, position))
	return output
end

return explode