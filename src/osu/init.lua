local osu = {}

osu.path = "osu/"

osu.Beatmap = require(osu.path .. "Beatmap")(osu)

return osu