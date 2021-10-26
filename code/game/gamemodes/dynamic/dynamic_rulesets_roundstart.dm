
//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/traitor
	name = "Traitors"
	config_tag = "traitor"
	antag_flag = ROLE_TRAITOR
	antag_datum = /datum/antagonist/traitor/
	minimum_required_age = 0
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster", "Cyborg")
	restricted_roles = list("Cyborg", "AI")
	required_candidates = 1
	flags = TRAITOR_RULESET | MINOR_RULESET | ALWAYS_MAX_WEIGHT_RULESET
	weight = 5
	cost = 10	// Avoid raising traitor threat above 10, as it is the default low cost ruleset.
	scaling_cost = 10
	requirements = list(50,50,50,50,50,50,50,50,50,50)
	high_population_requirement = 40
	antag_cap = list(1,1,1,1,2,2,2,2,3,3)
	property_weights = list("story_potential" = 2, "trust" = -1, "extended" = 1, "valid" = 1)
	var/autotraitor_cooldown = 450 // 15 minutes (ticks once per 2 sec)

/datum/dynamic_ruleset/roundstart/traitor/pre_execute()
	var/num_traitors = antag_cap[indice_pop] * (scaled_times + 1)
	for (var/i = 1 to num_traitors)
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.special_role = ROLE_TRAITOR
		M.mind.restricted_roles = restricted_roles
	return TRUE

//////////////////////////////////////////
//                                      //
//           BLOOD BROTHERS             //
//                                      //
//////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/traitorbro
	name = "Blood Brothers"
	config_tag = "traitorbro"
	antag_flag = ROLE_BROTHER
	antag_datum = /datum/antagonist/brother
	restricted_roles = list("AI", "Cyborg")
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 2
	flags = MINOR_RULESET
	weight = 4
	cost = 10
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	high_population_requirement = 101
	antag_cap = list(2,2,2,2,2,2,2,2,2,2)	// Can pick 3 per team, but rare enough it doesn't matter.
	property_weights = list("story_potential" = 1, "trust" = -1, "extended" = 1, "valid" = 1)
	var/list/datum/team/brother_team/pre_brother_teams = list()
	var/const/min_team_size = 2

/datum/dynamic_ruleset/roundstart/traitorbro/pre_execute()
	var/num_teams = (antag_cap[indice_pop]/min_team_size) * (scaled_times + 1) // 1 team per scaling
	for(var/j = 1 to num_teams)
		if(candidates.len < min_team_size || candidates.len < required_candidates)
			break
		var/datum/team/brother_team/team = new
		var/team_size = prob(10) ? min(3, candidates.len) : 2
		for(var/k = 1 to team_size)
			var/mob/bro = pick_n_take(candidates)
			assigned += bro.mind
			team.add_member(bro.mind)
			bro.mind.special_role = "brother"
			bro.mind.restricted_roles = restricted_roles
		pre_brother_teams += team
	return TRUE

/datum/dynamic_ruleset/roundstart/traitorbro/execute()
	for(var/datum/team/brother_team/team in pre_brother_teams)
		team.pick_meeting_area()
		team.forge_brother_objectives()
		for(var/datum/mind/M in team.members)
			M.add_antag_datum(/datum/antagonist/brother, team)
		team.update_name()
	mode.brother_teams += pre_brother_teams
	return TRUE

//////////////////////////////////////////////
//                                          //
//               CHANGELINGS                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/changeling
	name = "Changelings"
	config_tag = "changeling"
	antag_flag = ROLE_CHANGELING
	antag_datum = /datum/antagonist/changeling
	restricted_roles = list("AI", "Cyborg")
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 1
	flags = MINOR_RULESET
	weight = 3
	cost = 15
	scaling_cost = 15
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	property_weights = list("trust" = -2, "valid" = 2)
	high_population_requirement = 10
	antag_cap = list(1,1,1,1,1,2,2,2,2,3)
	var/team_mode_probability = 30

/datum/dynamic_ruleset/roundstart/changeling/pre_execute()
	var/num_changelings = antag_cap[indice_pop] * (scaled_times + 1)
	for (var/i = 1 to num_changelings)
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.restricted_roles = restricted_roles
		M.mind.special_role = ROLE_CHANGELING
	return TRUE

/datum/dynamic_ruleset/roundstart/changeling/execute()
	var/team_mode = FALSE
	if(prob(team_mode_probability))
		team_mode = TRUE
		var/list/team_objectives = subtypesof(/datum/objective/changeling_team_objective)
		var/list/possible_team_objectives = list()
		for(var/T in team_objectives)
			var/datum/objective/changeling_team_objective/CTO = T
			if(assigned.len >= initial(CTO.min_lings))
				possible_team_objectives += T

		if(possible_team_objectives.len && prob(20*assigned.len))
			GLOB.changeling_team_objective_type = pick(possible_team_objectives)
	for(var/datum/mind/changeling in assigned)
		var/datum/antagonist/changeling/new_antag = new antag_datum()
		new_antag.team_mode = team_mode
		changeling.add_antag_datum(new_antag)
	return TRUE

//////////////////////////////////////////////
//                                          //
//              ELDRITCH CULT               //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/heretics
	name = "Heretics"
	antag_flag = "heretic"
	antag_datum = /datum/antagonist/heretic
	protected_roles = list("Prisoner","Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("AI", "Cyborg")
	required_candidates = 1
	flags = MINOR_RULESET
	weight = 3
	cost = 25
	scaling_cost = 15
	requirements = list(60,60,60,55,50,50,50,50,50,50)
	property_weights = list("story_potential" = 1, "trust" = -1, "chaos" = 2, "extended" = -1, "valid" = 2)
	antag_cap = list(1,1,1,1,2,2,2,2,3,3)
	high_population_requirement = 50


/datum/dynamic_ruleset/roundstart/heretics/pre_execute()
	. = ..()
	var/num_ecult = antag_cap[indice_pop] * (scaled_times + 1)

	for (var/i = 1 to num_ecult)
		var/mob/picked_candidate = pick_n_take(candidates)
		assigned += picked_candidate.mind
		picked_candidate.mind.restricted_roles = restricted_roles
		picked_candidate.mind.special_role = ROLE_HERETIC
	return TRUE

/datum/dynamic_ruleset/roundstart/heretics/execute()

	for(var/c in assigned)
		var/datum/mind/cultie = c
		var/datum/antagonist/heretic/new_antag = new antag_datum()
		cultie.add_antag_datum(new_antag)

	return TRUE

//////////////////////////////////////////////
//                                          //
//               WIZARDS                    //
//                                          //
//////////////////////////////////////////////

// Dynamic is a wonderful thing that adds wizards to every round and then adds even more wizards during the round.
/datum/dynamic_ruleset/roundstart/wizard
	name = "Wizard"
	config_tag = "wizard"
	persistent = TRUE
	antag_flag = ROLE_WIZARD
	antag_datum = /datum/antagonist/wizard
	minimum_required_age = 14
	restricted_roles = list("Head of Security", "Captain") // Just to be sure that a wizard getting picked won't ever imply a Captain or HoS not getting drafted
	required_candidates = 1
	weight = 1
	cost = 30
	requirements = list(101,101,101,60,50,50,50,50,50,50)
	high_population_requirement = 50
	property_weights = list("story_potential" = 2, "trust" = 1, "chaos" = 2, "extended" = -2, "valid" = 2)
	var/list/roundstart_wizards = list()

/datum/dynamic_ruleset/roundstart/wizard/acceptable(population=0, threat=0)
	if(GLOB.wizardstart.len == 0)
		log_admin("Cannot accept Wizard ruleset. Couldn't find any wizard spawn points.")
		message_admins("Cannot accept Wizard ruleset. Couldn't find any wizard spawn points.")
		return FALSE
	return ..()

/datum/dynamic_ruleset/roundstart/wizard/pre_execute()
	if(GLOB.wizardstart.len == 0)
		return FALSE
	mode.antags_rolled += 1
	var/mob/M = pick_n_take(candidates)
	if (M)
		assigned += M.mind
		M.mind.assigned_role = ROLE_WIZARD
		M.mind.special_role = ROLE_WIZARD

	return TRUE

/datum/dynamic_ruleset/roundstart/wizard/execute()
	for(var/datum/mind/M in assigned)
		M.current.forceMove(pick(GLOB.wizardstart))
		M.add_antag_datum(new antag_datum())
		roundstart_wizards += M
	return TRUE

/datum/dynamic_ruleset/roundstart/wizard/rule_process() // i can literally copy this from are_special_antags_dead it's great
	for(var/datum/mind/wizard in roundstart_wizards)
		if(isliving(wizard.current) && wizard.current.stat!=DEAD)
			return FALSE

	for(var/obj/item/phylactery/P in GLOB.poi_list) //TODO : IsProperlyDead()
		if(P.mind && P.mind.has_antag_datum(/datum/antagonist/wizard))
			return FALSE

	if(SSevents.wizardmode) //If summon events was active, turn it off
		SSevents.toggleWizardmode()
		SSevents.resetFrequency()

	return RULESET_STOP_PROCESSING


//////////////////////////////////////////////
//                                          //
//                BLOOD CULT                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/bloodcult
	name = "Blood Cult"
	config_tag = "cult"
	antag_flag = ROLE_CULTIST
	antag_datum = /datum/antagonist/cult
	minimum_required_age = 14
	restricted_roles = list("AI", "Cyborg")
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 2
	weight = 3
	cost = 30
	requirements = list(101,101,101,80,70,60,50,50,50,50)
	property_weights = list("story_potential" = -1, "trust" = -1, "chaos" = 1, "conversion" = 1, "extended" = -2, "valid" = 2)
	high_population_requirement = 50
	flags = HIGHLANDER_RULESET
	antag_cap = list(2,2,2,3,3,4,4,4,4,4)
	var/datum/team/cult/main_cult

/datum/dynamic_ruleset/roundstart/bloodcult/ready(forced = FALSE)
	required_candidates = antag_cap[indice_pop]
	. = ..()

/datum/dynamic_ruleset/roundstart/bloodcult/pre_execute()
	var/cultists = antag_cap[indice_pop]
	mode.antags_rolled += cultists
	for(var/cultists_number = 1 to cultists)
		if(candidates.len <= 0)
			break
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.special_role = ROLE_CULTIST
		M.mind.restricted_roles = restricted_roles
	return TRUE

/datum/dynamic_ruleset/roundstart/bloodcult/execute()
	main_cult = new
	for(var/datum/mind/M in assigned)
		var/datum/antagonist/cult/new_cultist = new antag_datum()
		new_cultist.cult_team = main_cult
		new_cultist.give_equipment = TRUE
		M.add_antag_datum(new_cultist)
	main_cult.setup_objectives()
	return TRUE

/datum/dynamic_ruleset/roundstart/bloodcult/round_result()
	..()
	if(main_cult.check_cult_victory())
		SSticker.mode_result = "win - cult win"
		SSticker.news_report = CULT_SUMMON
	else
		SSticker.mode_result = "loss - staff stopped the cult"
		SSticker.news_report = CULT_FAILURE

//////////////////////////////////////////////
//                                          //
//          NUCLEAR OPERATIVES              //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/nuclear
	name = "Nuclear Emergency"
	config_tag = "nuclear"
	antag_flag = ROLE_OPERATIVE
	antag_datum = /datum/antagonist/nukeop
	var/datum/antagonist/antag_leader_datum = /datum/antagonist/nukeop/leader
	minimum_required_age = 14
	restricted_roles = list("Head of Security", "Captain") // Just to be sure that a nukie getting picked won't ever imply a Captain or HoS not getting drafted
	required_candidates = 5
	weight = 3
	cost = 40
	requirements = list(100,90,80,70,60,50,50,50,50,50)
	high_population_requirement = 50
	flags = HIGHLANDER_RULESET
	antag_cap = list(1,1,2,3,4,5,5,5,5,5)
	property_weights = list("story_potential" = 2, "trust" = 2, "chaos" = 2, "extended" = -2, "valid" = 2)
	var/datum/team/nuclear/nuke_team

/datum/dynamic_ruleset/roundstart/nuclear/ready(forced = FALSE)
	required_candidates = antag_cap[indice_pop]
	. = ..()

/datum/dynamic_ruleset/roundstart/nuclear/pre_execute()
	// If ready() did its job, candidates should have 5 or more members in it
	var/operatives = antag_cap[indice_pop]
	mode.antags_rolled += operatives
	for(var/operatives_number = 1 to operatives)
		if(candidates.len <= 0)
			break
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.assigned_role = "Nuclear Operative"
		M.mind.special_role = "Nuclear Operative"
	return TRUE

/datum/dynamic_ruleset/roundstart/nuclear/execute()
	var/leader = TRUE
	for(var/datum/mind/M in assigned)
		if (leader)
			leader = FALSE
			var/datum/antagonist/nukeop/leader/new_op = M.add_antag_datum(antag_leader_datum)
			nuke_team = new_op.nuke_team
		else
			var/datum/antagonist/nukeop/new_op = new antag_datum()
			M.add_antag_datum(new_op)
	return TRUE

/datum/dynamic_ruleset/roundstart/nuclear/round_result()
	var result = nuke_team.get_result()
	switch(result)
		if(NUKE_RESULT_FLUKE)
			SSticker.mode_result = "loss - syndicate nuked - disk secured"
			SSticker.news_report = NUKE_SYNDICATE_BASE
		if(NUKE_RESULT_NUKE_WIN)
			SSticker.mode_result = "win - syndicate nuke"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_NOSURVIVORS)
			SSticker.mode_result = "halfwin - syndicate nuke - did not evacuate in time"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_WRONG_STATION)
			SSticker.mode_result = "halfwin - blew wrong station"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			SSticker.mode_result = "halfwin - blew wrong station - did not evacuate in time"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			SSticker.mode_result = "loss - evacuation - disk secured - syndi team dead"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_CREW_WIN)
			SSticker.mode_result = "loss - evacuation - disk secured"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_DISK_LOST)
			SSticker.mode_result = "halfwin - evacuation - disk not secured"
			SSticker.news_report = OPERATIVE_SKIRMISH
		if(NUKE_RESULT_DISK_STOLEN)
			SSticker.mode_result = "halfwin - detonation averted"
			SSticker.news_report = OPERATIVE_SKIRMISH
		else
			SSticker.mode_result = "halfwin - interrupted"
			SSticker.news_report = OPERATIVE_SKIRMISH

//////////////////////////////////////////////
//                                          //
//               REVS		                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/revs
	name = "Revolution"
	config_tag = "revolution"
	persistent = TRUE
	antag_flag = ROLE_REV_HEAD
	antag_flag_override = ROLE_REV
	antag_datum = /datum/antagonist/rev/head
	minimum_required_age = 14
	restricted_roles = list("AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 3
	weight = 2
	delay = 7 MINUTES
	cost = 35
	requirements = list(101,101,101,60,50,50,50,50,50,50)
	high_population_requirement = 50
	antag_cap = list(3,3,3,3,3,3,3,3,3,3)
	flags = HIGHLANDER_RULESET
	// I give up, just there should be enough heads with 35 players...
	minimum_players = 35
	property_weights = list("trust" = -2, "chaos" = 2, "extended" = -2, "valid" = 2, "conversion" = 1)
	var/datum/team/revolution/revolution
	var/finished = FALSE

/datum/dynamic_ruleset/roundstart/revs/pre_execute()
	var/max_candidates = antag_cap[indice_pop]
	mode.antags_rolled += max_candidates
	for(var/i = 1 to max_candidates)
		if(candidates.len <= 0)
			break
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.restricted_roles = restricted_roles
		M.mind.special_role = antag_flag
	return TRUE

/datum/dynamic_ruleset/roundstart/revs/execute()
	var/success = TRUE
	revolution = new()
	for(var/datum/mind/M in assigned)
		if(check_eligible(M))
			var/datum/antagonist/rev/head/new_head = new antag_datum()
			new_head.give_flash = TRUE
			new_head.give_hud = TRUE
			new_head.remove_clumsy = TRUE
			M.add_antag_datum(new_head,revolution)
		else
			assigned -= M
			log_game("DYNAMIC: [ruletype] [name] discarded [M.name] from head revolutionary due to ineligibility.")
		if(!revolution.members.len)
			success = FALSE
			log_game("DYNAMIC: [ruletype] [name] failed to get any eligible headrevs. Refunding [cost] threat.")
	if(success)
		revolution.update_objectives()
		revolution.update_heads()
		SSshuttle.registerHostileEnvironment(src)
		return TRUE
	return FALSE

/datum/dynamic_ruleset/roundstart/revs/clean_up()
	qdel(revolution)
	..()

/datum/dynamic_ruleset/roundstart/revs/rule_process()
	if(check_rev_victory())
		finished = REVOLUTION_VICTORY
		return RULESET_STOP_PROCESSING
	else if (check_heads_victory())
		finished = STATION_VICTORY
		SSshuttle.clearHostileEnvironment(src)
		priority_announce("It appears the mutiny has been quelled. Please return yourself and your incapacitated colleagues to work. \
			We have remotely blacklisted the head revolutionaries from your cloning software to prevent accidental cloning.", null, "attention", null, "Central Command Loyalty Monitoring Division")

		for(var/datum/mind/M in revolution.members)	// Remove antag datums and prevents podcloned or exiled headrevs restarting rebellions.
			if(M.has_antag_datum(/datum/antagonist/rev/head))
				var/datum/antagonist/rev/head/R = M.has_antag_datum(/datum/antagonist/rev/head)
				R.remove_revolutionary(FALSE, "gamemode")
				var/mob/living/carbon/C = M.current
				if(C.stat == DEAD)
					C.makeUncloneable()
			if(M.has_antag_datum(/datum/antagonist/rev))
				var/datum/antagonist/rev/R = M.has_antag_datum(/datum/antagonist/rev)
				R.remove_revolutionary(FALSE, "gamemode")
		return RULESET_STOP_PROCESSING

/// Checks for revhead loss conditions and other antag datums.
/datum/dynamic_ruleset/roundstart/revs/proc/check_eligible(var/datum/mind/M)
	var/turf/T = get_turf(M.current)
	if(!considered_afk(M) && considered_alive(M) && is_station_level(T.z) && !M.antag_datums?.len && !HAS_TRAIT(M, TRAIT_MINDSHIELD))
		return TRUE
	return FALSE

/datum/dynamic_ruleset/roundstart/revs/check_finished()
	if(finished == REVOLUTION_VICTORY)
		return TRUE
	else
		return ..()

/datum/dynamic_ruleset/roundstart/revs/proc/check_rev_victory()
	for(var/datum/objective/mutiny/objective in revolution.objectives)
		if(!(objective.check_completion()))
			return FALSE
	return TRUE

/datum/dynamic_ruleset/roundstart/revs/proc/check_heads_victory()
	for(var/datum/mind/rev_mind in revolution.head_revolutionaries())
		var/turf/T = get_turf(rev_mind.current)
		if(!considered_afk(rev_mind) && considered_alive(rev_mind) && is_station_level(T.z))
			if(ishuman(rev_mind.current) || ismonkey(rev_mind.current))
				return FALSE
	return TRUE

/datum/dynamic_ruleset/roundstart/revs/round_result()
	if(finished == REVOLUTION_VICTORY)
		SSticker.mode_result = "win - heads killed"
		SSticker.news_report = REVS_WIN
	else if(finished == STATION_VICTORY)
		SSticker.mode_result = "loss - rev heads killed"
		SSticker.news_report = REVS_LOSE

// Admin only rulesets. The threat requirement is 101 so it is not possible to roll them.

//////////////////////////////////////////////
//                                          //
//               EXTENDED                   //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/extended
	name = "Extended"
	config_tag = "extended"
	antag_flag = null
	antag_datum = null
	restricted_roles = list()
	required_candidates = 0
	weight = 3
	cost = 0
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	property_weights = list("extended" = 2)
	high_population_requirement = 101

/datum/dynamic_ruleset/roundstart/extended/pre_execute()
	message_admins("Starting a round of extended.")
	log_game("Starting a round of extended.")
	mode.spend_threat(mode.threat)
	return TRUE

//////////////////////////////////////////////
//                                          //
//               CLOCKCULT                  //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/clockcult
	name = "Clockcult"
	config_tag = "clockwork_cult"
	antag_flag = ROLE_SERVANT_OF_RATVAR
	antag_datum = /datum/antagonist/clockcult
	restricted_roles = list("AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 4
	weight = 3
	cost = 35
	requirements = list(101,101,101,80,70,60,50,50,50,50)
	high_population_requirement = 50
	flags = HIGHLANDER_RULESET
	antag_cap = list(2,3,3,4,4,4,4,4,4,4)
	property_weights = list("trust" = 2, "chaos" = 2, "extended" = -2, "conversion" = 1, "valid" = 2)
	var/ark_time

/datum/dynamic_ruleset/roundstart/clockcult/pre_execute()
	var/list/errorList = list()
	var/list/reebes = SSmapping.LoadGroup(errorList, "Reebe", "map_files/generic", "City_of_Cogs.dmm", default_traits = ZTRAITS_REEBE, silent = TRUE)
	if(errorList.len)
		message_admins("Reebe failed to load!")
		log_game("Reebe failed to load!")
		return FALSE
	for(var/datum/parsed_map/PM in reebes)
		PM.initTemplateBounds()

	var/starter_servants = antag_cap[indice_pop]
	var/number_players = mode.roundstart_pop_ready
	if(number_players > 30)
		number_players -= 30
		starter_servants += min(round(number_players / 10), 5)
	mode.antags_rolled += starter_servants
	GLOB.clockwork_vitality += 50 * starter_servants
	for (var/i in 1 to starter_servants)
		var/mob/servant = pick_n_take(candidates)
		assigned += servant.mind
		servant.mind.assigned_role = ROLE_SERVANT_OF_RATVAR
		servant.mind.special_role = ROLE_SERVANT_OF_RATVAR
	ark_time = 30 + round((number_players / 5))
	ark_time = min(ark_time, 35)
	return TRUE

/datum/dynamic_ruleset/roundstart/clockcult/execute()
	var/list/spread_out_spawns = GLOB.servant_spawns.Copy()
	for(var/datum/mind/servant in assigned)
		var/mob/S = servant.current
		if(!spread_out_spawns.len)
			spread_out_spawns = GLOB.servant_spawns.Copy()
		log_game("[key_name(servant)] was made an initial servant of Ratvar")
		var/turf/T = pick_n_take(spread_out_spawns)
		S.forceMove(T)
		greet_servant(S)
		equip_servant(S)
		add_servant_of_ratvar(S, TRUE)
	var/obj/structure/destructible/clockwork/massive/celestial_gateway/G = GLOB.ark_of_the_clockwork_justiciar //that's a mouthful
	G.final_countdown(ark_time)
	return TRUE

/datum/dynamic_ruleset/roundstart/clockcult/proc/greet_servant(mob/M) //Description of their role
	if(!M)
		return 0
	to_chat(M, "<span class='bold large_brass'>You are a servant of Ratvar, the Clockwork Justiciar!</span>")
	to_chat(M, "<span class='brass'>You have approximately <b>[ark_time]</b> minutes until the Ark activates.</span>")
	to_chat(M, "<span class='brass'>Unlock <b>Script</b> scripture by converting a new servant.</span>")
	to_chat(M, "<span class='brass'><b>Application</b> scripture will be unlocked halfway until the Ark's activation.</span>")
	M.playsound_local(get_turf(M), 'sound/ambience/antag/clockcultalr.ogg', 100, FALSE, pressure_affected = FALSE)
	return 1

/datum/dynamic_ruleset/roundstart/clockcult/proc/equip_servant(mob/living/M) //Grants a clockwork slab to the mob, with one of each component
	if(!M || !ishuman(M))
		return FALSE
	var/mob/living/carbon/human/L = M
	L.equipOutfit(/datum/outfit/servant_of_ratvar)
	var/obj/item/clockwork/slab/S = new
	var/slot = "At your feet"
	var/list/slots = list("In your left pocket" = SLOT_L_STORE, "In your right pocket" = SLOT_R_STORE, "In your backpack" = SLOT_IN_BACKPACK, "On your belt" = SLOT_BELT)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		slot = H.equip_in_one_of_slots(S, slots)
		if(slot == "In your backpack")
			slot = "In your [H.back.name]"
	if(slot == "At your feet")
		if(!S.forceMove(get_turf(L)))
			qdel(S)
	if(S && !QDELETED(S))
		to_chat(L, "<span class='bold large_brass'>There is a paper in your backpack! It'll tell you if anything's changed, as well as what to expect.</span>")
		to_chat(L, "<span class='alloy'>[slot] is a <b>clockwork slab</b>, a multipurpose tool used to construct machines and invoke ancient words of power. If this is your first time \
		as a servant, you can find a concise tutorial in the Recollection category of its interface.</span>")
		to_chat(L, "<span class='alloy italics'>If you want more information, you can read <a href=\"https://tgstation13.org/wiki/Clockwork_Cult\">the wiki page</a> to learn more.</span>")
		return TRUE
	return FALSE

/datum/dynamic_ruleset/roundstart/clockcult/round_result()
	if(GLOB.clockwork_gateway_activated)
		SSticker.news_report = CLOCK_SUMMON
		SSticker.mode_result = "win - servants completed their objective (summon ratvar)"
	else
		SSticker.news_report = CULT_FAILURE
		SSticker.mode_result = "loss - servants failed their objective (summon ratvar)"

//////////////////////////////////////////////
//                                          //
//               CLOWN OPS                  //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/nuclear/clown_ops
	name = "Clown Ops"
	config_tag = "clownops"
	antag_datum = /datum/antagonist/nukeop/clownop
	antag_leader_datum = /datum/antagonist/nukeop/leader/clownop
	weight = 1
	property_weights = list("trust" = 2, "chaos" = 2, "extended" = -2, "story_potential" = 2, "valid" = 2)


/datum/dynamic_ruleset/roundstart/nuclear/clown_ops/pre_execute()
	. = ..()
	if(.)
		for(var/obj/machinery/nuclearbomb/syndicate/S in GLOB.nuke_list)
			var/turf/T = get_turf(S)
			if(T)
				qdel(S)
				new /obj/machinery/nuclearbomb/syndicate/bananium(T)
		for(var/datum/mind/V in assigned)
			V.assigned_role = "Clown Operative"
			V.special_role = "Clown Operative"

//////////////////////////////////////////////
//                                          //
//               DEVIL                      //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/devil
	name = "Devil"
	config_tag = "devil"
	antag_flag = ROLE_DEVIL
	antag_datum = /datum/antagonist/devil
	restricted_roles = list("Lawyer", "Curator", "Chaplain", "Head of Security", "Captain", "AI")
	required_candidates = 1
	flags = MINOR_RULESET
	weight = 3
	cost = 0
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	high_population_requirement = 101
	antag_cap = list(1,1,1,2,2,2,3,3,3,4)
	property_weights = list("extended" = 1)

/datum/dynamic_ruleset/roundstart/devil/pre_execute()
	var/num_devils = antag_cap[indice_pop]
	mode.antags_rolled += num_devils
	for(var/j = 0, j < num_devils, j++)
		if (!candidates.len)
			break
		var/mob/devil = pick_n_take(candidates)
		assigned += devil.mind
		devil.mind.special_role = ROLE_DEVIL
		devil.mind.restricted_roles = restricted_roles

		log_game("[key_name(devil)] has been selected as a devil")
	return TRUE

/datum/dynamic_ruleset/roundstart/devil/execute()
	for(var/datum/mind/devil in assigned)
		add_devil(devil.current, ascendable = TRUE)
		add_devil_objectives(devil,2)
	return TRUE

/datum/dynamic_ruleset/roundstart/devil/proc/add_devil_objectives(datum/mind/devil_mind, quantity)
	var/list/validtypes = list(/datum/objective/devil/soulquantity, /datum/objective/devil/soulquality, /datum/objective/devil/sintouch, /datum/objective/devil/buy_target)
	var/datum/antagonist/devil/D = devil_mind.has_antag_datum(/datum/antagonist/devil)
	for(var/i = 1 to quantity)
		var/type = pick(validtypes)
		var/datum/objective/devil/objective = new type(null)
		objective.owner = devil_mind
		D.objectives += objective
		if(!istype(objective, /datum/objective/devil/buy_target))
			validtypes -= type
		else
			objective.find_target()

//////////////////////////////////////////////
//                                          //
//               MONKEY                     //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/monkey
	name = "Monkey"
	config_tag = "monkey"
	antag_flag = ROLE_MONKEY
	antag_datum = /datum/antagonist/monkey/leader
	restricted_roles = list("Cyborg", "AI")
	required_candidates = 1
	weight = 3
	cost = 0
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	high_population_requirement = 101
	property_weights = list("extended" = -2, "chaos" = 2, "conversion" = 1, "valid" = 2)
	var/players_per_carrier = 30
	var/monkeys_to_win = 1
	var/escaped_monkeys = 0
	var/datum/team/monkey/monkey_team

/datum/dynamic_ruleset/roundstart/monkey/pre_execute()
	var/carriers_to_make = max(round(mode.roundstart_pop_ready / players_per_carrier, 1), 1)
	mode.antags_rolled += carriers_to_make

	for(var/j = 0, j < carriers_to_make, j++)
		if (!candidates.len)
			break
		var/mob/carrier = pick_n_take(candidates)
		assigned += carrier.mind
		carrier.mind.special_role = "Monkey Leader"
		carrier.mind.restricted_roles = restricted_roles
		log_game("[key_name(carrier)] has been selected as a Jungle Fever carrier")
	return TRUE

/datum/dynamic_ruleset/roundstart/monkey/execute()
	for(var/datum/mind/carrier in assigned)
		var/datum/antagonist/monkey/M = add_monkey_leader(carrier)
		if(M)
			monkey_team = M.monkey_team
	return TRUE

/datum/dynamic_ruleset/roundstart/monkey/proc/check_monkey_victory()
	if(SSshuttle.emergency.mode != SHUTTLE_ENDGAME)
		return FALSE
	var/datum/disease/D = new /datum/disease/transformation/jungle_fever()
	for(var/mob/living/carbon/monkey/M in GLOB.alive_mob_list)
		if (M.HasDisease(D))
			if(M.onCentCom() || M.onSyndieBase())
				escaped_monkeys++
	if(escaped_monkeys >= monkeys_to_win)
		return TRUE
	else
		return FALSE

// This does not get called. Look into making it work.
/datum/dynamic_ruleset/roundstart/monkey/round_result()
	if(check_monkey_victory())
		SSticker.mode_result = "win - monkey win"
	else
		SSticker.mode_result = "loss - staff stopped the monkeys"

//////////////////////////////////////////////
//                                          //
//               METEOR                     //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/meteor
	name = "Meteor"
	config_tag = "meteor"
	persistent = TRUE
	required_candidates = 0
	weight = 3
	cost = 0
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	high_population_requirement = 101
	property_weights = list("extended" = -2, "chaos" = 2, "trust" = 2)
	var/meteordelay = 2000
	var/nometeors = 0
	var/rampupdelta = 5

/datum/dynamic_ruleset/roundstart/meteor/rule_process()
	if(nometeors || meteordelay > world.time - SSticker.round_start_time)
		return

	var/list/wavetype = GLOB.meteors_normal
	var/meteorminutes = (world.time - SSticker.round_start_time - meteordelay) / 10 / 60

	if (prob(meteorminutes))
		wavetype = GLOB.meteors_threatening

	if (prob(meteorminutes/2))
		wavetype = GLOB.meteors_catastrophic

	var/ramp_up_final = clamp(round(meteorminutes/rampupdelta), 1, 10)

	spawn_meteors(ramp_up_final, wavetype)

//////////////////////////////////////////////
//                                          //
//              BLOODSUCKERS                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/bloodsucker
	name = "Bloodsuckers"
	config_tag = "bloodsucker"
	antag_flag = ROLE_BLOODSUCKER
	antag_datum = ANTAG_DATUM_BLOODSUCKER
	minimum_required_age = 0
	protected_roles = list("Chaplain", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	restricted_roles = list("Cyborg", "AI")
	required_candidates = 1
	flags = MINOR_RULESET
	weight = 2
	cost = 15
	scaling_cost = 10
	property_weights = list("story_potential" = 1, "extended" = 1, "trust" = -2, "valid" = 1)
	requirements = list(70,65,60,55,50,50,50,50,50,50)
	high_population_requirement = 50
	antag_cap = list(1,1,1,1,1,2,2,2,2,2)

/datum/dynamic_ruleset/roundstart/bloodsucker/pre_execute()
	var/num_bloodsuckers = antag_cap[indice_pop] * (scaled_times + 1)
	for (var/i = 1 to num_bloodsuckers)
		var/mob/M = pick_n_take(candidates)
		assigned += M.mind
		M.mind.special_role = ROLE_BLOODSUCKER
		M.mind.restricted_roles = restricted_roles
	return TRUE

/datum/dynamic_ruleset/roundstart/bloodsucker/execute()
	mode.check_start_sunlight()
	for(var/datum/mind/M in assigned)
		if(mode.make_bloodsucker(M))
			mode.bloodsuckers += M
	return TRUE
