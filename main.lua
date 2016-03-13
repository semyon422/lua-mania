--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
package.path = package.path .. ";./src/modules/?/init.lua;./src/modules/?.lua;"
function explode(divider, input)
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

function trim(s)
  return s:match "^%s*(.-)%s*$"
end

require "src.main"
