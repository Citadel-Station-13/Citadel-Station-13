/**
 * Can a turf be built on? Usually used to ensure you can't build over things like transit turfs
 */
/turf/proc/CanBuildOn(mob/user)
	return TRUE

/turf/attackby(obj/item/C, mob/user, params)
	. = ..()
	var/turf/target
	var/list/modifiers = params2list(params)
	if(modifiers["ctrl"])
		target = Above()
		if(!target)
			to_chat(user, "<span class='warning'>There's nothing above this turf!</span>")
			return
		if(!target.CanBuildOn(user))
			to_chat(user, span_warning("You can't build on the turf above this!"))
			return
	else
		if(!CanBuildOn(user))
			to_chat(user, span_warning("You can't build on this turf!"))
			return
		target = src
	if(target.attempt_lattice_construction(C, user, params))
		return TRUE
	if(target.attempt_catwalk_construction(C, user, params))
		return TRUE
	if(target.attempt_plating_construction(C, user, params))
		return TRUE

/turf/proc/attempt_lattice_construction(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/stack/rods))
		return FALSE
	if(!(turf_construct_flags & TURF_CONSTRUCT_ROD_LATTICE))
		return FALSE
	if(locate(/obj/structure/lattice) in src)
		return FALSE
	var/obj/item/stack/rods/R = I
	if(!R.use(1))
		to_chat(user, span_warning("You need one rod to build a lattice."))
		return FALSE
	to_chat(user, span_notice("You construct a lattice."))
	playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
	ReplaceWithLattice()
	return TRUE

/turf/proc/attempt_catwalk_construction(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/stack/rods))
		return FALSE
	if(!(turf_construct_flags & TURF_CONSTRUCT_ROD_CATWALK))
		return FALSE
	if(locate(/obj/structure/lattice/catwalk) in src)
		return FALSE
	var/has_lattice = locate(/obj/structure/lattice) in src
	var/obj/item/stack/rods/R = I
	if(!R.use(has_lattice? 1 : 2))
		to_chat(user, span_warning("You need [has_lattice? "one" : "two"] rod to build a catwalk."))
		return FALSE
	to_chat(user, span_notice("You construct a catwalk."))
	playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
	new /obj/structure/lattice/catwalk(src)
	return TRUE

#warn plating direct flag too, check flags on all
/turf/proc/attempt_plating_construction(obj/item/I, mob/user, params)
	if(!(turf_construct_flags & TURF_CONSTRUCT_TILE_PLATING))
		return FALSE
	if(!istype(I, /obj/item/stack/tile/plasteel))
		return FALSE
	var/has_lattice = has_lattice()
	if(!has_lattice && !(turf_construct_flags & TURF_CONSTRUCT_TILE_PLATING_DIRECT))
		to_chat(user, "<span class='warning'>The plating is going to need some support! Place metal rods first.</span>")
		return FALSE
	var/obj/item/stack/tile/plasteel/S = I
	if(!S.use(1))
		to_chat(user, span_warning("You need one floor tile to build a floor!"))
		return FALSE
	var/obj/structure/lattice/L = locate() in src
	var/catwalk_mitigation = FALSE
	if(istype(L, /obj/structure/lattice/catwalk))
		catwalk_mitigation = TRUE
		new /obj/item/stack/rods(src)
	qdel(L)
	playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
	to_chat(user, "<span class='notice'>You build a floor[catwalk_mitigation && ", tearing away the excess rods from the catwalk"].</span>")
	PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)

/turf/proc/has_lattice()
	return locate(/obj/structure/lattice) in src

/turf/proc/has_catwalk()
	return locate(/obj/structure/lattice/catwalk) in src

/turf/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span_notice("You build a floor."))
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, span_warning("You tear down \the [src]!"))
			ScrapeAway(1, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

/turf/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildOn())
		return FALSE
	var/is_under = FALSE
	if(user.z != z)
		var/turf/below = Below()
		if(!below)
			return FALSE
		if(user.z == below.z)
			is_under = TRUE
	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/lattice_mitigation = has_lattice()? ((locate(/obj/structure/lattice/catwalk) in src)? 4 : 2) : 0
			if(is_under && !(turf_construct_flags & TURF_CONSTRUCT_ALLOW_FROM_UNDER))
				return FALSE
			if(!(turf_construct_flags & TURF_CONSTRUCT_RCD_PLATING))
				return FALSE
			return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = max(0, rcd_plating_cost - lattice_mitigation))
		if(RCD_DECONSTRUCT)
			if(is_under && !(turf_construct_flags & TURF_DECONSTRUCT_ALLOW_FROM_UNDER))
				return FALSE
			if(!(turf_construct_flags & TURF_DECONSTRUCT_RCD_TEARDOWN))
				return FALSE
			return list("mode" = RCD_DECONSTRUCT, "delay" = 40, "cost" = rcd_teardown_cost)
	return ..()
