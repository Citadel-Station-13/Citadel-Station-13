/datum/traitor_class/human
	name = "Syndicate Agent"
	chaos = 0

/datum/traitor_class/human/forge_objectives(datum/antagonist/traitor/T)
	var/objective_count = 0 			//Hijacking counts towards number of objectives
	if(!SSticker.mode.exchange_blue && SSticker.mode.traitors.len >= 8) 	//Set up an exchange if there are enough traitors
		if(!SSticker.mode.exchange_red)
			SSticker.mode.exchange_red = T.owner
		else
			SSticker.mode.exchange_blue = T.owner
			T.assign_exchange_role(SSticker.mode.exchange_red)
			T.assign_exchange_role(SSticker.mode.exchange_blue)
		objective_count += 1					//Exchange counts towards number of objectives
	var/toa = CONFIG_GET(number/traitor_objectives_amount)
	var/attempts = 0
	for(var/i = objective_count, i < toa, i++)
		var/success = FALSE
		while(!success && attempts < max(toa*10, 100))
			success = forge_single_objective(T)
			attempts += 1
	if(!(locate(/datum/objective/escape) in T.objectives))
		var/datum/objective/escape/escape_objective = new
		escape_objective.owner = T.owner
		T.add_objective(escape_objective)
		return

/datum/traitor_class/human/forge_single_objective(datum/antagonist/traitor/T)
	.=1
	var/assassin_prob = 50
	var/is_dynamic = FALSE
	var/datum/game_mode/dynamic/mode
	if(istype(SSticker.mode,/datum/game_mode/dynamic))
		mode = SSticker.mode
		is_dynamic = TRUE
		assassin_prob = max(0,mode.threat_level-20)
	if(prob(assassin_prob))
		if(is_dynamic)
			var/threat_spent = CONFIG_GET(number/dynamic_assassinate_cost)
			mode.spend_threat(threat_spent)
			mode.log_threat("[T.owner.name] added [threat_spent] on an assassination target.")
		var/list/active_ais = active_ais()
		if(active_ais.len && prob(100/GLOB.joined_player_list.len))
			var/datum/objective/destroy/destroy_objective = new
			destroy_objective.owner = T.owner
			destroy_objective.find_target()
			T.add_objective(destroy_objective)
		else if(prob(max(0,assassin_prob-20)))
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = T.owner
			kill_objective.find_target()
			T.add_objective(kill_objective)
		else
			var/datum/objective/assassinate/once/kill_objective = new
			kill_objective.owner = T.owner
			kill_objective.find_target()
			T.add_objective(kill_objective)
	else
		if(prob(15) && !(locate(/datum/objective/download) in T.objectives) && !(T.owner.assigned_role in list("Research Director", "Scientist", "Roboticist")))
			var/datum/objective/download/download_objective = new
			download_objective.owner = T.owner
			download_objective.gen_amount_goal()
			T.add_objective(download_objective)
		else if(prob(40)) // cum. not counting download: 40%.
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = T.owner
			steal_objective.find_target()
			T.add_objective(steal_objective)
		else if(prob(100/3)) // cum. not counting download: 20%.
			var/datum/objective/sabotage/sabotage_objective = new
			sabotage_objective.owner = T.owner
			sabotage_objective.find_target()
			T.add_objective(sabotage_objective)
		else  // cum. not counting download: 40%
			var/datum/objective/flavor/traitor/flavor_objective = new
			flavor_objective.owner = T.owner
			flavor_objective.forge_objective()
			T.add_objective(flavor_objective)

/datum/traitor_class/human/greet(datum/antagonist/traitor/T)
	to_chat(T.owner.current, "<B><font size=2 color=red>You are under contract with [employer]. They have given you your objectives.</font></B>")
