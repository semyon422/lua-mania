local button = {}

button.new = function(self, data)
	local object = {}
	object.data = {}
	object.data.x = data.x or 0
	object.data.y = data.y or 0
	object.data.layer = data.layer or 2
	object.data.class = data.form or "circle"
	object.data.pressed = false
	object.data.font = object.data.font or ui.fonts.default
	object.data.text = data.text or ""
	object.data.mode = data.mode or "line"
	object.data.name = data.name or "unnamedButton"
	object.data.action = data.action or function() end
	if object.data.class == "circle" then
		object.data.r = data.r or 16
	elseif object.data.class == "rectangle" then
		object.data.w = data.w or 80
		object.data.h = data.h or 32
	end
		
	object.update = function(dt, command)
		if object.data.class == "circle" then
			loveio.output.objects[object.data.name .. object.data.class] = {
				class = object.data.class,
				x = object.data.x,
				y = object.data.y,
				r = object.data.r,
				color = object.data.color,
				mode = object.data.mode
			}
			loveio.output.objects[object.data.name .. "text"] = {
				class = "text",
				xAlign = "center",
				yAlign = "center",
				x = object.data.x,
				y = object.data.y,
				text = object.data.text,
				color = object.data.textColor,
				font = object.data.font
			}
		elseif object.data.class == "rectangle" then
			loveio.output.objects[object.data.name .. object.data.class] = {
				class = object.data.class,
				x = object.data.x - object.data.w / 2,
				y = object.data.y - object.data.h / 2,
				w = object.data.w,
				h = object.data.h,
				color = object.data.color,
				mode = object.data.mode
			}
			loveio.output.objects[object.data.name .. "text"] = {
				class = "text",
				xAlign = "center",
				yAlign = "center",
				x = object.data.x,
				y = object.data.y,
				text = object.data.text,
				color = object.data.textColor,
				font = object.data.font
			}
		end
		loveio.input.callbacks[object.data.name] = {
			mousepressed = function(x, y, button)
				if object.data.class == "circle" then
					if (x - object.data.x)^2 + (y - object.data.y)^2 <= object.data.r^2 then
						object.data.pressed = true
						object.data.mode = "fill"
					end
				elseif object.data.class == "rectangle" then
					if x >= object.data.x - object.data.w / 2 and x <= object.data.x + object.data.w / 2 and y >= object.data.y - object.data.h / 2 and y <= object.data.y + object.data.h / 2 then
						object.data.pressed = true
						object.data.mode = "fill"
					end
				end
			end,
			mousemoved = function(x, y, button)
				if object.data.class == "circle" then
					if not ((x - object.data.x)^2 + (y - object.data.y)^2 <= object.data.r^2) then
						object.data.pressed = false
						object.data.mode = "line"
					end
				elseif object.data.class == "rectangle" then
					if not (x >= object.data.x - object.data.w / 2 and x <= object.data.x + object.data.w / 2 and y >= object.data.y - object.data.h / 2 and y <= object.data.y + object.data.h / 2) then
						object.data.pressed = false
						object.data.mode = "line"
					end
				end
			end,
			mousereleased = function(x, y, button)
				if object.data.class == "circle" then
					if (x - object.data.x)^2 + (y - object.data.y)^2 <= object.data.r^2 then
						object.data.pressed = false
						object.data.mode = "line"
						object.data.action()
					end
				elseif object.data.class == "rectangle" then
					if x >= object.data.x - object.data.w / 2 and x <= object.data.x + object.data.w / 2 and y >= object.data.y - object.data.h / 2 and y <= object.data.y + object.data.h / 2 then
						object.data.pressed = false
						object.data.mode = "line"
						object.data.action()
					end
				end
			end
		}
		if command == "close" then
			objects[object.data.name] = nil
			loveio.input.callbacks[object.data.name] = nil
			loveio.output.objects[object.data.name .. object.data.class] = nil
			loveio.output.objects[object.data.name .. "text"] = nil
		end
	end
	
	setmetatable(object, self)
	self.__index = self
	return object
end

return button