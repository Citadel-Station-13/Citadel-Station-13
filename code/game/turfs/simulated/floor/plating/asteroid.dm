


/**********************Asteroid**************************/

/turf/open/floor/plating/asteroid //floor piece
	name = "asteroid sand"
	baseturf = /turf/open/floor/plating/asteroid
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	icon_plating = "asteroid"
	var/environment_type = "asteroid"
	var/turf_type = /turf/open/floor/plating/asteroid //Because caves do whacky shit to revert to normal
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug
	var/sand_type = /obj/item/weapon/ore/glass
	var/floor_variance = 20 //probability floor has a different icon state

/turf/open/floor/plating/asteroid/Initialize()
	var/proper_name = name
	..()
	name = proper_name
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(0,12)]"

/turf/open/floor/plating/asteroid/burn_tile()
	return

/turf/open/floor/plating/asteroid/ex_act(severity, target)
	contents_explosion(severity, target)
	switch(severity)
		if(3)
			return
		if(2)
			if(prob(20))
				src.gets_dug()
		if(1)
			src.gets_dug()

/turf/open/floor/plating/asteroid/attackby(obj/item/weapon/W, mob/user, params)
	//note that this proc does not call ..()
	if(!W || !user)
		return 0
	var/digging_speed = 0
	if (istype(W, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/S = W
		digging_speed = S.digspeed
	else if (istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = W
		digging_speed = P.digspeed
	if (digging_speed)
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if (dug)
			to_chat(user, "<span class='warning'>This area has already been dug!</span>")
			return

		to_chat(user, "<span class='notice'>You start digging...</span>")
		playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)

		if(do_after(user, digging_speed, target = src))
			if(istype(src, /turf/open/floor/plating/asteroid))
				to_chat(user, "<span class='notice'>You dig a hole.</span>")
				gets_dug()
				feedback_add_details("pick_used_mining","[W.type]")

	if(istype(W,/obj/item/weapon/storage/bag/ore))
		var/obj/item/weapon/storage/bag/ore/S = W
		if(S.collection_mode == 1)
			for(var/obj/item/weapon/ore/O in src.contents)
				O.attackby(W,user)
				return

	if(istype(W, /obj/item/stack/tile))
		var/obj/item/stack/tile/Z = W
		if(!Z.use(1))
			return
		var/turf/open/floor/T = ChangeTurf(Z.turf_type)
		if(istype(Z,/obj/item/stack/tile/light)) //TODO: get rid of this ugly check somehow
			var/obj/item/stack/tile/light/L = Z
			var/turf/open/floor/light/F = T
			F.state = L.state
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)

/turf/open/floor/plating/asteroid/proc/gets_dug()
	if(dug)
		return
	for(var/i in 1 to 5)
		new sand_type(src)
	dug = 1
	icon_plating = "[environment_type]_dug"
	icon_state = "[environment_type]_dug"
	slowdown = 0
	return

/turf/open/floor/plating/asteroid/singularity_act()
	return

/turf/open/floor/plating/asteroid/singularity_pull(S, current_size)
	return


/turf/open/floor/plating/asteroid/basalt
	name = "volcanic floor"
	baseturf = /turf/open/floor/plating/asteroid/basalt
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	icon_plating = "basalt"
	environment_type = "basalt"
	sand_type = /obj/item/weapon/ore/glass/basalt
	floor_variance = 15

/turf/open/floor/plating/asteroid/basalt/lava //lava underneath
	baseturf = /turf/open/floor/plating/lava/smooth

/turf/open/floor/plating/asteroid/basalt/airless
	initial_gas_mix = "TEMP=2.7"

/turf/open/floor/plating/asteroid/basalt/Initialize()
	..()
	set_basalt_light(src)

/proc/set_basalt_light(turf/open/floor/B)
	switch(B.icon_state)
		if("basalt1", "basalt2", "basalt3")
			B.set_light(2, 0.6, LIGHT_COLOR_LAVA) //more light
		if("basalt5", "basalt9")
			B.set_light(1.4, 0.6, LIGHT_COLOR_LAVA) //barely anything!

/turf/open/floor/plating/asteroid/basalt/gets_dug()
	if(!dug)
		set_light(0)
	..()


///////Surface. The surface is warm, but survivable without a suit. Internals are required. The floors break to chasms, which drop you into the underground.

/turf/open/floor/plating/asteroid/basalt/lava_land_surface
	initial_gas_mix = "o2=14;n2=23;TEMP=300"
	planetary_atmos = TRUE
	baseturf = /turf/open/floor/plating/lava/smooth/lava_land_surface




/turf/open/floor/plating/asteroid/airless
	initial_gas_mix = "TEMP=2.7"
	turf_type = /turf/open/floor/plating/asteroid/airless


#define SPAWN_MEGAFAUNA "bluh bluh huge boss"
#define SPAWN_BUBBLEGUM 6

/turf/open/floor/plating/asteroid/airless/cave
	var/length = 100
	var/list/mob_spawn_list
	var/list/megafauna_spawn_list
	var/list/flora_spawn_list
	var/sanity = 1
	var/forward_cave_dir = 1
	var/backward_cave_dir = 2
	var/going_backwards = TRUE
	var/has_data = FALSE
	var/data_having_type = /turf/open/floor/plating/asteroid/airless/cave/has_data
	turf_type = /turf/open/floor/plating/asteroid/airless

/turf/open/floor/plating/asteroid/airless/cave/has_data //subtype for producing a tunnel with given data
	has_data = TRUE

/turf/open/floor/plating/asteroid/airless/cave/volcanic
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast = 50, /mob/living/simple_animal/hostile/spawner/lavaland/goliath = 3, \
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher = 40, /mob/living/simple_animal/hostile/spawner/lavaland = 2, \
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion = 30, /mob/living/simple_animal/hostile/spawner/lavaland/legion = 3, \
		SPAWN_MEGAFAUNA = 6, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10)

	data_having_type = /turf/open/floor/plating/asteroid/airless/cave/volcanic/has_data
	turf_type = /turf/open/floor/plating/asteroid/basalt/lava_land_surface
	initial_gas_mix = "o2=14;n2=23;TEMP=300"

/turf/open/floor/plating/asteroid/airless/cave/volcanic/has_data //subtype for producing a tunnel with given data
	has_data = TRUE

/turf/open/floor/plating/asteroid/airless/cave/Initialize()
	if (!mob_spawn_list)
		mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goldgrub = 1, /mob/living/simple_animal/hostile/asteroid/goliath = 5, /mob/living/simple_animal/hostile/asteroid/basilisk = 4, /mob/living/simple_animal/hostile/asteroid/hivelord = 3)
	if (!megafauna_spawn_list)
		megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/dragon = 4, /mob/living/simple_animal/hostile/megafauna/colossus = 2, /mob/living/simple_animal/hostile/megafauna/bubblegum = SPAWN_BUBBLEGUM)
	if (!flora_spawn_list)
		flora_spawn_list = list(/obj/structure/flora/ash/leaf_shroom = 2 , /obj/structure/flora/ash/cap_shroom = 2 , /obj/structure/flora/ash/stem_shroom = 2 , /obj/structure/flora/ash/cacti = 1, /obj/structure/flora/ash/tall_shroom = 2)

	if(!has_data)
		produce_tunnel_from_data()
	else
		..()	//do not continue after changeturfing or we will do a double initialize

/turf/open/floor/plating/asteroid/airless/cave/proc/get_cave_data(set_length, exclude_dir = -1)
	// If set_length (arg1) isn't defined, get a random length; otherwise assign our length to the length arg.
	if(!set_length)
		length = rand(25, 50)
	else
		length = set_length

	// Get our directiosn
	forward_cave_dir = pick(GLOB.alldirs - exclude_dir)
	// Get the opposite direction of our facing direction
	backward_cave_dir = angle2dir(dir2angle(forward_cave_dir) + 180)

/turf/open/floor/plating/asteroid/airless/cave/proc/produce_tunnel_from_data(tunnel_length, excluded_dir = -1)
	get_cave_data(tunnel_length, excluded_dir)
	// Make our tunnels
	make_tunnel(forward_cave_dir)
	if(going_backwards)
		make_tunnel(backward_cave_dir)
	// Kill ourselves by replacing ourselves with a normal floor.
	SpawnFloor(src)

/turf/open/floor/plating/asteroid/airless/cave/proc/make_tunnel(dir)
	var/turf/closed/mineral/tunnel = src
	var/next_angle = pick(45, -45)

	for(var/i = 0; i < length; i++)
		if(!sanity)
			break

		var/list/L = list(45)
		if(IsOdd(dir2angle(dir))) // We're going at an angle and we want thick angled tunnels.
			L += -45

		// Expand the edges of our tunnel
		for(var/edge_angle in L)
			var/turf/closed/mineral/edge = get_step(tunnel, angle2dir(dir2angle(dir) + edge_angle))
			if(istype(edge))
				SpawnFloor(edge)

		if(!sanity)
			break

		// Move our tunnel forward
		tunnel = get_step(tunnel, dir)

		if(istype(tunnel))
			// Small chance to have forks in our tunnel; otherwise dig our tunnel.
			if(i > 3 && prob(20))
				var/turf/open/floor/plating/asteroid/airless/cave/C = tunnel.ChangeTurf(data_having_type,FALSE,TRUE)
				C.going_backwards = FALSE
				C.produce_tunnel_from_data(rand(10, 15), dir)
			else
				SpawnFloor(tunnel)
		else //if(!istype(tunnel, src.parent)) // We hit space/normal/wall, stop our tunnel.
			break

		// Chance to change our direction left or right.
		if(i > 2 && prob(33))
			// We can't go a full loop though
			next_angle = -next_angle
			setDir(angle2dir(dir2angle(dir) )+ next_angle)


/turf/open/floor/plating/asteroid/airless/cave/proc/SpawnFloor(turf/T)
	for(var/S in RANGE_TURFS(1, src))
		var/turf/NT = S
		if(!NT || isspaceturf(NT) || istype(NT.loc, /area/mine/explored) || istype(NT.loc, /area/lavaland/surface/outdoors/explored))
			sanity = 0
			break
	if(!sanity)
		return
	SpawnFlora(T)

	SpawnMonster(T)
	T.ChangeTurf(turf_type,FALSE,TRUE)

/turf/open/floor/plating/asteroid/airless/cave/proc/SpawnMonster(turf/T)
	if(prob(30))
		if(istype(loc, /area/mine/explored) || istype(loc, /area/lavaland/surface/outdoors/explored))
			return
		var/randumb = pickweight(mob_spawn_list)
		while(randumb == SPAWN_MEGAFAUNA)
			var/maybe_boss = pickweight(megafauna_spawn_list)
			if(megafauna_spawn_list[maybe_boss])
				randumb = maybe_boss
				if(ispath(maybe_boss, /mob/living/simple_animal/hostile/megafauna/bubblegum)) //there can be only one bubblegum, so don't waste spawns on it
					megafauna_spawn_list[maybe_boss] = 0

		for(var/mob/living/simple_animal/hostile/H in urange(12,T)) //prevents mob clumps
			if((ispath(randumb, /mob/living/simple_animal/hostile/megafauna) || ismegafauna(H)) && get_dist(src, H) <= 7)
				return //if there's a megafauna within standard view don't spawn anything at all
			if(ispath(randumb, /mob/living/simple_animal/hostile/asteroid) || istype(H, /mob/living/simple_animal/hostile/asteroid))
				return //if the random is a standard mob, avoid spawning if there's another one within 12 tiles
			if((ispath(randumb, /mob/living/simple_animal/hostile/spawner/lavaland) || istype(H, /mob/living/simple_animal/hostile/spawner/lavaland)) && get_dist(src, H) <= 2)
				return //prevents tendrils spawning in each other's collapse range

		new randumb(T)
	return

#undef SPAWN_MEGAFAUNA
#undef SPAWN_BUBBLEGUM

/turf/open/floor/plating/asteroid/airless/cave/proc/SpawnFlora(turf/T)
	if(prob(12))
		if(istype(loc, /area/mine/explored) || istype(loc, /area/lavaland/surface/outdoors/explored))
			return
		var/randumb = pickweight(flora_spawn_list)
		for(var/obj/structure/flora/ash/F in range(4, T)) //Allows for growing patches, but not ridiculous stacks of flora
			if(!istype(F, randumb))
				return
		new randumb(T)



/turf/open/floor/plating/asteroid/snow
	name = "snow"
	desc = "Looks cold."
	icon = 'icons/turf/snow.dmi'
	baseturf = /turf/open/floor/plating/asteroid/snow
	icon_state = "snow"
	icon_plating = "snow"
	initial_gas_mix = "TEMP=180"
	slowdown = 2
	environment_type = "snow"
	sand_type = /obj/item/stack/sheet/mineral/snow

/turf/open/floor/plating/asteroid/snow/airless
	initial_gas_mix = "TEMP=2.7"

/turf/open/floor/plating/asteroid/snow/temperatre
	initial_gas_mix = "TEMP=255.37"

/turf/open/floor/plating/asteroid/snow/atmosphere
	initial_gas_mix = "o2=22;n2=82;TEMP=180"
