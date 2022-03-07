/atom/movable/landmark/start
	name = "start"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/atom/movable/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/atom/movable/landmark/start/New()
	GLOB.start_landmarks_list += src
	..()
	if(name != "start")
		tag = "start*[name]"

/atom/movable/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	return ..()

// START LANDMARKS FOLLOW. Don't change the names unless
// you are refactoring shitty landmark code.
/atom/movable/landmark/start/wizard
	name = "wizard"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"

/atom/movable/landmark/start/wizard/Initialize()
	..()
	GLOB.wizardstart += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/start/nukeop
	name = "nukeop"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/atom/movable/landmark/start/nukeop/Initialize()
	..()
	GLOB.nukeop_start += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/start/nukeop_leader
	name = "nukeop leader"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_leader_spawn"

/atom/movable/landmark/start/nukeop_leader/Initialize()
	..()
	GLOB.nukeop_leader_start += loc
	return INITIALIZE_HINT_QDEL

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/atom/movable/landmark/start/new_player)

/atom/movable/landmark/start/new_player
	name = "New Player"

/atom/movable/landmark/start/new_player/Initialize()
	..()
	GLOB.newplayer_start += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/start/nuclear_equipment
	name = "bomb or clown beacon spawner"
	var/nukie_path = /obj/item/sbeacondrop/bomb
	var/clown_path = /obj/item/sbeacondrop/clownbomb

/atom/movable/landmark/start/nuclear_equipment/after_round_start()
	var/npath = nukie_path
	if(istype(SSticker.mode, /datum/game_mode/nuclear/clown_ops))
		npath = clown_path
	else if(istype(SSticker.mode, /datum/game_mode/dynamic))
		var/datum/game_mode/dynamic/D = SSticker.mode
		if(locate(/datum/dynamic_ruleset/roundstart/nuclear/clown_ops) in D.current_rules)
			npath = clown_path
	new npath(loc)
	return ..()

/atom/movable/landmark/start/nuclear_equipment/minibomb
	name = "minibomb or bombanana spawner"
	nukie_path = /obj/item/storage/box/minibombs
	clown_path = /obj/item/storage/box/bombananas
