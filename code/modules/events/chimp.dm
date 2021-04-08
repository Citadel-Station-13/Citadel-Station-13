/datum/round_event_control/chimp
	name = "Random Chimp Event"
	typepath = /datum/round_event/ghost_role/chimp
	max_occurrences = 1
	earliest_start = 35 MINUTES
	gamemode_blacklist = list("dynamic")
	min_players = 25
	weight = 8

/datum/round_event/ghost_role/chimp
	role_name = "monkey"
	minimum_required = 1
	var/spawn_loc
	var/success_spawn

/datum/round_event/ghost_role/chimp/kill()
	if(!success_spawn && control)	// just to be sure, if we kill this event without spawning, lets reset the occurrences
		control.occurrences--
	return ..()

/datum/round_event/ghost_role/chimp/spawn_role()
	// get that candidate!
	// perhaps in the future lets add more than just one monkey
	var/list/candidates = get_candidates(ROLE_MONKEY, null, ROLE_MONKEY)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS
	var/mob/dead/selected = pick(candidates)

	// mind setup
	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = TRUE

	// spawn location
	var/list/spawn_locs = list()

	for(var/X in GLOB.xeno_spawn)
		var/turf/T = X
		spawn_locs += T


	// lets pick a vent
	/* for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in GLOB.machines)
		var/turf/T = get_turf(temp_vent)
		var/area/A = T.loc
		if(T && is_station_level(T.z) && !temp_vent.welded && !A.safe)
			spawn_locs += temp_vent
	*/

	if(!spawn_locs.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	// time to spawn our monkee
	var/mob/living/carbon/monkey/S = new ((pick(spawn_locs)))
	player_mind.transfer_to(S)
	player_mind.assigned_role = "Monkey Leader"
	player_mind.special_role = "Monkey Leader"
	player_mind.add_antag_datum(/datum/antagonist/monkey/leader)
	// add here a way to make them start vent_crawled into the pump

	var/obj/item/lamp = new /obj/item/flashlight/lamp/bananalamp(S.loc)
	S.put_in_active_hand(lamp)

	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a Monkey by an event.")
	log_game("[key_name(S)] was spawned as a Monkey by an event.")
	spawned_mobs += S

	success_spawn = TRUE
	return SUCCESSFUL_SPAWN
