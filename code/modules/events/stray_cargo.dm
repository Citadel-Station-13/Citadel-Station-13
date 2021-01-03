///Spawns a cargo pod containing a random cargo supply pack on a random area of the station
/datum/round_event_control/stray_cargo
	name = "Stray Cargo Pod"
	typepath = /datum/round_event/stray_cargo
	weight = 5
	max_occurrences = 4
	earliest_start = 10 MINUTES

///Spawns a cargo pod containing a random cargo supply pack on a random area of the station
/datum/round_event/stray_cargo
	var/area/impact_area ///Randomly picked area
	var/list/possible_pack_types = list() ///List of possible supply packs dropped in the pod, if empty picks from the cargo list
	var/static/list/stray_spawnable_supply_packs = list() ///List of default spawnable supply packs, filtered from the cargo list

/datum/round_event/stray_cargo/announce(fake)
	priority_announce("Stray cargo pod detected on long-range scanners. Expected location of impact: [impact_area.name].", "Collision Alert")

/**
* Tries to find a valid area, throws an error if none are found
* Also randomizes the start timer
*/
/datum/round_event/stray_cargo/setup()
	startWhen = rand(20, 40)
	impact_area = find_event_area()
	if(!impact_area)
		CRASH("No valid areas for cargo pod found.")
	var/list/turf_test = get_area_turfs(impact_area)
	if(!turf_test.len)
		CRASH("Stray Cargo Pod : No valid turfs found for [impact_area] - [impact_area.type]")

	if(!stray_spawnable_supply_packs.len)
		stray_spawnable_supply_packs = SSshuttle.supply_packs.Copy()
		for(var/pack in stray_spawnable_supply_packs)
			var/datum/supply_pack/pack_type = pack
			if(initial(pack_type.special))
				stray_spawnable_supply_packs -= pack

///Spawns a random supply pack, puts it in a pod, and spawns it on a random tile of the selected area
/datum/round_event/stray_cargo/start()
	var/list/turf/valid_turfs = get_area_turfs(impact_area)
	//Only target non-dense turfs to prevent wall-embedded pods
	for(var/i in valid_turfs)
		var/turf/T = i
		if(T.density)
			valid_turfs -= T
	var/turf/LZ = pick(valid_turfs)
	var/pack_type
	if(possible_pack_types.len)
		pack_type = pick(possible_pack_types)
	else
		pack_type = pick(stray_spawnable_supply_packs)
	var/datum/supply_pack/SP = new pack_type
	var/obj/structure/closet/crate/crate = SP.generate(null)
	crate.locked = FALSE //Unlock secure crates
	crate.update_icon()
	var/obj/structure/closet/supplypod/pod = make_pod()
	crate.forceMove(pod)
	new /obj/effect/pod_landingzone(LZ, pod)

///Handles the creation of the pod, in case it needs to be modified beforehand
/datum/round_event/stray_cargo/proc/make_pod()
	var/area/pod_storage_area = locate(/area/centcom/supplypod/podStorage) in GLOB.sortedAreas
	var/obj/structure/closet/supplypod/S = new(pick(get_area_turfs(pod_storage_area))) //Lets not runtime
	return S

///Picks an area that wouldn't risk critical damage if hit by a pod explosion
/datum/round_event/stray_cargo/proc/find_event_area()
	var/static/list/allowed_areas
	if(!allowed_areas)
		///Places that shouldn't explode
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/turret_protected/ai,
		/area/ai_monitored/turret_protected/ai_upload,
		/area/engine,
		/area/shuttle)
		)

		///Subtypes from the above that actually should explode.
		var/list/unsafe_area_subtypes = typecacheof(list(/area/engine/break_room))
		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes
	var/list/possible_areas = typecache_filter_list(GLOB.sortedAreas,allowed_areas)
	if (length(possible_areas))
		return pick(possible_areas)

///A rare variant that drops a crate containing syndicate uplink items
/datum/round_event_control/stray_cargo/syndicate
	name = "Stray Syndicate Cargo Pod"
	typepath = /datum/round_event/stray_cargo/syndicate
	weight = 0
	max_occurrences = 0
	earliest_start = 30 MINUTES

/datum/round_event/stray_cargo/syndicate
	possible_pack_types = list(/datum/supply_pack/misc/syndicate)

///Apply the syndicate pod skin
/datum/round_event/stray_cargo/syndicate/make_pod()
	var/area/pod_storage_area = locate(/area/centcom/supplypod/podStorage) in GLOB.sortedAreas
	var/obj/structure/closet/supplypod/S = new(pick(get_area_turfs(pod_storage_area))) //Lets not runtime
	S.setStyle(STYLE_SYNDICATE)
	return S
