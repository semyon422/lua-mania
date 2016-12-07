local cursor = ui.classes.UiObject:new()
cursor.circles = {
	[1] = {
		r = 20,
		mode = "line"
	},
	[2] = {
		r = 10,
		mode = "line"
	}
}
cursor.load = function()
	love.mouse.setVisible(false)
	cursor.object = loveio.output.classes.Circle:new({
		x = 0, y = 0, r = cursor.circles[1].r,
		mode = cursor.circles[1].mode,
		layer = 1001,
		pos = loveio.output.Position:new({ratios = {0}, resolutions = {{0, 0}}})
	}):insert(loveio.output.objects)
	loveio.input.callbacks.mousepressed.cursor = function(mx, my)
			cursor.object.x = mx
			cursor.object.y = my
			cursor.object.rs = cursor.circles[2].r
			cursor.object.mode = cursor.circles[2].mode
	end
	loveio.input.callbacks.mousemoved.cursor = function(mx, my)
			cursor.object.x = mx
			cursor.object.y = my
	end
	loveio.input.callbacks.mousereleased.cursor = function(mx, my)
			cursor.object.x = mx
			cursor.object.y = my
			cursor.object.r = cursor.circles[1].r
			cursor.object.mode = cursor.circles[1].mode
	end
end

cursor.unload = function()
	if cursor.object then
		cursor.object:remove()
		loveio.input.callbacks.mousepressed.cursor = nil
		loveio.input.callbacks.mousemoved.cursor = nil
		loveio.input.callbacks.mousereleased.cursor = nil
	end
end

return cursor
