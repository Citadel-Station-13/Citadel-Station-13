/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 10
	max_occurrences = 2
	min_players = 1

/datum/round_event/mass_hallucination
	fakeable = FALSE

/datum/round_event/mass_hallucination/start()
	switch(rand(1,5))
		if(1) //same sound for everyone
			var/sound = pick("airlock","airlock_pry","console","explosion","far_explosion","mech","glass","alarm","beepsky","mech","wall_decon","door_hack","tesla")
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				new /datum/hallucination/sounds(C, TRUE, sound)
		if(2)
			var/weirdsound = pick("phone","hallelujah","highlander","hyperspace","game_over","creepy","tesla")
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				new /datum/hallucination/weird_sounds(C, TRUE, weirdsound)
		if(3)
			var/stationmessage = pick("ratvar","shuttle_dock","blob_alert","malf_ai","meteors","supermatter")
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				new /datum/hallucination/stationmessage(C, TRUE, stationmessage)
		if(4)
			var/picked_hallucination = pick(	/datum/hallucination/bolts,
												/datum/hallucination/chat,
												/datum/hallucination/message,
												/datum/hallucination/bolts,
												/datum/hallucination/fake_flood,
												/datum/hallucination/battle,
												/datum/hallucination/fire,
												/datum/hallucination/self_delusion,
												/datum/hallucination/death,
												/datum/hallucination/delusion,
												/datum/hallucination/oh_yeah)
			for(var/mob/living/carbon/C in GLOB.alive_mob_list)
				new picked_hallucination(C, TRUE)
		if(5)
			for(var/i in GLOB.alive_mob_list)
				to_chat(i, "<span class="big bold"><font color="red">Shuttle Purchase</font><br>Kate Walker has purchased Standby Evacuation Vessel "Scrapheap Challenge" for -1000 credits.</span>")
