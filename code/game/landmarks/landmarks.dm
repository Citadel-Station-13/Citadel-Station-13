/atom/movable/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT

INITIALIZE_IMMEDIATE(/atom/movable/landmark)

/atom/movable/landmark/Initialize()
	. = ..()
	GLOB.landmarks_list += src

/atom/movable/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/**
 * Called when the round is finished setting up directly from SSticker
 */
/atom/movable/landmark/proc/OnRoundstart()
	return

// carp.
/atom/movable/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

// lone op (optional)
/atom/movable/landmark/loneopspawn
	name = "loneop+ninjaspawn"
	icon_state = "snukeop_spawn"

// observer-start.
/atom/movable/landmark/observer_start
	name = "Observer-Start"
	icon_state = "observer_start"

// xenos.
/atom/movable/landmark/xeno_spawn
	name = "xeno_spawn"
	icon_state = "xeno_spawn"

/atom/movable/landmark/xeno_spawn/Initialize(mapload)
	..()
	GLOB.xeno_spawn += loc
	return INITIALIZE_HINT_QDEL

// blobs.
/atom/movable/landmark/blobstart
	name = "blobstart"
	icon_state = "blob_start"

/atom/movable/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/secequipment
	name = "secequipment"
	icon_state = "secequipment"

/atom/movable/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/atom/movable/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/atom/movable/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/holding_facility
	name = "Holding Facility"
	icon_state = "holding_facility"

/atom/movable/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/thunderdome/observe
	name = "tdomeobserve"
	icon_state = "tdome_observer"

/atom/movable/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/thunderdome/one
	name = "tdome1"
	icon_state = "tdome_t1"

/atom/movable/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1	+= loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/thunderdome/two
	name = "tdome2"
	icon_state = "tdome_t2"

/atom/movable/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	return INITIALIZE_HINT_QDEL

/atom/movable/landmark/thunderdome/admin
	name = "tdomeadmin"
	icon_state = "tdome_admin"

/atom/movable/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	return INITIALIZE_HINT_QDEL

//Servant spawn locations
/atom/movable/landmark/servant_of_ratvar
	name = "servant of ratvar spawn"
	icon_state = "clockwork_orange"
	layer = MOB_LAYER

/atom/movable/landmark/servant_of_ratvar/Initialize(mapload)
	..()
	GLOB.servant_spawns += loc
	return INITIALIZE_HINT_QDEL

//City of Cogs entrances
/atom/movable/landmark/city_of_cogs
	name = "city of cogs entrance"
	icon_state = "city_of_cogs"

/atom/movable/landmark/city_of_cogs/Initialize(mapload)
	..()
	GLOB.city_of_cogs_spawns += loc
	return INITIALIZE_HINT_QDEL

//generic event spawns
/atom/movable/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "generic_event"
	layer = HIGH_LANDMARK_LAYER


/atom/movable/landmark/event_spawn/New()
	..()
	GLOB.generic_event_spawns += src

/atom/movable/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/atom/movable/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/atom/movable/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/atom/movable/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

//------Station Rooms Landmarks------------//
/atom/movable/landmark/stationroom
	var/list/templates = list()
	layer = BULLET_HOLE_LAYER
	plane = ABOVE_WALL_PLANE

/atom/movable/landmark/stationroom/New()
	..()
	GLOB.stationroom_landmarks += src

/atom/movable/landmark/stationroom/Destroy()
	if(src in GLOB.stationroom_landmarks)
		GLOB.stationroom_landmarks -= src
	return ..()

/atom/movable/landmark/stationroom/proc/load(template_name)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(!template_name)
		for(var/t in templates)
			if(!SSmapping.station_room_templates[t])
				log_world("Station room spawner placed at ([T.x], [T.y], [T.z]) has invalid ruin name of \"[t]\" in its list")
				templates -= t
		template_name = pickweight(templates, 0)
	if(!template_name)
		GLOB.stationroom_landmarks -= src
		qdel(src)
		return FALSE
	var/datum/map_template/template = SSmapping.station_room_templates[template_name]
	if(!template)
		return FALSE
	testing("Room \"[template_name]\" placed at ([T.x], [T.y], [T.z])")
	template.load(T, centered = FALSE, orientation = dir, rotate_placement_to_orientation = TRUE)
	template.loaded++
	GLOB.stationroom_landmarks -= src
	qdel(src)
	return TRUE

// The landmark for the Engine on Box

/atom/movable/landmark/stationroom/box/engine
	templates = list("Engine SM" = 3, "Engine Singulo" = 3, "Engine Tesla" = 3)
	icon = 'icons/rooms/box/engine.dmi'

/atom/movable/landmark/stationroom/box/engine/New()
	. = ..()
	templates = CONFIG_GET(keyed_list/box_random_engine)

// Landmark for the mining station
/atom/movable/landmark/stationroom/lavaland/station
	templates = list("Public Mining Base" = 3)
	icon = 'icons/rooms/Lavaland/Mining.dmi'

// handled in portals.dm, id connected to one-way portal
/atom/movable/landmark/portal_exit
	name = "portal exit"
	icon_state = "portal_exit"
	var/id
