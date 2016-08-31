local bg = loveio.LoveioObject:new()

bg.insert = {table = objects, onCreate = false}
bg.name = "menuBackground"

bg.polygons = {}
bg.colors = {}
bg.colors.min = 127 - 16
bg.colors.max = 127 + 16
bg.colors.global = {0,0,0}
bg.colors.target = 1
bg.colors.points = {
	{63,63,63},
	{255,191,191},
	{191,255,191},
	{191,191,255},
	{255,255,191},
	{255,191,255},
	{191,255,255}
}

for i = 1, 16 do
	local color = math.random(bg.colors.min, bg.colors.max)
	repeat blinkDirection = math.random(-1,1) until blinkDirection ~= 0
	table.insert(bg.polygons, loveio.output.classes.Polygon:new({
		vertices = {0, 0, 0, 0, 0, 0, 0, 0},
		color = {color, color, color},
		blinkDirection = blinkDirection,
		layer = 1
	}))
end

bg.blinkConuter = 0
bg.blinkDelay = 0.1

bg.computePolygons = function(self, w, h)
	for polygonIndex, polygon in pairs(self.polygons) do
		local v = polygon.vertices
		local x = (polygonIndex - 1) * w/8
		v[1], v[2] = x, 0
		v[3], v[4] = x - h, h
		v[5], v[6] = x - h + w/8, h
		v[7], v[8] = x + w/8, 0
		loveio.output.objects["bgPolygon" .. polygonIndex] = polygon
	end
end

bg.load = function(self)
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	self:computePolygons(w, h)
	loveio.input.callbacks.resize.menuBackground = function(w, h)
		self:computePolygons(w, h)
	end
end

bg.postUpdate = function(self)
	self.blinkConuter = self.blinkConuter + loveio.dt
	if self.blinkConuter >= self.blinkDelay then
		self.blinkConuter = self.blinkConuter - self.blinkDelay
		for polygonIndex, polygon in pairs(self.polygons) do
			if polygon.blinkDirection == 1 then
				if polygon.color[1] >= self.colors.max then
					polygon.blinkDirection = -1
				end
			else
				if polygon.color[1] <= self.colors.min then
					polygon.blinkDirection = 1
				end
			end
			local newColor = polygon.color[1] + polygon.blinkDirection
			polygon.color[1], polygon.color[2], polygon.color[3] = newColor, newColor, newColor
		end
	end
end

bg.unload = function(self)
	for polygonIndex, polygon in pairs(self.polygons) do
		loveio.output.objects["bgPolygon" .. polygonIndex] = nil
	end
	loveio.input.callbacks.resize.menuBackground = nil
	self.loaded = false
end

return bg