local init = function(self)
--------------------------------
local callbacks = {}

callbacks.wheelmoved = function(_, direction)
	self:scrollTo(self.scroll + direction)
end
callbacks.keypressed = function(key)
	if love.keyboard.isDown("lshift") then
		if tonumber(key) then
			local key = tonumber(key)
			if key ~= 0 then
				self:scrollTo(math.ceil(#self.list/9*(key-1)))
			else
				self:scrollTo(#self.list/9*9)
			end
		elseif key == "escape" then
			love.event.quit()
		end
	elseif key == "up" then
		self:scrollTo(self.scroll - 1)
	elseif key == "down" then
		self:scrollTo(self.scroll + 1)
	elseif key == "left" then
		self:scrollTo(self.scroll - 1)
		self.selectedItem = self.scrollTarget
	elseif key == "right" then
		self:scrollTo(self.scroll + 1)
		self.selectedItem = self.scrollTarget
	elseif key == "return" then
		if self.selectedItem then
			for _, button in pairs(self.buttons) do
				if button.itemIndex == self.selectedItem then
					button:action()
				end
			end
		end
	elseif key == "f5" then
		self:reload()
	end
end

return callbacks
--------------------------------
end

return init