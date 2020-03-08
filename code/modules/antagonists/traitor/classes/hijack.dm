/datum/traitor_class/human/hijack
	name = "Gorlex Marauder"
	employer = "The Gorlex Marauders"
	weight = 1
	chaos = 5
	cost = 5
	uplink_filters = list(/datum/uplink_item/stealthy_weapons/romerol_kit)

/datum/traitor_class/human/hijack/forge_objectives(datum/antagonist/traitor/T)
	var/datum/objective/hijack/O = new
	O.explanation_text = "The Gorlex Marauders are letting you do what you want, with one condition: the shuttle must be hijacked."
	O.owner = T.owner
	T.add_objective(O)
	return

/datum/traitor_class/human/hijack/finalize_traitor(datum/antagonist/traitor/T)
	T.hijack_speed=1
