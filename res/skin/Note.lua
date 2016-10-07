local init = function(skin, luaMania)
--------------------------------
local Note = {}

Note.circle = love.graphics.newImage(skin.path .. "vsrg/circle/3fff9f.png")

Note.drawLoad = function(self)
	self.h = pos:x2y(0.1)
	self.color = {255, 255, 255, 255}
	self.gNote = loveio.output.classes.Drawable:new({
		drawable = Note.circle,
		x = 0, y = 0, sx = 0.1 / pos:X2x(Note.circle:getWidth()),
		layer = 3
	}):insert(loveio.output.objects)
end

return Note
--------------------------------
end

return init