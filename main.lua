--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
package.path = package.path .. ";./src/?/init.lua" .. ";./src/?.lua" ..
							   ";./src/lmfw/?/init.lua" .. ";./src/lmfw/?.lua" ..
							   ";./src/rglib/?/init.lua" .. ";./src/rglib/?.lua"

require("src.main")
