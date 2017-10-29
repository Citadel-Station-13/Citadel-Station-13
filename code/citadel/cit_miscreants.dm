/datum/controller/subsystem/ticker/proc/generate_miscreant_objectives(var/datum/mind/crewMind)
	if(!GLOB.miscreants_allowed)
		return
	if(!crewMind)
		return
	if(!crewMind.current || !crewMind.objectives || crewMind.special_role)
		return
	if(!crewMind.assigned_role)
		return
	if(!(ROLE_MISCREANT in crewMind.current.client.prefs.be_special))
		return
	if(jobban_isbanned(crewMind, "Syndicate"))
		return
	var/list/objectiveTypes = miscreantobjlist
	if(!objectiveTypes.len)
		return
	var/selectedType = pick(objectiveTypes)
	var/datum/objective/miscreant/newObjective = new selectedType
	if(!newObjective)
		return
	newObjective.owner = crewMind
	crewMind.objectives += newObjective
	crewMind.special_role = "miscreant"
	to_chat(crewMind, "<B><font size=3 color=red>You are a Miscreant.</font></B>")
	to_chat(crewMind, "<B>Pursuing your objective is entirely optional, as the completion of your objective is unable to be tracked. Performing traitorous acts not directly related to your objective may result in permanent termination of your employment.</B>")
	to_chat(crewMind, "<B>Your objective:</B> [newObjective.explanation_text]")

/datum/objective/miscreant
	explanation_text = "Something broke. Horribly. Dear god, im so sorry. Yell about this in the development discussion channel of citadels discord."

/*				Goon's Miscreant Objectives				*/

/datum/objective/miscreant/blockade
	explanation_text = "Try to completely block off access to an area, under the pretense that it's too dangerous."

/datum/objective/miscreant/incompetent
	explanation_text = "Be as useless and incompetent as possible without getting killed."

/datum/objective/miscreant/litterbug
	explanation_text = "Make a huge mess wherever you go."

/datum/objective/miscreant/stalk
	explanation_text = "Single out a crew member and stalk them everywhere."

/datum/objective/miscreant/creepy
	explanation_text = "Sneak around looking as suspicious as possible without actually doing anything illegal."

/datum/objective/miscreant/construction
	explanation_text = "Perform obnoxious construction and renovation projects. Insist that you're just doing your job."

/datum/objective/miscreant/access
	explanation_text = "Make as much of the station as possible accessible to the public."

/datum/objective/miscreant/whiny
	explanation_text = "Complain incessantly about every minor issue you find."

/*				Citadel's Miscreant Objectives				*/

/datum/objective/miscreant/immersions
	explanation_text = "Act as out of character as you possibly can."

/datum/objective/miscreant/racism
	explanation_text = "Attempt to establish superiority of your species."

/datum/objective/miscreant/cargonia
	explanation_text = "Attempt to establish independence of your department."
