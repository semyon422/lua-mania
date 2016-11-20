local init = function(vsrg, game)
--------------------------------
local Column = loveio.LoveioObject:new()

Column.postUpdate = function(self)
	if self.currentHitObject then self.currentHitObject:update() end
	self:draw()
end

Column.load = function(self)
	self.hitObjects = {}
	for hitObjectIndex, hitObject in ipairs(self.map.hitObjects) do
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
	
	local columnStart = self.vsrg.skin.game.vsrg.columnStart
	local columnWidth = self.vsrg.skin.game.vsrg.columnWidth
	local columnColor = self.vsrg.skin.game.vsrg.columnColor
	table.insert(self.vsrg.createdObjects, loveio.output.classes.Rectangle:new({
		color = columnColor,
		x = columnStart + columnWidth * (self.key - 1),
		y = 0,
		w = columnWidth,
		h = 1,
		layer = 2
	}):insert(loveio.output.objects))
	local hitPosition = self.vsrg.skin.game.vsrg.hitPosition
	table.insert(self.vsrg.createdObjects, loveio.output.classes.Rectangle:new({
		color = {255,255,255,63},
		x = columnStart + columnWidth * (self.key - 1),
		y = 1 - hitPosition,
		w = columnWidth,
		H = 2,
		layer = 3
	}):insert(loveio.output.objects))
	
	self.keyInfo = {
		key = self.key,
		bind = mainConfig:get("keyBind.game.vsrg." .. self.map.keymode .. "K", self.vsrg.defaultKeyBinds[self.map.keymode])[self.key],
		isDown = false
	}
	loveio.input.callbacks.keypressed[tostring(self)] = function(key)
		if key == self.keyInfo.bind then
			self.keyInfo.isDown = true
			if self.currentHitObject then
				self.currentHitObject:playHitSound()
			end
		end
	end
	loveio.input.callbacks.keyreleased[tostring(self)] = function(key)
		if key == self.keyInfo.bind then
			self.keyInfo.isDown = false
		end
	end
end

Column.unload = function(self)
	loveio.input.callbacks.keypressed[tostring(self)] = nil
	loveio.input.callbacks.keyreleased[tostring(self)] = nil
end

Column.getCoord = function(self, hitObject, key)
	local time = hitObject[key]
	if not time then return end
	local hitObjectTimingPoint = hitObject.startTimingPoint
	if key == "endTime" then
		hitObjectTimingPoint = hitObject.endTimingPoint
	end
	local currentTime = self.map.currentTime
	local coord = 0
	
	
	local speed = mainConfig:get("game.vsrg.speed", 1)
	local audioPitch = mainConfig:get("game.vsrg.audioPitch", 1)
	local velocityPower = mainConfig:get("game.vsrg.velocityPower", 1)
	local velocityMode = mainConfig:get("game.vsrg.velocityMode", 1)
	
	if velocityMode == 1 then
		if time > currentTime then
			for timingPointIndex = self.vsrg.currentTimingPoint.index, hitObjectTimingPoint.index do
				local timingPoint = self.map.timingPoints[timingPointIndex]
				if timingPoint.startTime < time and timingPoint.endTime > currentTime then
					local velocity = timingPoint.velocity ^ velocityPower / audioPitch
					if timingPoint.startTime <= currentTime and timingPoint.endTime > currentTime then
						if time > timingPoint.startTime and time <= timingPoint.endTime then
							coord = coord + (time - currentTime) * velocity
						else
							coord = coord + (timingPoint.endTime - currentTime) * velocity
						end
					elseif timingPoint.startTime > currentTime and timingPoint.endTime <= time then
						coord = coord + (timingPoint.endTime - timingPoint.startTime) * velocity
					elseif timingPoint.startTime < time and timingPoint.endTime > time then
						coord = coord + (time - timingPoint.startTime) * velocity
					end
				end
			end
		elseif time < currentTime then
			for timingPointIndex = hitObjectTimingPoint.index, self.vsrg.currentTimingPoint.index do
				local timingPoint = self.map.timingPoints[timingPointIndex]
				if timingPoint.endTime > time and timingPoint.startTime < currentTime then
					local velocity = timingPoint.velocity ^ velocityPower / audioPitch
					if timingPoint.startTime <= currentTime and timingPoint.endTime > currentTime then
						if time > timingPoint.startTime and time <= timingPoint.endTime then
							coord = coord + (time - currentTime) * velocity
						else
							coord = coord + (timingPoint.startTime - currentTime) * velocity
						end
					elseif timingPoint.endTime < currentTime and timingPoint.startTime >= time then
						coord = coord + (timingPoint.startTime - timingPoint.endTime) * velocity
					elseif timingPoint.startTime < time and timingPoint.endTime > time then
						coord = coord + (time - timingPoint.endTime) * velocity
					end
				end
			end
		end
	elseif velocityMode == 2 then
		local velocity = hitObjectTimingPoint.velocity ^ velocityPower
		coord = (time - currentTime) * velocity
	end
	
	local hitPosition = self.vsrg.skin.game.vsrg.hitPosition
	if currentTime >= 0 then
		return 1 - speed*coord/1000 - hitPosition
	else
		return 1 - speed*(coord - currentTime)/1000 - hitPosition
	end
end

Column.draw = function(self)
	for hitObjectIndex = self.firstHitObjectIndex, #self.hitObjects do
		local hitObject = self.hitObjects[hitObjectIndex]
		if hitObject then
			if self:getCoord(hitObject, "startTime") < 0 then
				break
			elseif self:getCoord(hitObject, "startTime") > 1 + hitObject.h and not hitObject.endTime or hitObject.endTime and self:getCoord(hitObject, "endTime") > 1 + hitObject.h then
				hitObject:remove()
				self.firstHitObjectIndex = hitObject.columnIndex
			else
				hitObject:draw()
			end
		end
	end
end

return Column
--------------------------------
end

return init