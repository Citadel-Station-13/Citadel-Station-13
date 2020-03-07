/datum/traitor_class/human/hijack
	name = "Gorlex Marauder"
	employer = "The Gorlex Marauders"
	weight = 2
	chaos = 5
	cost = 5
	uplink_filters = list(/datum/uplink_item/stealthy_weapons/romerol_kit,/datum/uplink_item/bundles_TC/contract_kit)

/datum/traitor_class/human/hijack/forge_objectives(datum/antagonist/traitor/T)
	var/datum/objective/hijack/O = new
	O.explanation_text = "The Gorlex Marauders are letting you do what you want, with one condition: the shuttle must be hijacked."
	O.owner = T.owner
	T.add_objective(O)
	return
