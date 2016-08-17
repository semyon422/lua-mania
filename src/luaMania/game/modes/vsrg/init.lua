local init = function(game, luaMania)
--------------------------------
local vsrg = loveio.LoveioObject:new()

vsrg.map = {}

vsrg.path = game.path .. "modes/vsrg/"

vsrg.HitObject = require(vsrg.path .. "hitObject")(vsrg, game, luaMania)
vsrg.Column = require(vsrg.path .. "column")(vsrg, game, luaMania)

vsrg.load = function(self)
	self.columns = {}
	for key = 1, self.map:get("CircleSize") do
		self.columns["column" .. key] = self.Column:new({
			name = "column" .. key,
			key = key,
			map = self.map,
			insert = self.insert
		})
	end
	self.map.audio = love.audio.newSource(self.map:get("mapPath") .. "/" .. self.map:get("AudioFilename"))
	self.map.audio:play()
end

vsrg.unload = function(self)
	if self.columns then
		for columnIndex, column in pairs(self.columns) do
			column:remove()
		end
	end
	self.columns = nil
	self.map.audio:stop()
end

return vsrg
--------------------------------
end

return init