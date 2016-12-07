--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
package.path = package.path .. ";./src/?/init.lua;./src/?.lua"
explode = require("explode")
trim = require("trim")
startsWith = require("startsWith")

require "src.main"
