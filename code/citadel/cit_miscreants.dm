/datum/controller/subsystem/ticker/proc/generate_miscreant_objectives(var/datum/mind/crewMind)
	if(GLOB.master_mode == "extended")
		return //Thinking about it, extended's chaos whether or not mini-antags are present. But eh, whatever. Here's a sanity check.
	if(!crewMind)
		return
	if(!crewMind.current || !crewMind.objectives || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	var/list/objectiveTypes = typesof(/datum/objective/miscreant) - /datum/objective/miscreant
	if(!objectiveTypes.len)
		return
	var/selectedType = pick(objectiveTypes)
	var/datum/objective/crew/newObjective = new selectedType
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.objectives += newObjective
	crewMind.special_role = "miscreant"
	to_chat(crewMind, "<B><font size=3 color=red>You are a Miscreant.</font></B>")
	to_chat(crewMind, "Pursuing your objective is purely optional, but it is not tracked. You may not commit any traitorous acts not directly related to them.")
	crewMind.announce_objectives()

/datum/objective/miscreant
	explanation_text = "Something broke. Horribly. Dear god, im so sorry. Yell about this in the coderbus discussion channel of citadels discord."

/datum/objective/miscreant/blockade
	explanation_text = "Try to completely block off access to an area, claiming that it's too dangerous."