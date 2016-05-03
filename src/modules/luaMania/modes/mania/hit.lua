local hit = function(mismatch, key)
	local offset = luaMania.config.offset
	local trueMismatch = mismatch + offset
	local currentTime = luaMania.map.stats.currentTime
	local hitTiming = luaMania.config.hitTiming
	local oCurrent = luaMania.map.objects.current
	local kHitted = objects.mania.data.keys.hitted
	local stats = luaMania.map.stats
	local combo = stats.combo
		
	local note = oCurrent[key]
	
	if note.state == 2 and note.type == 2 and note.startTime + offset <= currentTime + hitTiming[#hitTiming] and note.startTime + offset > currentTime - hitTiming[#hitTiming - 1] then
	
	else
		for i = 1, #hitTiming do
			if math.abs(trueMismatch) <= hitTiming[i] then 
				stats.lastHit = i
				stats.hits[i] = stats.hits[i] or 0
				stats.hits[i] = stats.hits[i] + 1
				--if i == #hitTiming then combo.current = 0 end
				break
			end
		end
	end
	if math.abs(trueMismatch) <= hitTiming[#hitTiming] then
		-- combo.current = combo.current + 1
		-- if combo.max < combo.current then
			-- combo.max = combo.current
		-- end
		kHitted[key] = true
	end
	if oCurrent[key].type == 2 then
		if oCurrent[key].startTime < currentTime - hitTiming[#hitTiming - 1] and oCurrent[key].endTime > currentTime + hitTiming[#hitTiming - 1] then
			kHitted[key] = true
		end
	end
end

return hit