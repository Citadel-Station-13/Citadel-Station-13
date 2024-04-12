/datum/traitor_class/human/martyr
	name = "Tiger Cooperator"
	employer = "The Tiger Cooperative"
	weight = 2
	chaos = 5
	threat = 5
	min_players = 20
	uplink_filters = list(/datum/uplink_item/stealthy_weapons/romerol_kit,/datum/uplink_item/bundles_tc/contract_kit)

/datum/traitor_class/human/martyr/forge_objectives(datum/antagonist/traitor/T)
	var/datum/objective/martyr/O = new
	O.explanation_text = "The tiger cooperative have given you free reign. You may do as you wish, as long as you die a glorious death!"
	O.owner = T.owner
	T.add_objective(O)
	return
