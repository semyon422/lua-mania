--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
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