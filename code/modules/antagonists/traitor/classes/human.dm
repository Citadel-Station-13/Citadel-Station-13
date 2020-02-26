#define BASIC_TRAITOR /datum/traitor_class/human

/datum/traitor_class/human
	name = "Traitor"
	chaos = 1

/datum/traitor_class/human/forge_objectives(/datum/antagonist/traitor/T)
	var/is_hijacker = FALSE
	var/datum/game_mode/dynamic/mode
	var/is_dynamic = FALSE
	var/hijack_prob = 0
	if(istype(SSticker.mode,/datum/game_mode/dynamic))
		mode = SSticker.mode
		is_dynamic = TRUE
		if(mode.threat >= CONFIG_GET(number/dynamic_hijack_cost))
			hijack_prob = CLAMP(mode.threat_level-50,0,20)
		if(GLOB.joined_player_list.len>=GLOB.dynamic_high_pop_limit)
			is_hijacker = (prob(hijack_prob) && mode.threat_level > CONFIG_GET(number/dynamic_hijack_high_population_requirement))
		else
			var/indice_pop = min(10,round(GLOB.joined_player_list.len/mode.pop_per_requirement)+1)
			is_hijacker = (prob(hijack_prob) && (mode.threat_level >= CONFIG_GET(number_list/dynamic_hijack_requirements)[indice_pop]))
		if(mode.storyteller.flags & NO_ASSASSIN)
			is_hijacker = FALSE
	else if (GLOB.joined_player_list.len >= 30) // Less murderboning on lowpop thanks
		hijack_prob = 10
		is_hijacker = prob(10)
	var/martyr_chance = prob(hijack_prob*2)
	var/objective_count = is_hijacker 			//Hijacking counts towards number of objectives
	if(!SSticker.mode.exchange_blue && SSticker.mode.traitors.len >= 8) 	//Set up an exchange if there are enough traitors
		if(!SSticker.mode.exchange_red)
			SSticker.mode.exchange_red = T.owner
		else
			SSticker.mode.exchange_blue = T.owner
			assign_exchange_role(SSticker.mode.exchange_red)
			assign_exchange_role(SSticker.mode.exchange_blue)
		objective_count += 1					//Exchange counts towards number of objectives
	var/toa = CONFIG_GET(number/traitor_objectives_amount)
	for(var/i = objective_count, i < toa, i++)
		forge_single_objective(T)

	if(is_hijacker && objective_count <= toa) //Don't assign hijack if it would exceed the number of objectives set in config.traitor_objectives_amount
		if (!(locate(/datum/objective/hijack) in objectives))
			var/datum/objective/hijack/hijack_objective = new
			hijack_objective.owner = T.owner
			T.add_objective(hijack_objective)
			if(is_dynamic)
				var/threat_spent = CONFIG_GET(number/dynamic_hijack_cost)
				mode.spend_threat(threat_spent)
				mode.log_threat("[owner.name] spent [threat_spent] on hijack.")
			return


	var/martyr_compatibility = 1 //You can't succeed in stealing if you're dead.
	for(var/datum/objective/O in objectives)
		if(!O.martyr_compatible)
			martyr_compatibility = 0
			break

	if(martyr_compatibility && martyr_chance)
		var/datum/objective/martyr/martyr_objective = new
		martyr_objective.owner = T.owner
		T.add_objective(martyr_objective)
		if(is_dynamic)
			var/threat_spent = CONFIG_GET(number/dynamic_hijack_cost)
			mode.spend_threat(threat_spent)
			mode.log_threat("[owner.name] spent [threat_spent] on glorious death.")
		return

	else
		if(!(locate(/datum/objective/escape) in objectives))
			var/datum/objective/escape/escape_objective = new
			escape_objective.owner = owner
			T.add_objective(escape_objective)
			return

/datum/traitor_class/human/forge_single_objective(/datum/antagonist/traitor/T)
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
			mode.log_threat("[T.owner.name] spent [threat_spent] on an assassination target.")
		var/list/active_ais = active_ais()
		if(active_ais.len && prob(100/GLOB.joined_player_list.len))
			var/datum/objective/destroy/destroy_objective = new
			destroy_objective.owner = T.owner
			destroy_objective.find_target()
			T.add_objective(destroy_objective)
		else if(prob(30) || (is_dynamic && (mode.storyteller.flags & NO_ASSASSIN)))
			var/datum/objective/maroon/maroon_objective = new
			maroon_objective.owner = T.owner
			maroon_objective.find_target()
			T.add_objective(maroon_objective)
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
		if(prob(15) && !(locate(/datum/objective/download) in objectives) && !(owner.assigned_role in list("Research Director", "Scientist", "Roboticist")))
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
