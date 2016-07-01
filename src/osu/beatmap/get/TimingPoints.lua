local function TimingPoints(blockLines)
	local out = {}
	local syntax = {
		offset = 1,
		beatLength = 2,
		timingSignature = 3,
		sampleSetId = 4,
		customSampleIndex = 5,
		sampleVolume = 6,
		timingChange = 7,
		kiaiTimeActive = 8
	}
	for numberLine = 1, #blockLines do
		local line = blockLines[numberLine]
		
		local tblTimingPoint = explode(",", line)
		local timingPoint = {}
		
		timingPoint.offset = tonumber(trim(tblTimingPoint[syntax.offset]))
		timingPoint.beatLength = tonumber(trim(tblTimingPoint[syntax.beatLength]))
		timingPoint.timingSignature = tonumber(trim(tblTimingPoint[syntax.timingSignature]))
		timingPoint.sampleSetId = tonumber(trim(tblTimingPoint[syntax.sampleSetId]))
		timingPoint.customSampleIndex = tonumber(trim(tblTimingPoint[syntax.customSampleIndex]))
		timingPoint.sampleVolume = tonumber(trim(tblTimingPoint[syntax.sampleVolume]))
		timingPoint.timingChange = tonumber(trim(tblTimingPoint[syntax.timingChange]))
		timingPoint.kiaiTimeActive = tonumber(trim(tblTimingPoint[syntax.kiaiTimeActive]))
		
		table.insert(out, timingPoint)
	end
	return out
end

return TimingPoints
