/obj/machinery/light
	var/obeysnightshift = FALSE
	var/nightshift = FALSE

/obj/machinery/light/Initialize()
	. = ..()
	var/area/a = get_area(src)
	if(a.type in GLOB.the_station_areas)
		obeysnightshift = TRUE
		SSnightshift.nightlights += src

/obj/machinery/light/Destroy()
	if(obeysnightshift && src in SSnightshift.nightlights)
		SSnightshift.nightlights -= src
	. = ..()

SUBSYSTEM_DEF(nightshift)
	name = "Night shift"
	wait = 3000
	flags = SS_BACKGROUND

	var/nightshift = FALSE
	var/nightshift_light_power = 0.45
	var/nightshift_light_color = "#FFDDCC"
	var/nightshift_override = FALSE

	var/list/nightlights = list()

/datum/controller/subsystem/nightshift/Initialize()
	if(CONFIG_GET(flag/nightshift_enabled) && !nightshift_override)
		var/nighttime = text2num(time2text(world.timeofday,"hh"))
		if(!nightshift && ((nighttime >= CONFIG_GET(number/nightshift_start)) || (nighttime <= CONFIG_GET(number/nightshift_finish))))
			nightshift = TRUE
	. = ..()

/datum/controller/subsystem/nightshift/fire(resumed = 0)
	if(CONFIG_GET(flag/nightshift_enabled) && !nightshift_override)
		var/nighttime = text2num(time2text(world.timeofday,"hh"))
		if(GLOB.security_level < SEC_LEVEL_RED && ((nighttime >= CONFIG_GET(number/nightshift_start)) || (nighttime <= CONFIG_GET(number/nightshift_finish))))
			if(!nightshift)
				nightshift = TRUE
				updatenightlights()
				priority_announce("Good afternoon, crew. To reduce power consumption and stimulate the circadian rhythms of some species, all of the lights aboard the station have been dimmed for the night.", 'sound/misc/notice2.ogg', sender_override="Automated Lighting System Announcement")
		else if(nightshift)
			nightshift = FALSE
			updatenightlights()
			priority_announce("Good morning, crew. As it is now day time, all of the lights aboard the station have been restored to their former brightness.", 'sound/misc/notice2.ogg', sender_override="Automated Lighting System Announcement")

/datum/controller/subsystem/nightshift/proc/updatenightlights()
	for(var/obj/machinery/light/nightlight in nightlights)
		if(nightlight)
			nightlight.update(FALSE)
