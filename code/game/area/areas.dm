// Areas.dm


/area
	level = null
	name = "Space"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREA_LAYER
	plane = BLACKNESS_PLANE //Keeping this on the default plane, GAME_PLANE, will make area overlays fail to render on FLOOR_PLANE.
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING

	/// Set in New(); preserves the name set by the map maker, even if renamed by the Blueprints.
	var/map_name

	/// If it's valid territory for gangs/cults to summon
	var/valid_territory = TRUE
	/// if blobs can spawn there and if it counts towards their score.
	var/blob_allowed = TRUE
	/// whether servants can warp into this area from Reebe
	var/clockwork_warp_allowed = TRUE
	/// Message to display when the clockwork warp fails
	var/clockwork_warp_fail = "The structure there is too dense for warping to pierce. (This is normal in high-security areas.)"

	/// If mining tunnel generation is allowed in this area
	var/tunnel_allowed = FALSE
	/// If flora are allowed to spawn in this area randomly through tunnel generation
	var/flora_allowed = FALSE
	/// if mobs can be spawned by natural random generation
	var/mob_spawn_allowed = FALSE
	/// If megafauna can be spawned by natural random generation
	var/megafauna_spawn_allowed = FALSE

	var/fire = null
	var/atmos = TRUE
	var/atmosalm = FALSE
	var/poweralm = TRUE
	var/lightswitch = TRUE

	var/totalbeauty = 0 //All beauty in this area combined, only includes indoor area.
	var/beauty = 0 // Beauty average per open turf in the area
	var/beauty_threshold = 150 //If a room is too big it doesn't have beauty.

	var/requires_power = TRUE
	/// This gets overridden to 1 for space in area/Initialize().
	var/always_unpowered = FALSE

	/// For space, the asteroid, lavaland, etc. Used with blueprints to determine if we are adding a new area (vs editing a station room)
	var/outdoors = FALSE

	/// Size of the area in open turfs, only calculated for indoors areas.
	var/areasize = 0

	var/power_equip = TRUE
	var/power_light = TRUE
	var/power_environ = TRUE
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0
	var/static_equip
	var/static_light = 0
	var/static_environ

	var/has_gravity = 0
	/// Are you forbidden from teleporting to the area? (centcom, mobs, wizard, hand teleporter)
	var/noteleport = FALSE
	/// Hides area from player Teleport function.
	var/hidden = FALSE
	/// Is the area teleport-safe: no space / radiation / aggresive mobs / other dangers
	var/safe = FALSE
	/// If false, loading multiple maps with this area type will create multiple instances.
	var/unique = TRUE

	var/no_air = null

	var/parallax_movedir = 0

	var/list/ambientsounds = GENERIC
	flags_1 = CAN_BE_DIRTY_1

	var/list/firedoors
	var/list/cameras
	var/list/firealarms
	var/firedoors_last_closed_on = 0
	var/xenobiology_compatible = FALSE //Can the Xenobio management console transverse this area by default?
	var/list/canSmoothWithAreas //typecache to limit the areas that atoms in this area can smooth with


	/// Color on minimaps, if it's null (which is default) it makes one at random.
	var/minimap_color

/**
  * These two vars allow for multiple unique areas to be linked to a master area
  * and share some functionalities such as APC powernet nodes, fire alarms etc, without sacrificing
  * their own flags, statuses, variables and more snowflakes.
  * Friendly reminder: no map edited areas.
  */
	var/list/area/sub_areas //list of typepaths of the areas you wish to link here, will be replaced with a list of references on mapload.
	var/area/base_area //The area we wish to use in place of src for certain actions such as APC area linking.

	var/nightshift_public_area = NIGHTSHIFT_AREA_NONE		//considered a public area for nightshift

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
GLOBAL_LIST_EMPTY(teleportlocs)

/proc/process_teleport_locs()
	for(var/V in GLOB.sortedAreas)
		var/area/AR = V
		if(istype(AR, /area/shuttle) || AR.noteleport)
			continue
		if(GLOB.teleportlocs[AR.name])
			continue
		if (!AR.contents.len)
			continue
		var/turf/picked = AR.contents[1]
		if (picked && is_station_level(picked.z))
			GLOB.teleportlocs[AR.name] = AR

	sortTim(GLOB.teleportlocs, /proc/cmp_text_dsc)

// ===

/area/New()
	if(!minimap_color) // goes in New() because otherwise it doesn't fucking work
		// generate one using the icon_state
		if(icon_state && icon_state != "unknown")
			var/icon/I = new(icon, icon_state, dir)
			I.Scale(1,1)
			minimap_color = I.GetPixel(1,1)
		else // no icon state? use random.
			minimap_color = rgb(rand(50,70),rand(50,70),rand(50,70))	// This interacts with the map loader, so it needs to be set immediately
	// rather than waiting for atoms to initialize.
	if (unique)
		GLOB.areas_by_type[type] = src
	return ..()

/area/Initialize()
	icon_state = ""
	layer = AREA_LAYER
	map_name = name // Save the initial (the name set in the map) name of the area.
	canSmoothWithAreas = typecacheof(canSmoothWithAreas)

	if(requires_power)
		luminosity = 0
	else
		power_light = TRUE
		power_equip = TRUE
		power_environ = TRUE

		if(dynamic_lighting == DYNAMIC_LIGHTING_FORCED)
			dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
			luminosity = 0
		else if(dynamic_lighting != DYNAMIC_LIGHTING_IFSTARLIGHT)
			dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	if(dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
		dynamic_lighting = CONFIG_GET(flag/starlight) ? DYNAMIC_LIGHTING_ENABLED : DYNAMIC_LIGHTING_DISABLED

	. = ..()

	blend_mode = BLEND_MULTIPLY // Putting this in the constructor so that it stops the icons being screwed up in the map editor.

	if(!IS_DYNAMIC_LIGHTING(src))
		add_overlay(/obj/effect/fullbright)

	reg_in_areas_in_z()

	//so far I'm only implementing it on mapped unique areas, it's easier this way.
	if(unique && sub_areas)
		if(type in sub_areas)
			WARNING("\"[src]\" typepath found inside its own sub-areas list, please make sure it doesn't share its parent type initial sub-areas value.")
			sub_areas = null
		else
			var/paths = sub_areas.Copy()
			sub_areas = null
			for(var/type in paths)
				var/area/A = GLOB.areas_by_type[type]
				if(!A) //By chance an area not loaded in the current world, no warning report.
					continue
				if(A == src)
					WARNING("\"[src]\" area a attempted to link with itself.")
					continue
				if(A.base_area)
					WARNING("[src] attempted to link with [A] while the latter is already linked to another area ([A.base_area]).")
					continue
				LAZYADD(sub_areas, A)
				A.base_area = src
	else if(LAZYLEN(sub_areas))
		WARNING("sub-areas are currently not supported for non-unique areas such as [src].")
		sub_areas = null

	return INITIALIZE_HINT_LATELOAD

/area/LateInitialize()
	if(!base_area) //we don't want to run it twice.
		power_change()		// all machines set to current power level, also updates icon
	update_beauty()

/area/proc/reg_in_areas_in_z()
	if(contents.len)
		var/list/areas_in_z = SSmapping.areas_in_z
		var/z
		update_areasize()
		for(var/i in 1 to contents.len)
			var/atom/thing = contents[i]
			if(!thing)
				continue
			z = thing.z
			break
		if(!z)
			WARNING("No z found for [src]")
			return
		if(!areas_in_z["[z]"])
			areas_in_z["[z]"] = list()
		areas_in_z["[z]"] += src

/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
	if(base_area)
		LAZYREMOVE(base_area, src)
		base_area = null
	if(sub_areas)
		for(var/i in sub_areas)
			var/area/A = i
			A.base_area = null
			sub_areas -= A
			if(A.requires_power)
				A.power_light = FALSE
				A.power_equip = FALSE
				A.power_environ = FALSE
			INVOKE_ASYNC(A, .proc/power_change)
	STOP_PROCESSING(SSobj, src)
	return ..()

/area/proc/poweralert(state, obj/source)
	if (state != poweralm)
		poweralm = state
		if(istype(source))	//Only report power alarms on the z-level where the source is located.
			for (var/item in GLOB.silicon_mobs)
				var/mob/living/silicon/aiPlayer = item
				if (state == 1)
					aiPlayer.cancelAlarm("Power", src, source)
				else
					aiPlayer.triggerAlarm("Power", src, cameras, source)

			for (var/item in GLOB.alert_consoles)
				var/obj/machinery/computer/station_alert/a = item
				if(state == 1)
					a.cancelAlarm("Power", src, source)
				else
					a.triggerAlarm("Power", src, cameras, source)

			for (var/item in GLOB.drones_list)
				var/mob/living/simple_animal/drone/D = item
				if(state == 1)
					D.cancelAlarm("Power", src, source)
				else
					D.triggerAlarm("Power", src, cameras, source)
			for(var/item in GLOB.alarmdisplay)
				var/datum/computer_file/program/alarm_monitor/p = item
				if(state == 1)
					p.cancelAlarm("Power", src, source)
				else
					p.triggerAlarm("Power", src, cameras, source)

/area/proc/atmosalert(danger_level, obj/source)
	if(danger_level != atmosalm)
		if (danger_level==2)

			for (var/item in GLOB.silicon_mobs)
				var/mob/living/silicon/aiPlayer = item
				aiPlayer.triggerAlarm("Atmosphere", src, cameras, source)
			for (var/item in GLOB.alert_consoles)
				var/obj/machinery/computer/station_alert/a = item
				a.triggerAlarm("Atmosphere", src, cameras, source)
			for (var/item in GLOB.drones_list)
				var/mob/living/simple_animal/drone/D = item
				D.triggerAlarm("Atmosphere", src, cameras, source)
			for(var/item in GLOB.alarmdisplay)
				var/datum/computer_file/program/alarm_monitor/p = item
				p.triggerAlarm("Atmosphere", src, cameras, source)

		else if (src.atmosalm == 2)
			for (var/item in GLOB.silicon_mobs)
				var/mob/living/silicon/aiPlayer = item
				aiPlayer.cancelAlarm("Atmosphere", src, source)
			for (var/item in GLOB.alert_consoles)
				var/obj/machinery/computer/station_alert/a = item
				a.cancelAlarm("Atmosphere", src, source)
			for (var/item in GLOB.drones_list)
				var/mob/living/simple_animal/drone/D = item
				D.cancelAlarm("Atmosphere", src, source)
			for(var/item in GLOB.alarmdisplay)
				var/datum/computer_file/program/alarm_monitor/p = item
				p.cancelAlarm("Atmosphere", src, source)

		atmosalm = danger_level
		for(var/i in sub_areas)
			var/area/A = i
			A.atmosalm = danger_level
		return TRUE
	return FALSE

/area/proc/ModifyFiredoors(opening)
	if(firedoors)
		firedoors_last_closed_on = world.time
		for(var/FD in firedoors)
			var/obj/machinery/door/firedoor/D = FD
			var/cont = !D.welded
			if(cont && opening)	//don't open if adjacent area is on fire
				for(var/I in D.affecting_areas)
					var/area/A = I
					if(A.fire)
						cont = FALSE
						break
			if(cont && D.is_operational())
				if(D.operating)
					D.nextstate = opening ? FIREDOOR_OPEN : FIREDOOR_CLOSED
				else if(!(D.density ^ opening))
					INVOKE_ASYNC(D, (opening ? /obj/machinery/door/firedoor.proc/open : /obj/machinery/door/firedoor.proc/close))

/area/proc/firealert(obj/source)
	if(always_unpowered == 1) //no fire alarms in space/asteroid
		return

	if (!fire)
		set_fire_alarm_effects(TRUE)
		ModifyFiredoors(FALSE)

	for (var/item in GLOB.alert_consoles)
		var/obj/machinery/computer/station_alert/a = item
		a.triggerAlarm("Fire", src, cameras, source)
	for (var/item in GLOB.silicon_mobs)
		var/mob/living/silicon/aiPlayer = item
		aiPlayer.triggerAlarm("Fire", src, cameras, source)
	for (var/item in GLOB.drones_list)
		var/mob/living/simple_animal/drone/D = item
		D.triggerAlarm("Fire", src, cameras, source)
	for(var/item in GLOB.alarmdisplay)
		var/datum/computer_file/program/alarm_monitor/p = item
		p.triggerAlarm("Fire", src, cameras, source)

	START_PROCESSING(SSobj, src)

/area/proc/firereset(obj/source)
	if (fire)
		set_fire_alarm_effects(FALSE)
		ModifyFiredoors(TRUE)

	for (var/item in GLOB.silicon_mobs)
		var/mob/living/silicon/aiPlayer = item
		aiPlayer.cancelAlarm("Fire", src, source)
	for (var/item in GLOB.alert_consoles)
		var/obj/machinery/computer/station_alert/a = item
		a.cancelAlarm("Fire", src, source)
	for (var/item in GLOB.drones_list)
		var/mob/living/simple_animal/drone/D = item
		D.cancelAlarm("Fire", src, source)
	for(var/item in GLOB.alarmdisplay)
		var/datum/computer_file/program/alarm_monitor/p = item
		p.cancelAlarm("Fire", src, source)

	STOP_PROCESSING(SSobj, src)

/area/process()
	if(firedoors_last_closed_on + 100 < world.time)	//every 10 seconds
		ModifyFiredoors(FALSE)

/area/proc/close_and_lock_door(obj/machinery/door/DOOR)
	set waitfor = FALSE
	DOOR.close()
	if(DOOR.density)
		DOOR.lock()

/area/proc/burglaralert(obj/trigger)
	if(always_unpowered) //no burglar alarms in space/asteroid
		return

	//Trigger alarm effect
	set_fire_alarm_effects(TRUE)
	//Lockdown airlocks
	for(var/obj/machinery/door/DOOR in get_sub_areas_contents(src))
		close_and_lock_door(DOOR)

	for (var/i in GLOB.silicon_mobs)
		var/mob/living/silicon/SILICON = i
		if(SILICON.triggerAlarm("Burglar", src, cameras, trigger))
			//Cancel silicon alert after 1 minute
			addtimer(CALLBACK(SILICON, /mob/living/silicon.proc/cancelAlarm,"Burglar",src,trigger), 600)

/area/proc/set_fire_alarm_effects(boolean)
	fire = boolean
	for(var/i in sub_areas)
		var/area/A = i
		A.fire = boolean
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	for(var/alarm in firealarms)
		var/obj/machinery/firealarm/F = alarm
		F.update_fire_light(fire)
		F.update_icon()
	for(var/obj/machinery/light/L in get_sub_areas_contents(src))
		L.update()

/area/proc/updateicon()
/**
  * Update the icon state of the area
  *
  * Im not sure what the heck this does, somethign to do with weather being able to set icon
  * states on areas?? where the heck would that even display?
  */
/area/update_icon_state()
	var/weather_icon
	for(var/V in SSweather.processing)
		var/datum/weather/W = V
		if(W.stage != END_STAGE && (src in W.impacted_areas))
			W.update_areas()
			weather_icon = TRUE
	if(!weather_icon)
		icon_state = null

/**
  * Update the icon of the area (overridden to always be null for space
  */
/area/space/update_icon_state()
	icon_state = null

/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

/area/proc/powered(chan)		// return true if the area has power to given channel

	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return 0

/area/space/powered(chan) //Nope.avi
	return 0

// called when power status changes

/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()				// reverify power status (to update icons etc.)
	if(sub_areas)
		for(var/i in sub_areas)
			var/area/A = i
			A.power_light = power_light
			A.power_equip = power_equip
			A.power_environ = power_environ
			INVOKE_ASYNC(A, .proc/power_change)
	update_icon()

/area/proc/usage(chan)
	switch(chan)
		if(LIGHT)
			. += used_light
		if(EQUIP)
			. += used_equip
		if(ENVIRON)
			. += used_environ
		if(TOTAL)
			. += used_light + used_equip + used_environ
		if(STATIC_EQUIP)
			. += static_equip
		if(STATIC_LIGHT)
			. += static_light
		if(STATIC_ENVIRON)
			. += static_environ
	if(sub_areas)
		for(var/i in sub_areas)
			var/area/A = i
			. += A.usage(chan)

/area/proc/addStaticPower(value, powerchannel)
	switch(powerchannel)
		if(STATIC_EQUIP)
			static_equip += value
		if(STATIC_LIGHT)
			static_light += value
		if(STATIC_ENVIRON)
			static_environ += value

/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0
	if(sub_areas)
		for(var/i in sub_areas)
			var/area/A = i
			A.clear_usage()

/area/proc/use_power(amount, chan)

	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount


/area/Entered(atom/movable/M)
	set waitfor = FALSE
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, M)
	SEND_SIGNAL(M, COMSIG_ENTER_AREA, src) //The atom that enters the area
	if(!isliving(M))
		return

	var/mob/living/L = M
	if(!L.ckey)
		return

	// Ambience goes down here -- make sure to list each area separately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(L.client && !L.client.ambience_playing && L.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		L.client.ambience_playing = 1
		SEND_SOUND(L, sound('sound/ambience/shipambience.ogg', repeat = 1, wait = 0, volume = 35, channel = CHANNEL_BUZZ))

	if(!(L.client && (L.client.prefs.toggles & SOUND_AMBIENCE)))
		return //General ambience check is below the ship ambience so one can play without the other

	if(prob(35))
		var/sound = pick(ambientsounds)

		if(!L.client.played)
			SEND_SOUND(L, sound(sound, repeat = 0, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
			L.client.played = TRUE
			addtimer(CALLBACK(L.client, /client/proc/ResetAmbiencePlayed), 600)

///Divides total beauty in the room by roomsize to allow us to get an average beauty per tile.
/area/proc/update_beauty()
	if(!areasize)
		beauty = 0
		return FALSE
	if(areasize >= beauty_threshold)
		beauty = 0
		return FALSE //Too big
	beauty = totalbeauty / areasize

/area/Exited(atom/movable/M)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, M)
	SEND_SIGNAL(M, COMSIG_EXIT_AREA, src) //The atom that exits the area

/client/proc/ResetAmbiencePlayed()
	played = FALSE

/area/proc/setup(a_name)
	name = a_name
	power_equip = FALSE
	power_light = FALSE
	power_environ = FALSE
	always_unpowered = FALSE
	valid_territory = FALSE
	blob_allowed = FALSE
	addSorted()

/area/proc/update_areasize()
	if(outdoors)
		return FALSE
	areasize = 0
	for(var/turf/open/T in contents)
		areasize++

/area/AllowDrop()
	CRASH("Bad op: area/AllowDrop() called")

/area/drop_location()
	CRASH("Bad op: area/drop_location() called")

// A hook so areas can modify the incoming args
/area/proc/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	return flags
