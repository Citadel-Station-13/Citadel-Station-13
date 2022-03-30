/turf/open/space
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	name = "\proper space"
	intact = 0
	dirt_buildup_allowed = FALSE
	turf_construct_flags = TURF_CONSTRUCT_FLAGS_PLATING_OVER

	initial_temperature = TCMB
	thermal_conductivity = 0
	heat_capacity = 700000
	wave_explosion_multiply = EXPLOSION_DAMPEN_SPACE
	wave_explosion_block = EXPLOSION_BLOCK_SPACE

	var/static/datum/gas_mixture/immutable/space/space_gas
	plane = PLANE_SPACE
	layer = SPACE_LAYER
	light_power = 0.25
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	bullet_bounce_sound = null

	vis_flags = VIS_INHERIT_ID	//when this be added to vis_contents of something it be associated with something on clicking, important for visualisation of turf in openspace and interraction with openspace that show you turf.

/turf/open/space/basic/New()	//Do not convert to Initialize
	//This is used to optimize the map loader
	return

/**
 * Space Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize]
 */
/turf/open/space/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	icon_state = SPACE_ICON_STATE
	if(!space_gas)
		space_gas = new
	air = space_gas
	update_air_ref(0)
	vis_contents.Cut() //removes inherited overlays
	visibilityChanged()

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	// if (length(smoothing_groups))
	// 	sortTim(smoothing_groups) //In case it's not properly ordered, let's avoid duplicate entries with the same values.
	// 	SET_BITFLAG_LIST(smoothing_groups)
	// if (length(canSmoothWith))
	// 	sortTim(canSmoothWith)
	// 	if(canSmoothWith[length(canSmoothWith)] > MAX_S_TURF) //If the last element is higher than the maximum turf-only value, then it must scan turf contents for smoothing targets.
	// 		smoothing_flags |= SMOOTH_OBJ
	// 	SET_BITFLAG_LIST(canSmoothWith)

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if (light_power && light_range)
		update_light()

	if (opacity)
		has_opaque_atom = TRUE

	ComponentInitialize()

	return INITIALIZE_HINT_NORMAL

/turf/open/space/Initalize_Atmos(times_fired)
	return

/turf/open/space/TakeTemperature(temp)

/turf/open/space/RemoveLattice()
	return

/turf/open/space/AfterChange()
	..()
	atmos_overlay_types = null

/turf/open/space/Assimilate_Air()
	return

//IT SHOULD RETURN NULL YOU MONKEY, WHY IN TARNATION WHAT THE FUCKING FUCK
/turf/open/space/remove_air(amount)
	return null

/turf/open/space/remove_air_ratio(amount)
	return null

/turf/open/space/proc/update_starlight()
	if(CONFIG_GET(flag/starlight))
		for(var/t in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
			if(isspaceturf(t))
				//let's NOT update this that much pls
				continue
			set_light(2)
			return
		set_light(0)

/turf/open/space/attack_paw(mob/user)
	return attack_hand(user)

/turf/open/space/handle_slip()
	return // no lube bullshit, this is space

/turf/open/space/Exited(atom/movable/AM, atom/OldLoc)
	. = ..()
	var/turf/old = get_turf(OldLoc)
	if(!isspaceturf(old) && ismob(AM))
		var/mob/M = AM
		M.update_gravity(M.mob_has_gravity())

/turf/open/space/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/space/singularity_act()
	return

/turf/open/space/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return 1
	return 0

/turf/open/space/acid_act(acidpwr, acid_volume)
	return 0

/turf/open/space/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/space.dmi'
	underlay_appearance.icon_state = SPACE_ICON_STATE
	underlay_appearance.plane = PLANE_SPACE
	return TRUE

/turf/open/space/get_yelling_resistance(power)
	return INFINITY				// no sound through space for crying out loud
