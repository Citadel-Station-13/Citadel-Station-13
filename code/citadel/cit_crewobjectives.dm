/datum/controller/subsystem/ticker/proc/generate_crew_objectives()
	for(var/datum/mind/crewMind in SSticker.minds)
		if(prob(10) && GLOB.master_mode != "extended")//extended is supposed to have less chaos
			generate_miscreant_objectives(crewMind)
		else
			generate_individual_objectives(crewMind)
	return

/datum/controller/subsystem/ticker/proc/generate_individual_objectives(var/datum/mind/crewMind)
	if(!crewMind)
		return
	if(!crewMind.current || !crewMind.objectives || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	var/rolePathString = "/datum/objective/crew/[ckey(crewMind.assigned_role)]"
	var/rolePath = text2path(rolePathString)
	if (isnull(rolePath))
		return
	var/list/objectiveTypes = typesof(rolePath) - rolePath
	if(!objectiveTypes.len)
		return
	var/selectedType = pick(objectiveTypes)
	var/datum/objective/crew/newObjective = new selectedType
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.objectives += newObjective
	crewMind.announce_objectives()

/datum/objective/crew/
	explanation_text = "Yell on the coderbus discussion channel on Citadels discord if this ever shows up. Something just broke here, dude"

/datum/objective/crew/proc/setup()

/*				COMMAND OBJECTIVES				*/

/datum/objective/crew/captain/

/datum/objective/crew/captain/hat
	explanation_text = "Don't lose your hat."

/datum/objective/crew/captain/hat/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/caphat))
		return 1
	else
		return 0

/datum/objective/crew/captain/datfukkendisk
	explanation_text = "Defend the nuclear authentication disk at all costs, and personally deliver it to Centcom."

/datum/objective/crew/captain/datfukkendisk/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/disk/nuclear) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return 1
	else
		return 0

/*				SECURITY OBJECTIVES				*/

/datum/objective/crew/headofsecurity/

/datum/objective/crew/headofsecurity/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/headofsecurity/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/securityofficer/

/datum/objective/crew/securityofficer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/securityofficer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/detective/

/datum/objective/crew/detective/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/detective/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/datum/objective/crew/lawyer/

/datum/objective/crew/lawyer/justicecrew
	explanation_text = "Ensure there are no innocent crew members in the brig when the shift ends."

/datum/objective/crew/lawyer/justicecrew/check_completion()
	if(owner.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !M.assigned_role == "Security Officer" && !M.assigned_role == "Detective" && !M.assigned_role == "Head of Security" && !M.assigned_role == "Lawyer" && get_area(M.current) != typesof(/area/security))
					return 0
		return 1

/*				SCIENCE OBJECTIVES				*/

/datum/objective/crew/researchdirector/

/datum/objective/crew/researchdirector/cyborgs
	explanation_text = "Ensure there are at least (Yo something broke here, yell on citadel's codebus discussion channel about this) functioning cyborgs when the shift ends."

/datum/objective/crew/researchdirector/cyborgs/New()
	. = ..()
	target_amount = rand(3,20)
	update_explanation_text()

/datum/objective/crew/researchdirector/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/researchdirector/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.living_mob_list)
		if(!R.stat == DEAD)
			borgcount--
	if(borgcount <= 0)
		return 1
	else
		return 0

/datum/objective/crew/roboticist/

/datum/objective/crew/roboticist/cyborgs
	explanation_text = "Ensure there are at least (Yo something broke here, yell on citadel's codebus discussion channel about this) functioning cyborgs when the shift ends."

/datum/objective/crew/roboticist/cyborgs/New()
	. = ..()
	target_amount = rand(3,20)
	update_explanation_text()

/datum/objective/crew/roboticist/cyborgs/update_explanation_text()
	. = ..()
	explanation_text = "Ensure there are at least [target_amount] functioning cyborgs when the shift ends."

/datum/objective/crew/roboticist/cyborgs/check_completion()
	var/borgcount = target_amount
	for(var/mob/living/silicon/robot/R in GLOB.living_mob_list)
		if(!R.stat == DEAD)
			borgcount--
	if(borgcount <= 0)
		return 1
	else
		return 0
