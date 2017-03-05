init = function(lmp)
----------------
local Slide = loveio.LoveioObject:new()
Slide.pos = loveio.output.Position:new({
	ratios = {4/3}, resolutions = {{1, 1}}
})

local Block = ui.classes.DrawableTextButton:new()
Block.xTextAlign = "left"
Block.yTextAlign = "center"
Block.xTextPadding = 0
Block.yTextPadding = 0
Block.textColor = {0, 0, 0, 255}

Block.xDrawableAlign = "center"
Block.yDrawableAlign = "center"
Block.xDrawablePadding = 0
Block.yDrawablePadding = 0

Block.imagePath = "res/clearPixel.png"
Block.drawable = love.graphics.newImage(Block.imagePath)
Block.locate = "in"
Block.font = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 16)
Block.pos = Slide.pos

Slide.load = function(self)
	self.fontBaseResolution = {self.pos:x2X(1), self.pos:y2Y(1)}
	self.objects = self.objects or {}
	for _, block in pairs(self.blocks) do
		local template = lmp.blockTemplates[block.template]
		local x, y, w, h = template.x, template.y, template.w, template.h
		if block.type == "text" then
			local object = Block:new({
				x = x, y = y, w = w, h = h, value = block.value, font = block.font,
				xAlign = block.xAlign
			}):insert(loveio.objects)
			table.insert(self.objects, object)
		elseif block.type == "image" then
			local object = Block:new({
				x = x, y = y, w = w, h = h, drawable = block.value
			}):insert(loveio.objects)
			table.insert(self.objects, object)
		end
	end
end

Slide.unload = function(self)
	for _, object in ipairs(self.objects) do
		object:remove()
	end
	self.objects = {}
end

return Slide
--------
end

return init
