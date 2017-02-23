local blockTemplates = {}

-- vertical/horisontal/square/full left/center/right top/center/bottom index
blockTemplates["vlc1"] = {x = 0.05, y = 0.05, w = 0.425, h = 0.9}
blockTemplates["vrc1"] = {x = 0.525, y = 0.05, w = 0.425, h = 0.9}
blockTemplates["hct1"] = {x = 0.05, y = 0.05, w = 0.9, h = 0.425}
blockTemplates["hcb1"] = {x = 0.05, y = 0.525, w = 0.9, h = 0.425}


blockTemplates["ttl2"] = {x = 0.05, y = 0.05, w = 0.9, h = 0.1}
blockTemplates["vlc2"] = {x = 0.05, y = 0.05 + 0.15, w = 0.425, h = 0.9 - 0.15}
blockTemplates["vrc2"] = {x = 0.525, y = 0.05 + 0.15, w = 0.425, h = 0.9 - 0.15}
blockTemplates["hct2"] = {x = 0.05, y = 0.05 + 0.15, w = 0.9, h = 0.425 - 0.15/2}
blockTemplates["hcb2"] = {x = 0.05, y = 0.525 + 0.15/2, w = 0.9, h = 0.425 + 0.15/2}

return blockTemplates
