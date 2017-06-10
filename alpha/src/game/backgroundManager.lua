game.backgroundManager = {}
local backgroundManager = game.backgroundManager

backgroundManager.set = function(self, path)
	self.path = path
	self:reload()
end

backgroundManager.get = function(self)
	return self.path
end

backgroundManager.Background = createClass(soul.SoulObject)
local Background = backgroundManager.Background

Background.layer = 0
Background.parallax = 0.025

Background.load = function(self)
	self.cs = soul.CS:new({
		res = {
			w = 1, h = 1
		},
		locate = "out"
	})
	
	self.drawableObject = soul.graphics.DrawableFrame:new({
		drawable = self.drawable,
		layer = self.layer,
		cs = self.cs,
		subcs = soul.CS:new({
			res = {
				w = self.drawable:getWidth(),
				h = self.drawable:getHeight()
			},
			locate = "out",
			getScreen = function()
				return {
					x = 0,
					y = 0,
					w = love.graphics.getWidth(),
					h = love.graphics.getHeight()
				}
			end
		})
	})
	self.drawableObject:activate()
	
	-- soul.callbacks.mousemoved[self] = function(x, y)
		-- local xParallax = (x / love.graphics.getWidth() - 0.5) * 2 * self.parallax / 2-- * self.cs:x(self.drawableObject.frame.w)
		-- local yParallax = (y / love.graphics.getHeight() - 0.5) * 2 * self.parallax / 2-- * self.cs:y(self.drawableObject.frame.h)
	    -- self.drawableObject.x = self.drawableObject.xBase + parallaxX
	    -- self.drawableObject.y = self.drawableObject.yBase + parallaxY
	-- end
end

Background.unload = function(self)
    if self.drawableObject then self.drawableObject:deactivate() end
    soul.callbacks.resize[self] = nil
end