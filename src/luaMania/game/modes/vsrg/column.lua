local init = function(vsrg, game, luaMania)
--------------------------------
local Column = loveio.LoveioObject:new()

Column.postUpdate = function(self)
	if self.currentHitObject then self.currentHitObject:update() end
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
			if hitObject.endTime then
				table.insert(self.hitObjects, vsrg.Hold:new(hitObject))
			else
				table.insert(self.hitObjects, vsrg.Note:new(hitObject))
			end
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
	local currentTime = 1000*self.map.audio:tell()
	local coord = 0
	
	--old code
	for timingPointIndex, timingPoint in pairs(self.map.timingPoints) do
		if time > currentTime then
			if timingPoint.startTime < time and timingPoint.endTime > currentTime then
				if timingPoint.startTime <= currentTime and timingPoint.endTime > currentTime then
					if time > timingPoint.startTime and time <= timingPoint.endTime then
						coord = coord + (time - currentTime) * timingPoint.velocity
					else
						coord = coord + (timingPoint.endTime - currentTime) * timingPoint.velocity
					end
				elseif timingPoint.startTime > currentTime and timingPoint.endTime <= time then
					coord = coord + (timingPoint.endTime - timingPoint.startTime) * timingPoint.velocity
				elseif timingPoint.startTime < time and timingPoint.endTime > time then
					coord = coord + (time - timingPoint.startTime) * timingPoint.velocity
				end
			end
		elseif time < currentTime then
			if timingPoint.endTime > time and timingPoint.startTime < currentTime then
				if timingPoint.startTime <= currentTime and timingPoint.endTime > currentTime then
					if time > timingPoint.startTime and time <= timingPoint.endTime then
						coord = coord + (time - currentTime) * timingPoint.velocity
					else
						coord = coord + (timingPoint.startTime - currentTime) * timingPoint.velocity
					end
				elseif timingPoint.endTime < currentTime and timingPoint.startTime >= time then
					coord = coord + (timingPoint.startTime - timingPoint.endTime) * timingPoint.velocity
				elseif timingPoint.startTime < time and timingPoint.endTime > time then
					coord = coord + (time - timingPoint.endTime) * timingPoint.velocity
				end
			end
		end
	end
	
	return 1 - self.vsrg.hitPosition - coord/1000
end

Column.draw = function(self)
	for hitObjectIndex = self.firstHitObjectIndex, #self.hitObjects do
		local hitObject = self.hitObjects[hitObjectIndex]
		if hitObject then
			if self:getCoord(hitObject.startTime) < 0 then
				break
			elseif self:getCoord(hitObject.startTime) > 1 + hitObject.h and not hitObject.endTime or hitObject.endTime and self:getCoord(hitObject.endTime) > 1 + hitObject.h then
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