/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 7
	max_occurrences = 2
	min_players = 1

/datum/round_event/mass_hallucination
	fakeable = FALSE

/datum/round_event/mass_hallucination/start()
<<<<<<< HEAD
	for(var/mob/living/carbon/C in GLOB.living_mob_list)
		C.hallucination += rand(20, 50)
=======
	for(var/mob/living/carbon/C in GLOB.alive_mob_list)
		C.hallucination += rand(20, 50)
>>>>>>> 39375d5... Replaces a bunch of mob loops with hopefully better ones (#32786)
