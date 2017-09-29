/*				SCIENCE OBJECTIVES				*/

/datum/objective/crew/researchdirector/

/datum/objective/crew/researchdirector/cyborgs //Ported from old Hippie
	explanation_text = "Ensure there are at least (Yo something broke here, yell on citadel's development discussion channel about this) functioning cyborgs when the shift ends."

/datum/objective/crew/researchdirector/cyborgs/New()
	. = ..()
	target_amount = rand(3,10)
	update_explanation_text()

/datum/objective/crew/researchdirector/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/researchdirector/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.living_mob_list)
		if(!(R.stat == DEAD))
			borgcount--
	if(borgcount <= 0)
		return TRUE
	else
		return FALSE

/datum/objective/crew/researchdirector/research //inspired by old hippie's research level objective. should hopefully be compatible with techwebs when that gets finished. hopefully. should be easy to update in the event that it is incompatible with techwebs.
	var/datum/design/targetdesign
	explanation_text = "Make sure the research required to produce a (something broke, yell on citadel's development discussion channel about this) is available on the R&D server by the end of the shift."

/datum/objective/crew/researchdirector/research/New()
	. = ..()
	targetdesign = pick(subtypesof(/datum/design))
	update_explanation_text()

/datum/objective/crew/researchdirector/research/update_explanation_text()
	. = ..()
	explanation_text = "Make sure the research required to produce a [initial(targetdesign.name)] is available on the R&D server by the end of the shift."

/datum/objective/crew/researchdirector/research/check_completion()
	for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
		if(S && S.files && S.files.known_designs)
			if(targetdesign in S.files.known_designs)
				return TRUE
	return FALSE

/datum/objective/crew/scientist/

/datum/objective/crew/scientist/research //inspired by old hippie's research level objective. should hopefully be compatible with techwebs when that gets finished. hopefully. should be easy to update in the event that it is incompatible with techwebs.
	var/datum/design/targetdesign
	explanation_text = "Make sure the research required to produce a (something broke, yell on citadel's development discussion channel about this) is available on the R&D server by the end of the shift."

/datum/objective/crew/scientist/research/New()
	. = ..()
	targetdesign = pick(subtypesof(/datum/design))
	update_explanation_text()

/datum/objective/crew/scientist/research/update_explanation_text()
	. = ..()
	explanation_text = "Make sure the research required to produce a [initial(targetdesign.name)] is available on the R&D server by the end of the shift."

/datum/objective/crew/scientist/research/check_completion()
	for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
		if(S && S.files && S.files.known_designs)
			if(targetdesign in S.files.known_designs)
				return TRUE
	return FALSE

/datum/objective/crew/roboticist/

/datum/objective/crew/roboticist/cyborgs //Ported from old Hippie
	explanation_text = "Ensure there are at least (Yo something broke here, yell on citadel's development discussion channel about this) functioning cyborgs when the shift ends."

/datum/objective/crew/roboticist/cyborgs/New()
	. = ..()
	target_amount = rand(3,10)
	update_explanation_text()

/datum/objective/crew/roboticist/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/roboticist/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.living_mob_list)
		if(!(R.stat == DEAD))
			borgcount--
	if(borgcount <= 0)
		return TRUE
	else
		return FALSE
