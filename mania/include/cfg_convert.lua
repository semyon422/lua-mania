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
local function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
local function cfg_convert(file)
	cfg = io.open(file, "r")
	content = {}
	optionsraw = {}
	options = {}
	for line in cfg:lines() do
		table.insert(content, line)
		--print(line)
	end
	map:close()
	for i = 7, #content do
		options[explode(" = ", content[i])[1]] = {}
		options[explode(" = ", content[i])[1]] = explode(" = ", content[i])[2]
		
	end
	return options
end

return cfg_convert