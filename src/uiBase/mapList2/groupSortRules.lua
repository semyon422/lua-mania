local groupSortRules = {}


local groupStage1 = function(object)
	local outTable = {
		artist = object.artist,
		title = object.title,
		filePath = object.filePath
	}
	local outTitle = object.artist .. " - " .. object.title
	local outId = object.artist .. object.title
	return outTable, outTitle, outId
end
local groupStageN = function(object, n)
	local breakedPath = explode("/", object.filePath)
	
	local outTable = {
		filePath = object.filePath
	}
	local outTitle = breakedPath[#breakedPath - n] or "all"
	local outId = outTitle
	return outTable, outTitle, outId
end
groupSortRules.getGroupInfo = function(object, stage)
	if stage == 1 then
		return groupStage1(object)
	else
		return groupStageN(object, stage)
	end
end


local sortStage1 = function(a, b)
	return (a.mapName or "") < (b.mapName or "")
end
local sortStageN = function(a, b)
	return (a.filePath or "") < (b.filePath or "")
end
groupSortRules.getSortFunction = function(stage)
	if stage == 1 then
		return sortStage1
	else
		return sortStageN
	end
end


return groupSortRules