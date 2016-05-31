local function HitObjects(blockLines)
	local out = {}
	local syntaxes = {
		default = { x = 1, y = 2, startTime = 3, type = 4, hitSound = 5 },
		circle = { x = 1, y = 2, startTime = 3, type = 4, hitSound = 5, addition = 6 },
		slider = { x = 1, y = 2, startTime = 3, type = 4, hitSound = 5, sliderType = 6, ["repeat"] = 7, pixelLength = 8, edgeHitSound = 9, edgeAddition = 10, addition = 11 },
		spinner = { x = 1, y = 2, startTime = 3, type = 4, hitSound = 5, endTime = 6, addition = 7 },
	}
	local additions = {
		default = 				 {sample = 1, additionalSample = 2, customSampleIndex = 3, hitSoundVolume = 4, hitSound = 5},
		maniaHold = {endTime = 1, sample = 2, additionalSample = 3, customSampleIndex = 4, hitSoundVolume = 5, hitSound = 6}
	}
	for numberLine = 1, #blockLines do
		local line = blockLines[numberLine]
		
		local tblHitObject = explode(",", line)
		local syntax = syntaxes.default
		local addition = additions.default
		local hitObject = {}
		
		hitObject.x = tonumber(trim(tblHitObject[syntax.x]))
		hitObject.y = tonumber(trim(tblHitObject[syntax.y]))
		hitObject.type = tonumber(trim(tblHitObject[syntax.type]))
		hitObject.startTime = tonumber(trim(tblHitObject[syntax.startTime]))
		-- hitObject.hitSound = tonumber(trim(tblHitObject[syntax.hitSound]))
		
		if bit.band(hitObject.type, 1) == 1 then
			syntax = syntaxes.circle
		elseif bit.band(hitObject.type, 2) == 2 then
			syntax = syntaxes.slider
			if tblHitObject[syntax.sliderType] ~= nil then hitObject.sliderType = trim(tblHitObject[syntax.sliderType]) end
			if tblHitObject[syntax["repeat"]] ~= nil then hitObject["repeat"] = tonumber(trim(tblHitObject[syntax["repeat"]])) end
			if tblHitObject[syntax.pixelLength] ~= nil then hitObject.pixelLength = tonumber(trim(tblHitObject[syntax.pixelLength])) end
			if tblHitObject[syntax.edgeHitSound] ~= nil then hitObject.edgeHitSound = tonumber(trim(tblHitObject[syntax.edgeHitSound])) end
			if tblHitObject[syntax.edgeAddition] ~= nil then hitObject.edgeAddition = trim(tblHitObject[syntax.edgeAddition]) end
		elseif bit.band(hitObject.type, 8) == 8 then
			syntax = syntaxes.spinner
		elseif bit.band(hitObject.type, 128) == 128 then
			syntax = syntaxes.circle
			addition = additions.maniaHold
		end
		if bit.band(hitObject.type, 4) == 4 then
			hitObject.newCombo = true
		end
		
		local sample = "soft"
		local additionalSample = nil
		local hitSound = ""
		hitObject.hitSoundVolume = 1
		if tblHitObject[syntax.addition] ~= nil then
			local tblAddition = explode(":", tblHitObject[syntax.addition])
			hitObject.addition = {}
			hitObject.addition.sample = tonumber(trim(tblAddition[addition.sample]))
			hitObject.addition.additionalSample = tonumber(trim(tblAddition[addition.additionalSample]))
			hitObject.addition.customSampleIndex = tonumber(trim(tblAddition[addition.customSampleIndex]))
			hitObject.addition.hitSoundVolume = tonumber(trim(tblAddition[addition.hitSoundVolume]))
			if hitObject.addition.hitSoundVolume > 0 then
				hitObject.hitSoundVolume = hitObject.addition.hitSoundVolume / 100
			end
			hitObject.addition.hitSound = trim(tblAddition[addition.hitSound])
			hitSound = hitObject.addition.hitSound
			
			if hitObject.addition.sample ~= 0 then
				if hitObject.addition.sample == 1 then sample = "normal"
				elseif hitObject.addition.sample == 2 then sample = "soft"
				elseif hitObject.addition.sample == 3 then sample = "drum"
				end
			end
			if hitObject.addition.additionalSample ~= 0 then
				if hitObject.addition.sample == 1 then additionalSample = "normal"
				elseif hitObject.addition.sample == 2 then additionalSample = "soft"
				elseif hitObject.addition.sample == 3 then additionalSample = "drum"
				end
			end
			
			if addition.endTime ~= nil then
				hitObject.endTime = tonumber(trim(tblAddition[addition.endTime]))
			end
		end
		hitObject.hitSound = {}
		if tonumber(trim(tblHitObject[syntax.hitSound])) ~= 0 then
			if bit.band(tonumber(trim(tblHitObject[syntax.hitSound])), 2) then
				table.insert(hitObject.hitSound, sample .. "-hitwhistle")
				if additionalSample then
					table.insert(hitObject.hitSound, additionalSample .. "-hitwhistle")
				end
			end
			if bit.band(tonumber(trim(tblHitObject[syntax.hitSound])), 4) then
				table.insert(hitObject.hitSound, sample .. "-hitfinish")
				if additionalSample then
					table.insert(hitObject.hitSound, additionalSample .. "-hitfinish")
				end
			end
			if bit.band(tonumber(trim(tblHitObject[syntax.hitSound])), 8) then
				table.insert(hitObject.hitSound, sample .. "-hitclap")
				if additionalSample then
					table.insert(hitObject.hitSound, additionalSample .. "-hitclap")
				end
			end
		else
			if #hitObject.hitSound == 0 then
				table.insert(hitObject.hitSound, sample .. "-hitnormal")
				if additionalSample then
					table.insert(hitObject.hitSound, additionalSample .. "-hitnormal")
				end
			end
		end
		if hitSound ~= "" then
			hitObject.hitSound = {hitSound}
		end
		
		table.insert(out, hitObject)
	end
	return out
end

return HitObjects
