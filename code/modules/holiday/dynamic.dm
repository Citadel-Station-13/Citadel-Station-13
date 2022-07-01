/datum/holiday/dynamic
	name = "Dynamic Day"

/datum/holiday/dynamic/shouldCelebrate(dd, mm, yy, ww, ddd)
	var/list/days = CONFIG_GET(keyed_list/dynamic_mode_days)
	return lowertext(ddd) in days

/datum/holiday/dynamic/celebrate()
	GLOB.dynamic_forced_threat_level = rand(50, 100)
