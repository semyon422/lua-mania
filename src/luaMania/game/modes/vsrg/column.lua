local init = function(vsrg, game, luaMania)
--------------------------------
local Column = loveio.LoveioObject:new()

Column.draw = require("luaMania/game/modes/vsrg/draw")(Column, vsrg, game, luaMania)

Column.update = function(self)
	if not self.loaded then
		self:load()
		self.loaded = true
	end
	self:draw()
end

Column.load = function(self)
	self.drawedObjects = {}
	self.hitObjects = {}
	
	local interval = 512 / self.map:get("CircleSize")
	for hitObjectIndex, hitObject in ipairs(self.map.hitObjects) do
		hitObject.key = hitObject.key or 0
		if hitObject.key == 0 then
			for newKey = 1, self.map:get("CircleSize") do
				if hitObject.x >= interval * (newKey - 1) and hitObject.x < newKey * interval then
					hitObject.key = newKey
					break
				end
			end
		end
		if hitObject.key == self.key then
			hitObject.columnIndex = #self.hitObjects + 1
			hitObject.column = self
			table.insert(self.hitObjects, vsrg.HitObject:new(hitObject))
		end
	end
	self.firstHitObjectIndex = 1
	
	table.insert(self.drawedObjects, loveio.output.classes.Rectangle:new({
		name = "column" .. self.key .. "bg",
		color = {0,0,0,127},
		x = 0.1 * (self.key - 1),
		y = 0,
		w = 0.1,
		h = 1,
		layer = 2,
		insert = {table = loveio.output.objects, onCreate = true}
	}))
end

Column.unload = function(self)
	if self.drawedObjects then
		for drawedObjectIndex, drawedObject in pairs(self.drawedObjects) do
			drawedObject:remove()
		end
	end
end

return Column
--------------------------------
end

return init