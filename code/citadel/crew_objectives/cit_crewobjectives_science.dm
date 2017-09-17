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
