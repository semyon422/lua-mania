local init = function(vsrg, game)
--------------------------------
local HitObject = {}

HitObject.new = function(self, hitObject)
	setmetatable(hitObject, self)
	self.__index = self
	return hitObject
end

HitObject.draw = function(self, ox, oy)
	if not self.drawed then
		self.name = "vsrgHitObject" .. math.random()
		loveio.output.objects[self.name] = {
			class = "rectangle",
			x = (ox and ox(self)), y = (oy and oy(self)), w = 0.1, h = 0.05, mode = "fill", layer = 3
		}
		self.drawed = true
	end
	loveio.output.objects[self.name].x = (ox and ox(self))
	loveio.output.objects[self.name].y = (oy and oy(self))
end

HitObject.remove = function(self)
	self.drawed = nil
	loveio.output.objects[self.name] = nil
end

return HitObject
--------------------------------
end

return init