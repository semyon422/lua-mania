local cursor = ui.classes.UiObject:new()

local templates = {
	{r = 8, color = {255, 255, 255}, mode = "line"},
	{r = 4, color = {0, 0, 0}, mode = "fill"},
}
local circles = {}
local pos = loveio.output.Position:new({ratios = {0}, resolutions = {{0, 0}}})

cursor.load = function(self)
	love.mouse.setVisible(false)
	for index, template in ipairs(templates) do
		table.insert(circles, loveio.output.classes.Circle:new({
			x = 0, y = 0, r = template.r,
			mode = template.mode,
			color = template.color,
			layer = 1001,
			pos = pos
		}):insert(loveio.output.objects))
	end
	
	loveio.input.callbacks.mousepressed.cursor = function(mx, my)
		for index, circle in ipairs(circles) do
			circle.x = mx
			circle.y = my
		end
	end
	loveio.input.callbacks.mousemoved.cursor = function(mx, my)
		for index, circle in ipairs(circles) do
			circle.x = mx
			circle.y = my
		end
	end
	loveio.input.callbacks.mousereleased.cursor = function(mx, my)
		for index, circle in ipairs(circles) do
			circle.x = mx
			circle.y = my
		end
	end
end

cursor.unload = function()
	for index, circle in ipairs(circles) do
		circle:remove()
	end
	loveio.input.callbacks.mousepressed.cursor = nil
	loveio.input.callbacks.mousemoved.cursor = nil
	loveio.input.callbacks.mousereleased.cursor = nil
end

return cursor
