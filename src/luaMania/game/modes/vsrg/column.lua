local init = function(vsrg, game, luaMania)
--------------------------------
local Column = loveio.LoveioObject:new()

Column.update = function(self)
	if not self.loaded then
		self:load()
		self.loaded = true
	end
	self.currentHitObject:update()
	self:draw()
end

Column.load = function(self)
	self.hitObjects = {}
	local interval = 512 / self.map:get("CircleSize")
	for hitObjectIndex, hitObject in ipairs(self.map.hitObjects) do
		hitObject.key = hitObject.key or 0
		if hitObject.key == 0 then
			for newKey = 1, self.map:get("CircleSize") do
				if hitObject.x >= interval * (newKey - 1) and hitObject.x < newKey * interval then
					hitObject.key = newKey
					break
				end
			end
		end
		if hitObject.key == self.key then
			hitObject.columnIndex = #self.hitObjects + 1
			hitObject.column = self
			table.insert(self.hitObjects, vsrg.HitObject:new(hitObject))
		end
	end
	self.firstHitObjectIndex = 1
	
	self.currentHitObject = self.hitObjects[1]
	
	self.createdObjects = {}
	table.insert(self.createdObjects, loveio.output.classes.Rectangle:new({
		name = "column" .. self.key .. "bg",
		color = {0,0,0,127},
		x = 0.1 * (self.key - 1),
		y = 0,
		w = 0.1,
		h = 1,
		layer = 2,
		insert = {table = loveio.output.objects, onCreate = true}
	}))
	
	self.keyInfo = {
		key = self.key,
		bind = luaMania.config["game.vsrg." .. self.map:get("CircleSize") .. "K." .. self.key].value,
		isDown = false
	}
	loveio.input.callbacks.keypressed[self.name] = function(key)
		if key == self.keyInfo.bind then
			self.keyInfo.isDown = true
		end
	end
	loveio.input.callbacks.keyreleased[self.name] = function(key)
		if key == self.keyInfo.bind then
			self.keyInfo.isDown = false
		end
	end
end

Column.unload = function(self)
	if self.createdObjects then
		for createdObjectIndex, createdObject in pairs(self.createdObjects) do
			createdObject:remove()
		end
	end
	loveio.input.callbacks.keypressed[self.name] = nil
	loveio.input.callbacks.keyreleased[self.name] = nil
end

Column.getCoord = function(self, time)
	-- return self:getTime(time) / 1000 + self.vsrg.hitPosition
	return 1 - (self:getTime(time) / 1000 + self.vsrg.hitPosition)
end
Column.scaleTime = function(self, time)
	return time
end
Column.getTime = function(self, time)
	return self:scaleTime(time - 1000*self.map.audio:tell())
end

Column.draw = function(self)
	for hitObjectIndex = self.firstHitObjectIndex, #self.hitObjects do
		local hitObject = self.hitObjects[hitObjectIndex]
		if hitObject then
			-- if self:getCoord(hitObject.startTime) > 1 then
				-- break
			-- elseif self:getCoord(hitObject.startTime) < 0 and not hitObject.endTime or hitObject.endTime and self:getCoord(hitObject.endTime) < 0 then
				-- hitObject:remove()
				-- self.firstHitObjectIndex = hitObject.columnIndex
			-- else
				-- hitObject:draw((hitObject.key - 1) / 10, self:getCoord(hitObject.startTime))
			-- end
			if self:getCoord(hitObject.startTime) < 0 then
				break
			elseif self:getCoord(hitObject.startTime) > 1 and not hitObject.endTime or hitObject.endTime and self:getCoord(hitObject.endTime) > 1 then
				hitObject:remove()
				self.firstHitObjectIndex = hitObject.columnIndex
			else
				hitObject:draw((hitObject.key - 1) / 10, self:getCoord(hitObject.startTime))
			end
		end
	end
end

return Column
--------------------------------
end

return init