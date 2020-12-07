
//////////////////////////////////////////////
//                                          //
//           SYNDICATE TRAITORS             //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/minor/traitor
	name = "Traitors"
	config_tag = "traitor" // these having identical config tags to the roundstart modes is 100% intentional, so that config edits are simpler
	persistent = TRUE
	antag_flag = ROLE_TRAITOR
	antag_datum = /datum/antagonist/traitor/
	minimum_required_age = 0
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster", "Cyborg")
	restricted_roles = list("Cyborg", "AI")
	required_candidates = 1
	weight = 5
	flags = TRAITOR_RULESET | ALWAYS_MAX_WEIGHT_RULESET
	cost = 10	// Avoid raising traitor threat above 10, as it is the default low cost ruleset.
	requirements = list(50,50,50,50,50,50,50,50,50,50)
	high_population_requirement = 40
	property_weights = list("story_potential" = 2, "trust" = -1, "extended" = 1, "valid" = 1)

/datum/dynamic_ruleset/minor/traitor/execute()
	var/mob/M = pick_n_take(candidates)
	assigned += M
	var/datum/antagonist/traitor/newTraitor = new
	M.mind.add_antag_datum(newTraitor)
	log_admin("[M] was made into a traitor by dynamic.")
	message_admins("[M] was made into a traitor by dynamic.")
	return TRUE

//////////////////////////////////////////
//                                      //
//           BLOOD BROTHERS             //
//                                      //
//////////////////////////////////////////

/datum/dynamic_ruleset/minor/traitorbro
	name = "Blood Brothers"
	config_tag = "traitorbro"
	antag_flag = ROLE_BROTHER
	antag_datum = /datum/antagonist/brother
	restricted_roles = list("AI", "Cyborg")
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 2
	weight = 4
	cost = 10
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	high_population_requirement = 101
	antag_cap = list(2,2,2,2,2,2,2,2,2,2)	// Can pick 3 per team, but rare enough it doesn't matter.
	property_weights = list("story_potential" = 1, "trust" = -1, "extended" = 1, "valid" = 1)
	var/list/datum/team/brother_team/pre_brother_teams = list()
	var/const/min_team_size = 2

/datum/dynamic_ruleset/minor/traitorbro/execute()
	if(candidates.len < min_team_size || candidates.len < required_candidates)
		return FALSE
	var/datum/team/brother_team/team = new
	var/team_size = prob(10) ? min(3, candidates.len) : 2
	for(var/k = 1 to team_size)
		var/mob/bro = pick_n_take(candidates)
		assigned += bro.mind
		team.add_member(bro.mind)
		bro.mind.special_role = "brother"
		bro.mind.restricted_roles = restricted_roles
	team.pick_meeting_area()
	team.forge_brother_objectives()
	for(var/datum/mind/M in team.members)
		M.add_antag_datum(/datum/antagonist/brother, team)
	team.update_name()
	mode.brother_teams += team

//////////////////////////////////////////////
//                                          //
//               CHANGELINGS                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/minor/changeling
	name = "Changelings"
	config_tag = "changeling"
	antag_flag = ROLE_CHANGELING
	antag_datum = /datum/antagonist/changeling
	restricted_roles = list("AI", "Cyborg")
	protected_roles = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	required_candidates = 1
	weight = 3
	cost = 15
	scaling_cost = 15
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	property_weights = list("trust" = -2, "valid" = 2)
	high_population_requirement = 10
	antag_cap = list(1,1,1,1,1,2,2,2,2,3)
	var/team_mode_probability = 30

/datum/dynamic_ruleset/minor/changeling/execute()
	var/mob/M = pick_n_take(candidates)
	assigned += M.mind
	M.mind.restricted_roles = restricted_roles
	M.mind.special_role = ROLE_CHANGELING
	var/datum/antagonist/changeling/new_antag = new antag_datum()
	M.mind.add_antag_datum(new_antag)
	return TRUE

//////////////////////////////////////////////
//                                          //
//              ELDRITCH CULT               //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/minor/heretics
	name = "Heretic"
	antag_flag = "heretic"
	antag_datum = /datum/antagonist/heretic
	protected_roles = list("Prisoner","Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	restricted_roles = list("AI", "Cyborg")
	required_candidates = 1
	weight = 3
	cost = 25
	scaling_cost = 15
	requirements = list(60,60,60,55,50,50,50,50,50,50)
	property_weights = list("story_potential" = 1, "trust" = -1, "chaos" = 2, "extended" = -1, "valid" = 2)
	antag_cap = list(1,1,1,1,2,2,2,2,3,3)
	high_population_requirement = 50


/datum/dynamic_ruleset/minor/heretics/pre_execute()
	var/mob/picked_candidate = pick_n_take(candidates)
	assigned += picked_candidate.mind
	picked_candidate.mind.restricted_roles = restricted_roles
	picked_candidate.mind.special_role = ROLE_HERETIC
	var/datum/antagonist/heretic/new_antag = new antag_datum()
	picked_candidate.mind.add_antag_datum(new_antag)
	return TRUE

//////////////////////////////////////////////
//                                          //
//               DEVIL                      //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/minor/devil
	name = "Devil"
	config_tag = "devil"
	antag_flag = ROLE_DEVIL
	antag_datum = /datum/antagonist/devil
	restricted_roles = list("Lawyer", "Curator", "Chaplain", "Head of Security", "Captain", "AI")
	required_candidates = 1
	weight = 3
	cost = 0
	requirements = list(101,101,101,101,101,101,101,101,101,101)
	high_population_requirement = 101
	antag_cap = list(1,1,1,2,2,2,3,3,3,4)
	property_weights = list("extended" = 1)

/datum/dynamic_ruleset/minor/devil/pre_execute()
	var/mob/devil = pick_n_take(candidates)
	assigned += devil.mind
	devil.mind.special_role = ROLE_DEVIL
	devil.mind.restricted_roles = restricted_roles

	log_game("[key_name(devil)] has been selected as a devil")
	add_devil(devil, ascendable = TRUE)
	add_devil_objectives(devil.mind,2)
	return TRUE

/datum/dynamic_ruleset/minor/devil/proc/add_devil_objectives(datum/mind/devil_mind, quantity)
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
//              BLOODSUCKERS                //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/minor/bloodsucker
	name = "Bloodsuckers"
	config_tag = "bloodsucker"
	antag_flag = ROLE_BLOODSUCKER
	antag_datum = ANTAG_DATUM_BLOODSUCKER
	minimum_required_age = 0
	protected_roles = list("Chaplain", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Head of Personnel", "Chief Engineer", "Chief Medical Officer", "Research Director", "Quartermaster")
	restricted_roles = list("Cyborg", "AI")
	required_candidates = 1
	weight = 2
	cost = 15
	scaling_cost = 10
	property_weights = list("story_potential" = 1, "extended" = 1, "trust" = -2, "valid" = 1)
	requirements = list(70,65,60,55,50,50,50,50,50,50)
	high_population_requirement = 50

/datum/dynamic_ruleset/minor/bloodsucker/execute()
	var/mob/M = pick_n_take(candidates)
	assigned += M.mind
	M.mind.special_role = ROLE_BLOODSUCKER
	M.mind.restricted_roles = restricted_roles
	mode.check_start_sunlight()
	if(mode.make_bloodsucker(M.mind))
		mode.bloodsuckers += M.mind
	return TRUE
