--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
package.path = package.path .. ";./src/modules/?/init.lua;./src/modules/?.lua;"
explode = require("explode")
trim = require("trim")

require "src.main"
