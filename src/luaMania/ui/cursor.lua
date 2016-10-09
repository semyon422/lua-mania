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
		X = 0, X = 0, R = cursor.circles[1].r,
		mode = cursor.circles[1].mode,
		layer = 5
	}):insert(loveio.output.objects)
	loveio.input.callbacks.mousepressed.cursor = function(mx, my)
			cursor.object.X = mx
			cursor.object.Y = my
			cursor.object.R = cursor.circles[2].r
			cursor.object.mode = cursor.circles[2].mode
	end
	loveio.input.callbacks.mousemoved.cursor = function(mx, my)
			cursor.object.X = mx
			cursor.object.Y = my
	end
	loveio.input.callbacks.mousereleased.cursor = function(mx, my)
			cursor.object.X = mx
			cursor.object.Y = my
			cursor.object.R = cursor.circles[1].r
			cursor.object.mode = cursor.circles[1].mode
	end
end

return cursor