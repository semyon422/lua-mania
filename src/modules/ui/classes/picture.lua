local picture = {}

picture.x = 0
picture.y = 0
picture.w = 1
picture.h = 1
picture.layer = 2
picture.loaded = false
picture.oldValue = false
picture.value = picture.oldValue
picture.action = function() end
picture.objectCount = 1
picture.mode = "fill" --center - центр, fill - заполн, fit - по размЫ, stretch - раст, tile - тайл, span
picture.update = function() end
picture.hidden = false
picture.apply = false

picture.new = function(self, object)
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "picture" .. math.random()
	object.getValue = object.getValue or function() return object.value end
	
	object.update = function(command)
		local x, y, w, h = object.x, object.y, object.w, object.h
		local name = object.name
		local oldValue = object.oldValue
		object.value = object.getValue()
		local value = object.value
		if command == "activate" then
			object.action(object.value)
			return
		elseif command == "close" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			loveio.objects[name] = nil
			return
		elseif command == "reload" then
			object.loaded = false
			return
		elseif command == "hide" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			object.hidden = true
			return
		elseif command == "show" then
			object.hidden = false
			object.loaded = false
		end
		if object.hidden then return end
		
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
			object.oldValue = value
		end
		if not object.loaded then
			loveio.input.callbacks[object.name] = object.callbacks
			object.loaded = true
		end
	end
	
	if object.apply then
		loveio.objects[object.name] = object
	end
	return object
end

return picture
