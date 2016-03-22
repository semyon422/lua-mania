--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local keyboard = {}

keyboard.keys = {}

keyboard.keys.pressed = {}
keyboard.keys.hitted = {}

keyboard.events = {}
--event = {keys = {keys}, actionHit, actionPress, actionUnpress, actionRelease}

keyboard.update = function()
	for eventIndex, event in pairs(keyboard.events) do
		if love.keyboard.isDown(unpack(event.keys)) then
			if keyboard.keys.pressed[eventIndex] == nil then
				if event.actionHit ~= nil then event.actionHit() end
				keyboard.keys.pressed[eventIndex] = true
				keyboard.keys.hitted[eventIndex] = true
			else
				if event.actionPress ~= nil then event.actionPress() end
			end
		else
			if keyboard.keys.pressed[eventIndex] == nil then
				if event.actionRelease ~= nil then event.actionRelease() end
			else
				if event.actionUnpress ~= nil then event.actionUnpress() end
				keyboard.keys.pressed[eventIndex] = nil
				keyboard.keys.hitted[eventIndex] = nil
			end
		end
	end
end

return keyboard
