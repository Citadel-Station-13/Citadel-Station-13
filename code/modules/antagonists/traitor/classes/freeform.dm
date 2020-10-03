/datum/traitor_class/human/freeform
	name = "Waffle Co Agent"
	employer = "Waffle Company"
	weight = 16
	chaos = 0

/datum/traitor_class/human/freeform/forge_objectives(datum/antagonist/traitor/T)
	var/datum/objective/escape/O = new
	O.explanation_text = "You have no explicit goals! While we don't approve of mindless slaughter, you may antagonize nanotrasen any way you wish! Make sure to escape alive and not in custody, though!"
	O.owner = T.owner
	T.add_objective(O)
	return
