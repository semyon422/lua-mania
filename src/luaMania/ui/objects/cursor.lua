local cursor = ui.classes.UiObject:new()
cursor.x = 0.5
cursor.y = 0.5
cursor.circles = {
	[1] = {
		r = 20/800,
		mode = "line"
	},
	[2] = {
		r = 10/800,
		mode = "line"
	}
}
cursor.update = function()
	if not cursor.loaded then
		love.mouse.setVisible(false)
		loveio.output.objects.cursor = loveio.output.classes.Circle:new({
			x = cursor.x, y = cursor.y, r = cursor.circles[1].r,
			mode = cursor.circles[1].mode,
			layer = 5
		})
		loveio.input.callbacks.mousepressed.cursor = function(mx, my)
				local mx = pos:X2x(mx, true)
				local my = pos:Y2y(my, true)
				cursor.x = mx
				cursor.y = my
				loveio.output.objects.cursor.x = cursor.x
				loveio.output.objects.cursor.y = cursor.y
				loveio.output.objects.cursor.r = cursor.circles[2].r
				loveio.output.objects.cursor.mode = cursor.circles[2].mode
		end
		loveio.input.callbacks.mousemoved.cursor = function(mx, my)
				local mx = pos:X2x(mx, true)
				local my = pos:Y2y(my, true)
				cursor.x = mx
				cursor.y = my
				loveio.output.objects.cursor.x = cursor.x
				loveio.output.objects.cursor.y = cursor.y
		end
		loveio.input.callbacks.mousereleased.cursor = function(mx, my)
				local mx = pos:X2x(mx, true)
				local my = pos:Y2y(my, true)
				cursor.x = mx
				cursor.y = my
				loveio.output.objects.cursor.x = cursor.x
				loveio.output.objects.cursor.y = cursor.y
				loveio.output.objects.cursor.r = cursor.circles[1].r
				loveio.output.objects.cursor.mode = cursor.circles[1].mode
		end
		cursor.loaded = true
	else
	
	end
end

return cursor