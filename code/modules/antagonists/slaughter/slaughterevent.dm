/datum/round_event_control/slaughter
	name = "Spawn Slaughter Demon"
	typepath = /datum/round_event/ghost_role/slaughter
	weight = 1 //Very rare
	max_occurrences = 1
	earliest_start = 1 HOURS
	min_players = 20
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns a slaughter demon, to hunt by travelling through pools of blood."

/datum/round_event_control/slaughter/canSpawnEvent()
	weight = initial(src.weight)
	var/list/allowed_turf_typecache = typecacheof(/turf/open) - typecacheof(/turf/open/space)
	var/list/allowed_z_cache = list()
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		allowed_z_cache[num2text(z)] = TRUE
	for(var/obj/effect/decal/cleanable/C in world)
		if(!C.loc || QDELETED(C))
			continue
		if(!C.can_bloodcrawl_in())
			continue
		if(!SSpersistence.IsValidDebrisLocation(C.loc, allowed_turf_typecache, allowed_z_cache, C.type, FALSE))
			continue
		weight += 0.03
		CHECK_TICK
	return ..()

/datum/round_event/ghost_role/slaughter
	minimum_required = 1
	role_name = "slaughter demon"

/datum/round_event/ghost_role/slaughter/spawn_role()
	var/list/candidates = get_candidates(ROLE_ALIEN, null, ROLE_ALIEN)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS

	var/mob/dead/selected = pick_n_take(candidates)

	var/datum/mind/player_mind = new /datum/mind(selected.key)
	player_mind.active = 1

	var/list/spawn_locs = list()
	for(var/obj/effect/landmark/carpspawn/L in GLOB.landmarks_list)
		if(isturf(L.loc))
			spawn_locs += L.loc
	for(var/obj/effect/landmark/loneopspawn/L in GLOB.landmarks_list)
		if(isturf(L.loc))
			spawn_locs += L.loc

	if(!spawn_locs)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	var/obj/effect/dummy/phased_mob/slaughter/holder = new /obj/effect/dummy/phased_mob/slaughter((pick(spawn_locs)))
	var/mob/living/simple_animal/slaughter/S = new (holder)
	S.holder = holder
	player_mind.transfer_to(S)
	player_mind.assigned_role = "Slaughter Demon"
	player_mind.special_role = "Slaughter Demon"
	player_mind.add_antag_datum(/datum/antagonist/slaughter)
	to_chat(S, S.playstyle_string)
	to_chat(S, "<B>You are currently not currently in the same plane of existence as the station. Blood Crawl near a blood pool to manifest.</B>")
	SEND_SOUND(S, 'sound/magic/demon_dies.ogg')
	message_admins("[ADMIN_LOOKUPFLW(S)] has been made into a slaughter demon by an event.")
	log_game("[key_name(S)] was spawned as a slaughter demon by an event.")
	spawned_mobs += S
	return SUCCESSFUL_SPAWN
