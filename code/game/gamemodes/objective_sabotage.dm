/datum/sabotage_objective
	var/name = "Free Objective"
	var/sabotage_type = "nothing"
	var/special_equipment = list()
	var/list/excludefromjob = list()

/datum/sabotage_objective/New()
	..()
	if(sabotage_type!="nothing")
		GLOB.possible_sabotages += src

/datum/sabotage_objective/proc/check_conditions()
	return TRUE

/datum/sabotage_objective/proc/can_run()
	return TRUE

/datum/sabotage_objective/processing
	var/won = FALSE

/datum/sabotage_objective/processing/New()
	..()
	START_PROCESSING(SSprocessing, src)

/datum/sabotage_objective/processing/proc/check_condition_processing()
	return 1

/datum/sabotage_objective/processing/process()
	check_condition_processing()
	if(won >= 1)
		STOP_PROCESSING(SSprocessing,src)

/datum/sabotage_objective/processing/check_conditions()
	return won

/datum/sabotage_objective/ai_law
	name = "Upload a hacked law to the AI."
	sabotage_type = "ailaw"
	special_equipment = list(/obj/item/aiModule/syndicate)
	excludefromjob = list("Chief Engineer","Research Director","Head of Personnel","Captain","Chief Medical Officer","Head Of Security")

/datum/sabotage_objective/ai_law/can_run()
	return length(active_ais())

/datum/sabotage_objective/ai_law/check_conditions()
	for (var/i in GLOB.ai_list)
		var/mob/living/silicon/ai/aiPlayer = i
		if(aiPlayer.mind && length(aiPlayer.laws.hacked))
			return TRUE
	return FALSE
