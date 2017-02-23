local init = function(game)
--------------------------------
local lmp = loveio.LoveioObject:new()

lmp.path = game.path .. "modes/lmp/"

lmp.blockTemplates = require(lmp.path .. "blockTemplates")
lmp.VisualSlide = require(lmp.path .. "Slide")(lmp)

lmp.load = function(self)
	self.currentSlideIndex = self.currentSlideIndex or 1
	self.currentSlide = self.currentSlide or self.VisualSlide:new(self.map.slides[self.currentSlideIndex])
	self:setSlide(self.currentSlideIndex)
	loveio.input.callbacks.keypressed.newGame = function(key)
		if key == "escape" then
			mainCli:run("gameState set mapList")
		elseif key == "left" then
			self:setSlide(self.currentSlideIndex - 1)
		elseif key == "right" then
			self:setSlide(self.currentSlideIndex + 1)
		end
	end
end

lmp.setSlide = function(self, slideIndex)
	if self.map.slides[slideIndex] then
		self.currentSlide:remove()
		self.currentSlideIndex = slideIndex
		self.currentSlide = self.VisualSlide:new(self.map.slides[slideIndex])
		self.currentSlide:insert(loveio.objects):reload()
	end
end

lmp.postUpdate = function(self)
end

lmp.unload = function(self)
	loveio.input.callbacks.keypressed.newGame = nil
	self.currentSlide:remove()
end

return lmp
--------------------------------
end

return init
