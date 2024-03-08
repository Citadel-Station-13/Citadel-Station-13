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

/// proc called to handle us hitting something
/obj/effect/decal/chempuff/proc/hit_thing(atom/A, bump_hit)
	// if the thing is invisible it usually is abstract/underfloor. also, don't hit ourselves.
	if(A == src || A.invisibility)
		return
	// don't hit anything on the first move unless overridden (see: we're colliding a wall blocking our move out of the first tile)
	if(firstmove && !bump_hit)
		return
	// we're out of hits or we already hit it
	if(!hits_left || hit[A])
		return
	var/living = isliving(A)
	// if it's not dense and we're a stream instead of a mist, and we're not out of range
	if(!A.density && stream && range_left && !bump_hit)
		return
	// non living mobs are effectively abstract
	if(ismob(A) && !living)
		return
	hit[A] = TRUE
	reagents.reaction(A, VAPOR)
	// mobs absorb enough to decrement hits_left, as well as stuff blocking us.
	if(ismob(A) || bump_hit)
		hits_left--

/obj/effect/decal/chempuff/Crossed(atom/movable/AM, oldloc)
	. = ..()
	// bump things moving into us as long as we're not on our first move/moving out of origin tile
	hit_thing(AM)

/obj/effect/decal/chempuff/Bump(atom/A)
	. = ..()
	// if we hit something blocking our movement, collide it regardless even if we're still on our origin tile
	hit_thing(A, TRUE)

/obj/effect/decal/chempuff/proc/run_puff(atom/target)
	var/safety = 255
	while(range_left)
		if(!safety--)
			CRASH("Spray ran out of safety.")
		// move towards new turf
		step_towards(src, target)
		if(firstmove)
			// mark first movement so future Cross()es result in collisions
			firstmove = FALSE
		// decrement range
		range_left--
		// if we got nullspaced, exit
		if(!isturf(loc))
			break
		// hit everything in it
		for(var/atom/T in loc)
			hit_thing(T)
			// if we got deleted or ran out of hits, stop
			if(!hits_left || !isturf(loc))
				break
		if(!hits_left || !isturf(loc))
			// yeah yeah sue me it's copypasted code but I don't want to declare a var.
			break
		// hit the turf
		hit_thing(loc)
		sleep(speed)
	qdel(src)

/obj/effect/decal/fakelattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice"
	density = TRUE
