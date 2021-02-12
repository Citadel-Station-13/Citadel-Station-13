/datum/traitor_class/human/assassin
	name = "Donk Co Operative"
	employer = "Donk Corporation"
	weight = 0
	chaos = 1
	threat  = 2

/datum/traitor_class/human/assassin/forge_single_objective(datum/antagonist/traitor/T)
	.=1
	var/permakill_prob = 20
	var/datum/game_mode/dynamic/mode
	if(istype(SSticker.mode,/datum/game_mode/dynamic))
		mode = SSticker.mode
		permakill_prob = max(0,mode.threat_level-50)
	var/list/active_ais = active_ais()
	if(active_ais.len && prob(100/GLOB.joined_player_list.len))
		var/datum/objective/destroy/destroy_objective = new
		destroy_objective.owner = T.owner
		destroy_objective.find_target()
		T.add_objective(destroy_objective)
	else if(prob(permakill_prob))
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = T.owner
		kill_objective.find_target()
		T.add_objective(kill_objective)
	else
		var/datum/objective/assassinate/once/kill_objective = new
		kill_objective.owner = T.owner
		kill_objective.find_target()
		T.add_objective(kill_objective)
