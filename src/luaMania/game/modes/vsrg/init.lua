local init = function(game, luaMania)
--------------------------------
local vsrg = loveio.LoveioObject:new()

vsrg.map = {}

vsrg.path = game.path .. "modes/vsrg/"

vsrg.HitObject = require(vsrg.path .. "HitObject")(vsrg, game, luaMania)
vsrg.Note = require(vsrg.path .. "Note")(vsrg, game, luaMania)
vsrg.Hold = require(vsrg.path .. "Hold")(vsrg, game, luaMania)
vsrg.Column = require(vsrg.path .. "Column")(vsrg, game, luaMania)

vsrg.load = function(self)
	self.combo = 0
	self.comboCounter = ui.classes.Button:new({
		x = 0.15, y = 0.45, w = 0.1, h = 0.1,
		name = "comboCounter",
		value = self.combo,
		getValue = function() return self.combo end,
		insert = self.insert
	})
	
	self.speed = luaMania.config["game.vsrg.speed"].value
	
	self.columns = {}
	for key = 1, self.map:get("CircleSize") do
		self.columns["column" .. key] = self.Column:new({
			name = "column" .. key,
			key = key,
			map = self.map,
			vsrg = self,
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
	self.comboCounter:remove()
	self.map.audio:stop()
end

return vsrg
--------------------------------
end

return init