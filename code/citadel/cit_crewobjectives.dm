/datum/controller/subsystem/ticker/proc/generate_crew_objectives()
	var/crewMembers = list()
	for(var/V in GLOB.datacore.locked)
		var/datum/data/record/R = V
		var/mob/M = R.fields["reference"]
		if(M && M.mind)
			crewMembers += M.mind
	for(var/datum/mind/crewMind in crewMembers)
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
	var/rolePathString = "/datum/objective/crew/[rolePathString]"
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

/datum/objective/crew/captain/

/datum/objective/crew/captain/hat
	explanation_text = "Don't lose your hat."

/datum/objective/crew/captain/hat/check_completion()
	if(owner.current && owner.current.check_contents_for(/obj/item/clothing/head/caphat))
		return 1
	else
		return 0
