local init = function(Beatmap, osu)
--------------------------------
local import = function(self, filePath, cache)
	self.filePath = filePath
	self.cache = cache

	local breakedPath = explode("/", filePath)
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = string.sub(filePath, 1, #filePath - #self.mapFileName - 1)
	
	self.hitSoundsRules = {
		formats = {"wav", "mp3", "ogg"},
		paths = {self.mapPath}
	}
	
	self.eventSamples = {}
    self.timingPoints = {}
    self.hitObjects = {}

	self.sections = {}
	self.sections.timingPoints = {}
	self.sections.hitObjects = {}
	
	self:load(self.cache)
	
	if not self.cache then
		self:compute()
	end
	
	return self
end

return import
--------------------------------
end

return init
