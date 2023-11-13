/datum/round_event_control/cat_surgeon
	name = "Cat Surgeon"
	typepath = /datum/round_event/cat_surgeon
	max_occurrences = 1
	weight = 5
	category = EVENT_CATEGORY_ENTITIES
	description = "Spawns a crazy surgeon ready to perverse things with the crew."

/datum/round_event/cat_surgeon/announce(fake)
	priority_announce("One of our... ahem... 'special' cases has escaped. As it happens their last known location before their tracker went dead is your station so keep an eye out for them. On an unrelated note, has anyone seen our cats?",
	sender_override = "Nanotrasen Psych Ward", has_important_message = TRUE)

/datum/round_event/cat_surgeon/start()
	var/list/spawn_locs = list()
	var/list/unsafe_spawn_locs = list()
	for(var/X in GLOB.xeno_spawn)
		if(!isfloorturf(X))
			unsafe_spawn_locs += X
			continue
		var/turf/open/floor/F = X
		var/datum/gas_mixture/A = F.air
		var/oxy_moles = A.get_moles(GAS_O2)
		if((oxy_moles < 16 || oxy_moles > 50) || A.get_moles(GAS_PLASMA) || A.get_moles(GAS_CO2) >= 10)
			unsafe_spawn_locs += F
			continue
		if((A.return_temperature() <= 270) || (A.return_temperature() >= 360))
			unsafe_spawn_locs += F
			continue
		var/pressure = A.return_pressure()
		if((pressure <= 20) || (pressure >= 550))
			unsafe_spawn_locs += F
			continue
		spawn_locs += F

	if(!spawn_locs.len)
		spawn_locs += unsafe_spawn_locs

	if(!spawn_locs.len)
		message_admins("No valid spawn locations found, aborting...")
		return MAP_ERROR

	var/turf/T = get_turf(pick(spawn_locs))
	var/mob/living/simple_animal/hostile/cat_butcherer/S = new(T)
	playsound(S, 'sound/misc/catscream.ogg', 75, 1, -1)
	message_admins("A cat surgeon has been spawned at [COORD(T)][ADMIN_JMP(T)]")
	log_game("A cat surgeon has been spawned at [COORD(T)]")
	return SUCCESSFUL_SPAWN
