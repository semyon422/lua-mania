local mania = {}

mania.convert = require("luaMania.modes.mania.osu")
mania.getObjects = require("luaMania.modes.mania.getObjects")
mania.hit = require("luaMania.modes.mania.hit")
mania.load = require("luaMania.modes.mania.load")

mania.data = {
	name = "mania",
	keys = {
		binds = {["e"] = 1, ["r"] = 2, ["o"] = 3, ["p"] = 4},
		pressed = {},
		hitted = {}
	},
	loaded = false
}
mania.update = function()
	local data = mania.data
	if not data.loaded then
		mania.load()
		data.loaded = true
	end
	mania.getObjects()
	loveio.input.callbacks[data.name] = {
		keypressed = function(key)
			for keybind, keynum in pairs(data.keys.binds) do
				if key == keybind then
					data.keys.pressed[keynum] = true
					if luaMania.map.objects.current[keynum] then
						data.keys.hitted[keynum] = true
						mania.hit(luaMania.map.objects.current[keynum].startTime - luaMania.map.stats.currentTime, keynum)
					end
				end
			end
		end,
		keyreleased = function(key)
			for keybind, keynum in pairs(data.keys.binds) do
				if key == keybind then
					data.keys.pressed[keynum] = nil
					data.keys.hitted[keynum] = nil
					if luaMania.map.objects.current[keynum] then
						mania.hit(luaMania.map.objects.current[keynum].startTime - luaMania.map.stats.currentTime, keynum)
					end
				end
			end
		end,
	}
end

return mania