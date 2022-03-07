/**
 * Can a turf be built on? Usually used to ensure you can't build over things like transit turfs
 */
/turf/proc/CanBuildOn()
	return TRUE

/turf/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
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
	if(!istype(I /obj/item/stack/rods))
		return FALSE


	return TRUE

/turf/proc/attempt_catwalk_construction(obj/item/I, mob/user, params)

/turf/proc/attempt_plating_construction(obj/item/I, mob/user, params)

/turf/proc/has_lattice()
	return locate(/obj/structure/lattice) in src

/turf/proc/has_catwalk()
	return locate(/obj/structure/lattice/catwalk) in src

/turf/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	. = ..()

/turf/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	. = ..()

#warn impl rcd
