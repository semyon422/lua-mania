local get = {}

get.General = require("osu.beatmap.get.General")
get.Editor = require("osu.beatmap.get.Editor")
get.Metadata = require("osu.beatmap.get.Metadata")
get.Difficulty = require("osu.beatmap.get.Difficulty")
get.Events = require("osu.beatmap.get.Events")
get.TimingPoints = require("osu.beatmap.get.TimingPoints")
get.Colours = require("osu.beatmap.get.Colours")
get.HitObjects = require("osu.beatmap.get.HitObjects")

return get
