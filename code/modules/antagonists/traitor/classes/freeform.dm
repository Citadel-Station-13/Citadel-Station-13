/datum/traitor_class/human/freeform
	name = "Waffle Co Agent"
	employer = "Waffle Company"
	weight = 5
	chaos = 0

/datum/traitor_class/human/freeform/forge_objectives(datum/antagonist/traitor/T)
	var/datum/objective/freedom/O = new
	O.explanation_text = "You have no explicit goals! While we don't approve of mindless slaughter, you may antagonize nanotrasen any way you wish! Don't get captured or killed, but if you've done nothing, you'll be in trouble!"
	O.owner = T.owner
	T.add_objective(O)
	return
