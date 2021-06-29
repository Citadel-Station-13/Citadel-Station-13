/obj/effect/temp_visual/point
	name = "pointer"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "arrow"
	layer = POINT_LAYER
	duration = 25

/obj/effect/temp_visual/point/Initialize(mapload, set_invis = 0)
	. = ..()
	var/atom/old_loc = loc
	loc = get_turf(src) // We don't want to actualy trigger anything when it moves
	pixel_x = old_loc.pixel_x
	pixel_y = old_loc.pixel_y
	invisibility = set_invis

//Used by spraybottles.
/obj/effect/decal/chempuff
	name = "chemicals"
	icon = 'icons/obj/chempuff.dmi'
	pass_flags = PASSTABLE | PASSGRILLE
	layer = FLY_LAYER
	var/stream = FALSE
	var/speed = 1
	var/range = 3
	var/hits_left = 3
	var/range_left = 3
	var/firstmove = TRUE
	var/list/hit

/obj/effect/decal/chempuff/blob_act(obj/structure/blob/B)
	return

/obj/effect/decal/chempuff/Initialize(mapload, stream_mode, speed, range, hits_left, size)
	. = ..()
	create_reagents(size, NONE, NO_REAGENTS_VALUE)
	stream = stream_mode
	src.speed = speed
	src.range = src.range_left = range
	src.hits_left = hits_left
	hit = list()

/obj/effect/decal/chempuff/Destroy()
	hit = null
	return ..()

/obj/effect/decal/chempuff/proc/hit_thing(atom/A, ignore_firstmove)
	if(A == src || A.invisibility)
		return
	if(firstmove && !ignore_firstmove)
		return
	if(!hits_left || hit[A])
		return
	var/living = isliving(A)
	if(!A.density)
		return
	if(ismob(A) && !living)
		return
	hit[A] = TRUE
	if(stream)
		if(ismob(A))
			var/mob/M = A
			if(!M.lying || !range_left)
				reagents.reaction(M, VAPOR)
				hits_left--
		else
			if(!range_left)
				reagents.reaction(A, VAPOR)
	else
		reagents.reaction(A)
		if(ismob(A))
			hits_left--

/obj/effect/decal/chempuff/Crossed(atom/movable/AM, oldloc)
	. = ..()
	hit_thing(AM)

/obj/effect/decal/chempuff/Bump(atom/A)
	. = ..()
	hit_thing(A, TRUE)

/obj/effect/decal/chempuff/proc/run_puff(atom/target)
	var/safety = 255
	while(range_left)
		if(!safety--)
			CRASH("Spray ran out of safety.")
		step_towards(src, target)
		if(firstmove)
			firstmove = FALSE
		range_left--
		if(!isturf(loc))
			break
		for(var/atom/T in loc)
			hit_thing(T)
			if(!hits_left || !isturf(loc))
				break
		if(isturf(loc) && (!stream || !range_left))
			reagents.reaction(loc, VAPOR)
		sleep(speed)
	qdel(src)

/obj/effect/decal/fakelattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice"
	density = TRUE
