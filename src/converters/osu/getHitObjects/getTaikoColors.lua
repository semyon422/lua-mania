--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getTaikoColors(id, max) -- "rr" | "r" | "bb" | "b"
	if id == 0 then return "r"
	elseif id == 2 then return "b"
	elseif id == 8 then return "b"
	elseif id == 10 then return "b"
	end
	
	if max == 1 then
		if id == 4 then return "r"
		elseif id == 6 then return "b"
		elseif id == 12 then return "b"
		elseif id == 14 then return "b"
		end
	elseif max == 2 then
		if id == 4 then return "rr"
		elseif id == 6 then return "bb"
		elseif id == 12 then return "bb"
		elseif id == 14 then return "bb"
		end
	end
end

return getTaikoColors
