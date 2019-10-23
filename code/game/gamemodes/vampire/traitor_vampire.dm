/datum/game_mode/traitor/vampire
	name = "traitor+vampire"
	config_tag = "traitorvamp"
	false_report_weight = 10
	traitors_possible = 3 //hard limit on traitors if scaling is turned off
	restricted_jobs = list("AI", "Cyborg")
	required_players = 25
	required_enemies = 1	// how many of each type are required
	recommended_enemies = 3
	reroll_friendly = 1

	var/list/possible_vampires = list()
	var/const/vampire_amt = 2 //hard limit on vampires if scaling is turned off
	var/list/pre_vamps = list()

/datum/game_mode/traitor/vampire/announce()
	to_chat(world, "<B>The current game mode is - Traitor+Vampire!</B>")
	to_chat(world, "<B>There are vampires on the station along with some syndicate operatives out for their own gain! Do not let the vampires and the traitors succeed!</B>")

/datum/game_mode/traitor/vampire/can_start()
	if(!..())
		return 0
	possible_vampires = get_players_for_role(ROLE_VAMPIRE)
	if(possible_vampires.len < required_enemies)
		return 0
	return 1

/datum/game_mode/traitor/vampire/pre_setup()
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		restricted_jobs += "Assistant"

	var/list/datum/mind/possible_vamps = get_players_for_role(ROLE_VAMPIRE)

	var/num_vamp = 1

	if(CONFIG_GET(number/traitor_scaling_coeff))
		num_vamp = max(1, min( round(num_players()/(CONFIG_GET(number/traitor_scaling_coeff)*4))+2, round(num_players()/(CONFIG_GET(number/traitor_scaling_coeff)*2)) ))
	else
		num_vamp = max(1, min(num_players(), vampire_amt/2))

	var/list/old_antag_candidates = antag_candidates.Copy()
	if(possible_vamps.len>0)
		for(var/j in 1 to num_vamp)
			if(!possible_vamps.len) break
			var/datum/mind/vamp = pick(possible_vamps)
			pre_vamps += vamp
			possible_vamps -= vamp
			antag_candidates -= vamp
			vamp.special_role = "Vampire"
			vamp.restricted_roles = restricted_jobs
		antag_candidates = old_antag_candidates // So we still have a chance for a traitor vampire.
		return ..()
	else
		return FALSE

/datum/game_mode/traitor/vampire/post_setup()
	for(var/datum/mind/vamp in pre_vamps)
		vamp.add_antag_datum(/datum/antagonist/vampire)
	..()
	return
//Should turn into a config option
// /datum/game_mode/traitor/vampire/make_antag_chance(mob/living/carbon/human/character) //Assigns vampire to latejoiners
//	var/vampcap = min( round(GLOB.joined_player_list.len/(CONFIG_GET(number/traitor_scaling_coeff)*4))+2, round(GLOB.joined_player_list.len/(CONFIG_GET(number/traitor_scaling_coeff)*2)) )
//	if(SSticker.mode.vampires.len >= vampcap) //Caps number of latejoin antagonists
//		..()
//		return
//	if(SSticker.mode.vampires.len <= (vampcap - 2) || prob(100 / (CONFIG_GET(number/traitor_scaling_coeff) * 4)))
//		if(ROLE_VAMPIRE in character.client.prefs.be_special)
//			if(!is_banned_from(character.ckey, list(ROLE_VAMPIRE, ROLE_SYNDICATE)))
//				if(age_check(character.client))
//					if(!(character.job in restricted_jobs))
//						add_vampire(character)
//	..()

/datum/game_mode/traitor/vampire/generate_report()
	return "We have received some fuzzy reports about the Syndicate cooperating with a bluespace demon.\
			Keep a watch out for syndicate agents, and have your Chaplain on standby."
