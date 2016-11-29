local Background = ui.classes.UiObject:new()

Background.set = function(self, path)
	self.path = path
	self:reload()
end

Background.get = function(self)
	return self.path
end

Background.layer = 0
Background.cParallax = 0.025

Background.load = function(self)
	self.pos = self.pos or loveio.output.Position:new({ratios = {0}, resolutions = {{1, 1}}, scale = {1, 1}, locate = "out"})
	if love.filesystem.isFile(self.path) then
		self.drawable = love.graphics.newImage(self.path)
		self.drawableObject = loveio.output.classes.Drawable:new({
			drawable = self.drawable,
			layer = self.layer,
			pos = self.pos
		}):insert(loveio.output.objects)
		
	    loveio.input.callbacks.resize[tostring(self)] = function(w, h)
		    local base = {x = self.pos:x2X(0, true), y = self.pos:y2Y(0, true), w = self.pos:x2X(1), h = self.pos:y2Y(1)}
		    local box = {w = self.drawable:getWidth(), h = self.drawable:getHeight()}
    		self.dims = loveio.output.Position.getDimensionsSimple(base, box, {"center", "center"}, "out")
	        self.drawableObject.xBase = self.pos:X2x(self.dims.x, true) - self.cParallax / 2 * self.pos:X2x(self.dims.w)
	        self.drawableObject.yBase = self.pos:Y2y(self.dims.y, true) - self.cParallax / 2 * self.pos:Y2y(self.dims.h)
	        self.drawableObject.x = self.drawableObject.xBase
	        self.drawableObject.y = self.drawableObject.yBase
			print(self.drawableObject.xBase, self.drawableObject.x)
	        self.drawableObject.sx = self.dims.scale * (1 + self.cParallax)
	    end
	    loveio.input.callbacks.resize[tostring(self)](love.graphics.getWidth(), love.graphics.getHeight())
		loveio.input.callbacks.mousemoved[tostring(self)] = function(x, y)
			local parallaxX = (x / love.graphics.getWidth() - 0.5) * 2 * self.cParallax / 2 * self.pos:X2x(self.dims.w)
			local parallaxY = (y / love.graphics.getHeight() - 0.5) * 2 * self.cParallax / 2 * self.pos:Y2y(self.dims.h)
		    self.drawableObject.x = self.drawableObject.xBase + parallaxX
		    self.drawableObject.y = self.drawableObject.yBase + parallaxY
		end
	end
end

Background.unload = function(self)
    if self.drawableObject then self.drawableObject:remove() end
    loveio.input.callbacks.resize[tostring(self)] = nil
end

return Background
