// shamelessly inspired by the ninja event

/datum/round_event_control/chimp
	name = "Random Chimp Event"
	typepath = /datum/round_event/ghost_role/chimp
	max_occurrences = 1
	earliest_start = 40 MINUTES
	gamemode_blacklist = list("dynamic")
	min_players = 25

/datum/round_event/ghost_role/chimp
	role_name = "monkey"
	minimum_required = 1
	var/spawn_loc

/datum/round_event/ghost_role/chimp/kill()
	if(!success_spawn && control)
		control.occurrences--
	return ..()

/datum/round_event/ghost_role/chimp/spawn_role()
	//selecting a spawn_loc
	if(!spawn_loc)
		var/list/spawn_locs = list()
		for(var/obj/effect/landmark/xeno_spawn/L in GLOB.landmarks_list)
			if(isturf(L.loc))
				spawn_locs += L.loc
		if(!spawn_locs.len)
			return kill()
		spawn_loc = pick(spawn_locs)
	if(!spawn_loc)
		return MAP_ERROR

	//selecting a candidate player
	var/list/candidates = get_candidates(ROLE_MONKEY, null, ROLE_MONKEY)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected_candidate = pick_n_take(candidates)
	var/key = selected_candidate.key

	//Prepare monkey player mind
	var/datum/mind/Mind = new /datum/mind(key)
	Mind.assigned_role = ROLE_MONKEY
	Mind.special_role = ROLE_MONKEY
	Mind.active = 1

	//spawn the monkey and assign the candidate
	var/mob/living/carbon/monkey = new(spawn_loc)
	Mind.transfer_to(monkey)
	var/datum/antagonist/monkey/monkeydatum = new
	Mind.add_antag_datum(monkeydatum)

	if(monkey.mind != Mind)			//something has gone wrong!
		stack_trace("Monkey created with incorrect mind")

	spawned_mobs += monkey
	message_admins("[ADMIN_LOOKUPFLW(monkey)] has been made into a monkey by an event.")
	log_game("[key_name(monkey)] was spawned as a monkey by an event.")
	success_spawn = TRUE
	return SUCCESSFUL_SPAWN
