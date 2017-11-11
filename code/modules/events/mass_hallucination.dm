<<<<<<< HEAD
/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 7
	max_occurrences = 2
	min_players = 1

/datum/round_event/mass_hallucination/start()
	for(var/mob/living/carbon/C in GLOB.living_mob_list)
=======
/datum/round_event_control/mass_hallucination
	name = "Mass Hallucination"
	typepath = /datum/round_event/mass_hallucination
	weight = 7
	max_occurrences = 2
	min_players = 1

/datum/round_event/mass_hallucination
	fakeable = FALSE

/datum/round_event/mass_hallucination/start()
	for(var/mob/living/carbon/C in GLOB.living_mob_list)
>>>>>>> 3093d86... Makes false alarm use more explicit in event code. (#32559)
		C.hallucination += rand(20, 50)