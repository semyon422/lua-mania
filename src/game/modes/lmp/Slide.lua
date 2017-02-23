init = function(lmp)
----------------
local Slide = loveio.LoveioObject:new()

local Block = ui.classes.PictureButton:new()
Block.xAlign = "left"
Block.xPadding = 0.05
Block.yPadding = 0.05
Block.yNotCentered = true
Block.xSpawn = 0.5
Block.imagePath = "res/clearPixel.png"
Block.drawable = love.graphics.newImage(Block.imagePath)
Block.align = {"left", "center"}
Block.locate = "in"
Block.font = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 16)
Block.fontBaseResolution = {pos:x2X(1), pos:y2Y(1)}
Block.textColor = {0, 0, 0, 255}
Block.pos = loveio.output.Position:new({
	ratios = {4/3}, resolutions = {{1, 1}}
})

Slide.load = function(self)
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
