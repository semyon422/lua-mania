local osu = {}

osu.path = "osu/"

osu.beatmap = require(osu.path .. "beatmap")(osu)

return osu