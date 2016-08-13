local init = function(osu)
--------------------------------
local Beatmap = {}

Beatmap.data = {}

Beatmap.metatable = {
	__index = Beatmap
}

Beatmap.new = function(self)
	local beatmap = {}
	setmetatable(beatmap, Beatmap.metatable)
	
	self.hitObjects = {}
	return beatmap
end

Beatmap.import = require(osu.path .. "beatmap/import")(Beatmap, osu)
Beatmap.export = require(osu.path .. "beatmap/export")(Beatmap, osu)

Beatmap.HitObject = require(osu.path .. "beatmap/HitObject")(Beatmap, osu)

Beatmap.get = function(self, key)
	return self.data[key] and self.data[key].value or ""
end
Beatmap.set = function(self, key, value)
	self.data[key] = self.data[key] or {}
	self.data[key].value = value
	self.data[key].modified = true

	return self:get(key)
end

return Beatmap
--------------------------------
end

return init