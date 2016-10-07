local init = function(classes, ui)
--------------------------------
local List = classes.UiObject:new()

List.layer = 2
List.xAlign = "center"
List.yAlign = "center"
List.xPadding = 0
List.yPadding = 0
List.textColor = {255, 255, 255, 255}
List.backgroundColor = {0, 0, 0, 127}

List.showingItemsCount = 1
List.startItem = 1

List.scrollDirection = 1

List.load = function(self)
	self.items = self.items or {}
	self.buttons = self.buttons or {}
	self.showingItems = {}
	for i = 1, self.showingItemsCount do
		table.insert(self.showingItems, ui.classes.Button:new({
			x = self.x, y = self.y + (i - 1) * (self.h / self.showingItemsCount),
			w = self.w, h = self.h / (self.showingItemsCount) - pos:Y2y(4),
			value = self.items[(i - 1) + self.startItem] and self.items[(i - 1) + self.startItem].title,
			layer = self.layer,
			xAlign = self.xAlign, yAlign = self.yAlign,
			xPadding = self.xPadding, yPadding = self.yPadding,
			backgroundColor = self.backgroundColor,
			textColor = self.textColor,
			action = self.items[(i - 1) + self.startItem] and self.items[(i - 1) + self.startItem].action
		}):insert(loveio.objects))
	end
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		local x = self:get("X", true)
		local y = self:get("Y", true)
		local w = self:get("W")
		local h = self:get("H")
		local mx = loveio.input.mouse.X
		local my = loveio.input.mouse.Y
		if mx >= x and mx <= x + w and my >= y and my <= y + h then
			if direction == -1 * self.scrollDirection then
				self.startItem = self.startItem - 1
			elseif direction == 1 * self.scrollDirection then
				self.startItem = self.startItem + 1
			end
			self:reload()
		end
	end
	self.loaded = true
end
List.unload = function(self)
	if self.showingItems then
		for _, showingItem in pairs(self.showingItems) do
			showingItem:remove()
		end
	end
end
List.valueChanged = function(self)
end

return List
--------------------------------
end

return init