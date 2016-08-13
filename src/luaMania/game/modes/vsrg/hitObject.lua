local init = function(vsrg, game)
--------------------------------
local VsrgHitObject = {}

VsrgHitObject.new = function(self, hitObject)
	setmetatable(hitObject, self)
	self.__index = self
	hitObject.name = "VsrgHO" .. hitObject.column.key .. "-" .. hitObject.columnIndex
	return hitObject
end

VsrgHitObject.draw = function(self, ox, oy)
	if not loveio.output.objects[self.name] then
		if not self.endTime then
			loveio.output.objects[self.name] = {
				class = "rectangle",
				x = ox, y = oy, w = 0.1, h = 0.05, mode = "fill", layer = 3
			}
		else
			loveio.output.objects[self.name] = {
				class = "rectangle",
				x = ox, y = oy, w = 0.1, h = 0.05 + (self.endTime - self.startTime) / 1000, mode = "fill", layer = 3
			}
		end
	end
	loveio.output.objects[self.name].x = ox
	loveio.output.objects[self.name].y = oy
end

VsrgHitObject.remove = function(self)
	loveio.output.objects[self.name] = nil
end

return VsrgHitObject
--------------------------------
end

return init