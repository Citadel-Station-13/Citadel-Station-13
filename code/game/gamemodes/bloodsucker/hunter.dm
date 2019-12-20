

/*
// Called from game mode pre_setup()
/datum/game_mode/proc/assign_monster_hunters(monster_count = 4, guaranteed_hunters = FALSE, list/datum/mind/exclude_from_hunter)

	// Not all game modes GUARANTEE a hunter
	if (rand(0,2) == 0) // 50% of the time, we get fewer or NO Hunters
		if (!guaranteed_hunters)
			return
		else
			monster_count /= 2

	var/list/no_hunter_jobs = list("AI","Cyborg")

	// Set Restricted Jobs
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		no_hunter_jobs += list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")

	if(CONFIG_GET(flag/protect_assistant_from_antagonist))
		no_hunter_jobs += "Assistant"

	// Find Valid Hunters
	var/list/datum/mind/hunter_candidates = get_players_for_role(ROLE_MONSTERHUNTER)

	// Assign Hunters (as many as vamps, plus one)
	for(var/i = 1, i < monster_count, i++) // Start at 1 so we skip Hunters if there's only one sucker.
		if (!hunter_candidates.len)
			break
		// Assign Hunter
		var/datum/mind/hunter = pick(hunter_candidates)
		hunter_candidates.Remove(hunter) // Remove Either Way
		// Already Antag? Skip
		if (islist(exclude_from_hunter) && (locate(hunter) in exclude_from_hunter)) //if (islist(hunter.antag_datums) && hunter.antag_datums.len)
			i --
			continue
		// NOTE:
		vamphunters += hunter
		hunter.restricted_roles = no_hunter_jobs
		log_game("[hunter.key] (ckey) has been selected as a Hunter.")

// Called from game mode post_setup()
/datum/game_mode/proc/finalize_monster_hunters(monster_count = 4)
	var/amEvil = TRUE // First hunter is always an evil boi
	for(var/datum/mind/hunter in vamphunters)
		var/datum/antagonist/vamphunter/A = new (hunter)
		A.bad_dude = amEvil
		hunter.add_antag_datum(A)
		amEvil = FALSE  // Every other hunter is just a boring greytider
*/
