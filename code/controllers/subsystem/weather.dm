//Used for all kinds of weather, ex. lavaland ash storms.

var/datum/subsystem/weather/SSweather
/datum/subsystem/weather
	name = "Weather"
	flags = SS_BACKGROUND
	wait = 10
	var/list/processing = list()
	var/list/existing_weather = list()
	var/list/eligible_zlevels = list(ZLEVEL_LAVALAND)

/datum/subsystem/weather/New()
	NEW_SS_GLOBAL(SSweather)

/datum/subsystem/weather/fire()
	for(var/V in processing)
		var/datum/weather/W = V
		if(W.aesthetic)
			continue
		for(var/mob/living/L in mob_list)
			if(W.can_impact(L))
				W.impact(L)
	for(var/Z in eligible_zlevels)
		var/list/possible_weather_for_this_z = list()
		for(var/V in existing_weather)
			var/datum/weather/WE = V
			if(WE.target_z == Z && WE.probability) //Another check so that it doesn't run extra weather
				possible_weather_for_this_z[WE] = WE.probability
		var/datum/weather/W = pickweight(possible_weather_for_this_z)
		run_weather(W.name, Z)
		eligible_zlevels -= Z
		addtimer(src, "make_z_eligible", rand(3000, 6000) + W.weather_duration_upper, TRUE, Z) //Around 5-10 minutes between weathers

/datum/subsystem/weather/Initialize(start_timeofday)
	..()
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		existing_weather |= new W

/datum/subsystem/weather/proc/run_weather(weather_name, Z)
	if(!weather_name)
		return
	for(var/V in existing_weather)
		var/datum/weather/W = V
		if(W.name == weather_name && W.target_z == Z)
			W.telegraph()

/datum/subsystem/weather/proc/make_z_eligible(zlevel)
	eligible_zlevels |= zlevel
