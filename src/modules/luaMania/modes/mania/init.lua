local mania = {}

mania.convert = require("luaMania.modes.mania.osu")
mania.getObjects = require("luaMania.modes.mania.getObjects")
mania.hit = require("luaMania.modes.mania.hit")
mania.load = require("luaMania.modes.mania.load")

mania.tupdate = function()
	local keys = {"e","r","o","p"}
	for i,v in pairs(keys) do
		table.insert(luaMania.keyboard.events, 
		{
			keys = {v},
			actionHit = function()
				if luaMania.map.objects.current[i] then
					luaMania.modes.mania.hit(luaMania.map.objects.current[i].startTime - luaMania.map.stats.currentTime, i)
				end
			end
		})
	end
end

mania.isLoaded = false

return mania