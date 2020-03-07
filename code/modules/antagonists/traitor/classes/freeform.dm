/datum/traitor_class/human/freeform
	name = "Waffle Co Agent"
	employer = "Waffle Company"
	weight = 16
	chaos = 0

/datum/traitor_class/human/freeform/forge_objectives(datum/antagonist/traitor/T)
	var/datum/objective/escape/O = new
	O.explanation_text = "You have no goals! Whatever you can do do antagonize Nanotrasen, do it! The gimmickier, the better! Make sure to escape alive, though!"
	O.owner = T.owner
	T.add_objective(O)
	return
