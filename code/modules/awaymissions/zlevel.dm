// How much "space" we give the edge of the map
GLOBAL_LIST_INIT(potentialRandomZlevels, generateMapList(filename = "[global.config.directory]/awaymissionconfig.txt"))
// So far only adds an additional trait to vr levels. But I'll probably use make VR separate from away missions in a near future.
GLOBAL_LIST_INIT(potentialRandomVRlevels, generateMapList(filename = "[global.config.directory]/vr_config.txt"))

/proc/createRandomZlevel()
	if(GLOB.awaydestinations.len)	//crude, but it saves another var!
		return

	if(GLOB.potentialRandomZlevels?.len)
		to_chat(world, "<span class='boldannounce'>Loading away mission...</span>")
		var/map = pick(GLOB.potentialRandomZlevels)
		var/list/traits = list(ZTRAIT_AWAY = TRUE)
		if(map in GLOB.potentialRandomVRlevels)
			traits[ZTRAIT_VIRTUAL_REALITY] = TRUE
		load_new_z_level(map, "Away Mission", traits)
		to_chat(world, "<span class='boldannounce'>Away mission loaded.</span>")

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
