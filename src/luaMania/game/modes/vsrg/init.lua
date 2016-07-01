local init = function(game)
--------------------------------
local vsrg = {}

vsrg.path = game.path .. "modes/vsrg/"

vsrg.HitObject = require(vsrg.path .. "hitObject")(vsrg, game)
vsrg.Column = require(vsrg.path .. "column")(vsrg, game)

vsrg.columns = {}

vsrg.update = function(map)
	if not vsrg.loaded then
		for key = 1, map.info.keymode do
			vsrg.columns[key] = vsrg.Column:new(key)
		end
		map.audio:play()
		vsrg.loaded = true
	end
	for _, column in ipairs(vsrg.columns) do
		column:update(map)
	end
end
vsrg.draw = function(map)
	for _, column in ipairs(vsrg.columns) do
		column:draw(map)
	end
end

return vsrg
--------------------------------
end

return init