init = function(lmp)
----------------
local Slide = {}

Slide.__index = Slide

Slide.new = function(self)
	local slide = {}
	slide.blocks = {}
	slide.objects = {}
	
	setmetatable(slide, self)
	return slide
end

Slide.set = function(self, templateId, data, font, xAlign)
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
		xAlign = xAlign
	}
end

return Slide
--------
end

return init
