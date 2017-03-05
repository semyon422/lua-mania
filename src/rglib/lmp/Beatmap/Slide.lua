init = function(lmp)
----------------
local Slide = {}

Slide.xAlign = "center"
Slide.yAlign = "center"
Slide.xPadding = 0
Slide.yPadding = 0

Slide.new = function(self, slide)
	local slide = slide or {}
	slide.blocks = {}
	slide.objects = {}

	setmetatable(slide, self)
	self.__index = self
	
	return slide
end

Slide.set = function(self, templateId, data, font, xAlign, yAlign, xPadding, yPadding)
	local blockType
	if type(data) == "userdata" then
		blockType = "image"
	else
		blockType = "text"
	end
	self.blocks[templateId] = {
		value = data,
		type = blockType,
		template = templateId,
		font = font,
		xAlign = xAlign or self.xAlign,
		yAlign = yAlign or self.yAlign,
		xPadding = xPadding or self.xPadding,
		yPadding = yPadding or self.yPadding
	}
end

return Slide
--------
end

return init
