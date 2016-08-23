local init = function(vsrg, game, luaMania)
--------------------------------
local VsrgHitObject = {}

VsrgHitObject.new = function(self, hitObject)
	setmetatable(hitObject, self)
	self.__index = self
	
	return hitObject
end

VsrgHitObject.state = "clear"

VsrgHitObject.judgement = {
	["pass"] = {0, 150},
	["miss"] = {151, 180}
}

VsrgHitObject.getJudgement = function(self, deltaTime)
	local outJudgement, outDelay
	for judgementIndex, judgement in pairs(self.judgement) do
		if deltaTime - judgement[1] > 0 and deltaTime - judgement[2] < 0 then
			outJudgement, outDelay = judgementIndex, "early"
		elseif deltaTime + judgement[1] < 0 and deltaTime + judgement[2] > 0 then
			outJudgement, outDelay = judgementIndex, "lately"
		end
	end
	if not outJudgement and not outDelay then
		if deltaTime + self.judgement.miss[1] < 0 then
			outJudgement, outDelay = "miss", "lately"
		end
	end
	if not outJudgement and not outDelay then
		outJudgement, outDelay = "none", "none"
	end
	return outJudgement, outDelay
end

VsrgHitObject.next = function(self)
	self.column.currentHitObject = self.column.hitObjects[self.columnIndex + 1]
end

VsrgHitObject.h = 0

VsrgHitObject.playHitSound = function(self)
	for hitSoundIndex, hitSoundName in pairs(self.hitSoundsList) do
		if self.column.vsrg.hitSounds[hitSoundName] then
			local hitSound = self.column.vsrg.hitSounds[hitSoundName]:clone()
			hitSound:setVolume(self.volume)
			hitSound:setPitch(1)
			hitSound:play()
		end
	end
end


return VsrgHitObject
--------------------------------
end

return init