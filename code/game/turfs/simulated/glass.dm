/turf/open/floor/glass
	name = "glass floor"
	desc = "Don't jump on it, or do, I'm not your mom."
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass"
	broken_states = list("glass-damaged1", "glass-damaged2", "glass-damaged3")
	baseturfs = /turf/open/openspace
	underfloor_accessibility = UNDERFLOOR_VISIBLE
	smooth = SMOOTH_MORE
	// smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	canSmoothWith = list(/turf/open/floor/glass, /turf/open/floor/glass/reinforced) // canSmoothWith = list(SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS)
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	floor_tile = /obj/item/stack/tile/glass

/turf/open/floor/glass/Initialize(mapload)
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, TRUE)

/turf/open/floor/glass/reinforced
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass"
	broken_states = list("reinf_glass-damaged1", "reinf_glass-damaged2", "reinf_glass-damaged3")
	floor_tile = /obj/item/stack/tile/rglass

/turf/open/floor/glass/reinforced/icemoon
	name = "reinforced glass floor"
	desc = "Do jump on it, it can take it."
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass"
	broken_states = list("reinf_glass-damaged1", "reinf_glass-damaged2", "reinf_glass-damaged3")
	floor_tile = /obj/item/stack/tile/rglass
	initial_gas_mix = "ICEMOON_ATMOS"
