/**
 * Can a turf be built on? Usually used to ensure you can't build over things like transit turfs
 */
/turf/proc/CanBuildOn(mob/user)
	return TRUE

/turf/attackby(obj/item/C, mob/user, params)
	. = ..()
	var/turf/target
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
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
	#warn rework this, check for ctrl for multiz upwards build.
	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			to_chat(user, "<span class='warning'>There is already a catwalk here!</span>")
			return
		if(L)
			if(R.use(1))
				qdel(L)
				to_chat(user, "<span class='notice'>You construct a catwalk.</span>")
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				new/obj/structure/lattice/catwalk(src)
			else
				to_chat(user, "<span class='warning'>You need two rods to build a catwalk!</span>")
			return
		if(R.use(1))
			to_chat(user, "<span class='notice'>You construct a lattice.</span>")
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			ReplaceWithLattice()
		else
			to_chat(user, "<span class='warning'>You need one rod to build a lattice.</span>")
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				to_chat(user, "<span class='notice'>You build a floor.</span>")
				PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			else
				to_chat(user, "<span class='warning'>You need one floor tile to build a floor!</span>")
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support! Place metal rods first.</span>")

#warn impl

/turf/proc/attempt_lattice_construction(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/stack/rods))
		return FALSE


	return TRUE

/turf/proc/attempt_catwalk_construction(obj/item/I, mob/user, params)

#warn plating direct flag too, check flags on all
/turf/proc/attempt_plating_construction(obj/item/I, mob/user, params)

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
			var/lattice_mitigation = has_lattice? 2 : 0
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
