local init = function(game, luaMania)
--------------------------------
local vsrg = loveio.LoveioObject:new()

vsrg.path = game.path .. "modes/vsrg/"

vsrg.HitObject = require(vsrg.path .. "hitObject")(vsrg, game, luaMania)
vsrg.Column = require(vsrg.path .. "column")(vsrg, game, luaMania)

vsrg.columns = {}

vsrg.load = function()
	for key = 1, game.map:get("CircleSize") do
		vsrg.columns[key] = vsrg.Column:new()
		vsrg.columns[key]:load(key)
	end
	game.map.audio = love.audio.newSource(game.map:get("mapPath") .. "/" .. game.map:get("AudioFilename"))
	game.map.audio:play()
	vsrg.loaded = true
end

vsrg.update = function()
	for _, column in ipairs(vsrg.columns) do
		column:update()
	end
end
vsrg.draw = function()
	for _, column in ipairs(vsrg.columns) do
		column:draw()
	end
end
vsrg.remove = function()
	game.map.audio:stop()
	vsrg.removeAll = true
end

return vsrg
--------------------------------
end

return init