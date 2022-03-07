
/turf/open/openspace
	name = "open space"
	desc = "Watch your step!"
	icon_state = "transparent"
	baseturfs = /turf/open/openspace
	CanAtmosPassVertical = ATMOS_PASS_YES
	z_flags = Z_OPEN_UP | Z_OPEN_DOWN | Z_AIR_UP | Z_AIR_DOWN | Z_TRANSPARENT
	turf_construct_flags = TURF_CONSTRUCT_FLAGS_PLATING_OVER
	intact = FALSE //this means wires go on top
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/turf/open/openspace/airless
	initial_gas_mix = AIRLESS_ATMOS


/turf/open/openspace/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return TRUE
	return FALSE

/turf/open/openspace/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildHere())
		return FALSE

	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)
			else
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/openspace/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, "<span class='notice'>You build a floor.</span>")
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

/turf/open/openspace/icemoon
	name = "ice chasm"
	baseturfs = /turf/open/openspace/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	planetary_atmos = TRUE
	var/replacement_turf = /turf/open/floor/plating/asteroid/snow/icemoon
	/// Replaces itself with replacement_turf if the turf below this one is in a no ruins allowed area (usually ruins themselves)
	var/protect_ruin = TRUE
	/// If true mineral turfs below this openspace turf will be mined automatically
	var/drill_below = TRUE

/turf/open/openspace/icemoon/Initialize()
	. = ..()
	var/turf/T = below()
	if(T.flags_1 & NO_RUINS_1 && protect_ruin)
		ChangeTurf(replacement_turf, null, CHANGETURF_IGNORE_AIR)
		return
	if(!ismineralturf(T) || !drill_below)
		return
	var/turf/closed/mineral/M = T
	M.mineralAmt = 0
	M.gets_drilled()
	baseturfs = /turf/open/openspace/icemoon //This is to ensure that IF random turf generation produces a openturf, there won't be other turfs assigned other than openspace.

/turf/open/openspace/icemoon/keep_below
	drill_below = FALSE

/turf/open/openspace/icemoon/ruins
	protect_ruin = FALSE
	drill_below = FALSE
