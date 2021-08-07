/turf/open/floor/glass
	name = "Glass floor"
	desc = "Dont jump on it, or do, I'm not your mom."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "floor_glass"
	baseturfs = /turf/open/openspace
	intact = FALSE //this means wires go on top
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/glass, /turf/open/floor/glass/reinforced)
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	floor_tile = /obj/item/stack/sheet/glass

// /turf/open/floor/glass/setup_broken_states()
// 	return list("glass-damaged1", "glass-damaged2", "glass-damaged3")


/turf/open/floor/glass/Initialize()
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, TRUE)

/// n(omegalul)
/turf/open/floor/glass/crowbar_act(mob/living/user, obj/item/I)
	return TRUE

/turf/open/floor/glass/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, "<span class='notice'>You begin removing glass...</span>")
	if(I.use_tool(src, user, 30, volume=80))
		if(!istype(src, /turf/open/floor/glass))
			return TRUE
		if(floor_tile)
			new floor_tile(src, 2)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return TRUE

/turf/open/floor/glass/reinforced
	name = "Reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "floor_glass"
	// base_icon_state = "reinf_glass"

// /turf/open/floor/glass/reinforced/setup_broken_states()
// 	return list("reinf_glass-damaged1", "reinf_glass-damaged2", "reinf_glass-damaged3")

/turf/open/floor/glass/reinforced/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, "<span class='notice'>You begin removing reinforced glass...</span>")
	if(I.use_tool(src, user, 30, volume=80))
		if(!istype(src, /turf/open/floor/glass/reinforced))
			return TRUE
		if(floor_tile)
			new floor_tile(src, 2)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return TRUE
