/datum/round_event_control/spontaneous_guardian_spirit
	name = "Spontaneous Guardian Spirit"
	typepath = /datum/round_event/ghost_role/spontaneous_guardian_spirit
	weight = 2
	max_occurrences = 8
	earliest_start = 10 MINUTES
	min_players = 5

/datum/round_event/ghost_role/spontaneous_guardian_spirit
	role_name = "guardian spirit"

/datum/round_event/ghost_role/spontaneous_guardian_spirit/spawn_role()
	var/list/candidates = get_candidates(ROLE_PAI, null, ROLE_ALIEN)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/observer/selected = pick_n_take(candidates)

	var/mob/camera/guardian/spirit = new /mob/camera/guardian(SSmapping.get_station_center())
	selected.transfer_ckey(spirit, FALSE)
	message_admins("[ADMIN_LOOKUPFLW(spirit)] has been made into a guardian spirit by an event.")
	log_game("[key_name(spirit)] was spawned as a guardian spirit by an event.")
	spawned_mobs += spirit
	control.weight *= 2 //they attract each other, after all
	return SUCCESSFUL_SPAWN
