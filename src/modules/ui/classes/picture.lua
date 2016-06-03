local picture = {}

picture.new = function(self, data)
	local object = {}
	object.x = data.x or 0
	object.y = data.y or 0
	object.w = data.w or 1
	object.h = data.h or 1
	object.layer = data.layer or 2
	object.loaded = false
	object.oldValue = data.value or false
	object.value = data.value or object.oldValue
	object.getValue = data.getValue or function() return object.value end
	object.value = object.getValue()
	object.action = data.action or function() end
	object.name = data.name or "picture" .. math.random()
	object.objectCount = 1
	object.callbacks = data.callbacks or {}
	object.mode = data.mode or "fill" --center - центр, fill - заполн, fit - по размЫ, stretch - раст, tile - тайл, span
	
	object.update = function(command)
		local x, y, w, h = object.x, object.y, object.w, object.h
		object.value = object.getValue()
		local oldValue = object.oldValue
		local value = object.value
		local name = object.name
		if oldValue ~= value or not object.loaded then
			local drawable = love.graphics.newImage(object.value)
			local sx = 1
			local dw = pos.X2x(drawable:getWidth())
			local dh = pos.Y2y(drawable:getHeight())
			if object.mode == "fill" then
				if w < dw * sx then
					-- nothing
				end
				if h < dh * sx then
					sx = h / dh
				end
				if w > dw * sx then
					sx = w / dw
				end
				if h > dh * sx then
					sx = h / dh
				end
				loveio.output.objects[name .. 1] = {
					class = "drawable",
					x = x + w / 2, y = y + h / 2,
					ox = dw / 2, oy = dh / 2,
					sx = sx,
					drawable = drawable,
					layer = object.layer
				}
			else
				loveio.output.objects[name .. 1] = {
					class = "drawable",
					x = x, y = y,
					sx = w / dw,
					drawable = drawable,
					layer = object.layer
				}
			end
		end
		if not object.loaded then
			loveio.input.callbacks[object.name] = object.callbacks
			object.loaded = true
		end
		if command == "close" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			objects[object.name] = nil
		end
		if command == "reload" then
			object.loaded = false
		end
	end
	
	setmetatable(object, self)
	self.__index = self
	return object
end

return picture
