
/proc/createRandomZlevel(name = AWAY_MISSION_NAME, list/traits = list(ZTRAIT_AWAY = TRUE), list/potential_levels = potential_away_levels)
	if(GLOB.random_zlevels_generated[name] || !length(potential_levels))
		return

	to_chat(world, "<span class='boldannounce'>Loading [name]...</span>")
	var/map = pick(potential_levels)
	load_new_z_level(map, name, traits)
	to_chat(world, "<span class='boldannounce'>[name] loaded.</span>")
	random_zlevels_generated[name] = TRUE

/proc/reset_gateway_spawns(reset = FALSE)
	for(var/obj/machinery/gateway/G in world)
		if(reset)
			G.randomspawns = GLOB.awaydestinations
		else
			G.randomspawns.Add(GLOB.awaydestinations)

/obj/effect/landmark/awaystart
	name = "away mission spawn"
	desc = "Randomly picked away mission spawn points."

/obj/effect/landmark/awaystart/New()
	GLOB.awaydestinations += src
	..()

/obj/effect/landmark/awaystart/Destroy()
	GLOB.awaydestinations -= src
	return ..()

/proc/generateMapList(filename)
	. = list()
	var/list/Lines = world.file2list(filename)

	if(!Lines.len)
		return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (t[1] == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))

		else
			name = lowertext(t)

		if (!name)
			continue

		. += t
