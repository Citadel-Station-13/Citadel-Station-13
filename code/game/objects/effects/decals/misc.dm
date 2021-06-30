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

/obj/effect/decal/chempuff/blob_act(obj/structure/blob/B)
	return

/obj/effect/decal/chempuff/Initialize(mapload, stream_mode, speed, range, hits_left)
	. = ..()
	stream = stream_mode
	src.speed = speed
	src.range = src.range_left = range
	src.hits_left = hits_left

/obj/effect/decal/chempuff/proc/hit_thing(atom/A)
	if(A == src || A.invisibility)
		return
	if(!hits_left)
		return
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

/obj/effect/decal/chempuff/proc/run_puff(atom/target)
	set waitfor = FALSE
	for(var/i in 1 to range)
		range_left--
		if(!isturf(loc))
			break
		for(var/atom/T in loc)
			hit_thing(T)
			if(!hits_left || !isturf(loc))
				break
		if(hits_left && isturf(loc) && (!stream || !range_left))
			reagents.reaction(loc, VAPOR)
			hits_left--
		if(!hits_left)
			break
	qdel(src)

/obj/effect/decal/fakelattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice"
	density = TRUE
