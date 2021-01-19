#define SPAWN_MEGAFAUNA "bluh bluh huge boss"
#define SPAWN_BUBBLEGUM 6

//This list prevents spawning more than the associated amount
//of megafauna.
GLOBAL_LIST_INIT(cap_megas,\
	list(/mob/living/simple_animal/hostile/megafauna/dragon = 3,\
	/mob/living/simple_animal/hostile/megafauna/colossus = 3,\
	/mob/living/simple_animal/hostile/megafauna/bubblegum = 3))

//this is probably a horrendous way to do it
//forgive me for my sins
//this is basically a list of all the turfs that
//attempted to spawn a monster/tendril in lavaland
GLOBAL_LIST_INIT(spawned_turfs, list())

//this list counts all the turfs that successfuly spawned
//a monster or tendril
GLOBAL_LIST_INIT(success_spawned_turfs, list())

/turf/open/floor/plating/asteroid/airless/cave/volcanic
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50, /obj/structure/spawner/lavaland/goliath = 3, \
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/random = 40, /obj/structure/spawner/lavaland = 2, \
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/random = 30, /obj/structure/spawner/lavaland/legion = 3, \
		/mob/living/simple_animal/hostile/asteroid/miner = 40, /obj/structure/spawner/lavaland/shamblingminer = 2, \
		/mob/living/simple_animal/hostile/asteroid/imp = 20, /obj/structure/spawner/lavaland/imp = 1, \
		SPAWN_MEGAFAUNA = 6, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10)
		//imps are rare because boy they annoying

/turf/open/floor/plating/asteroid/airless/cave/proc/SpawnMonster(turf/T)
	if(!isarea(loc))
		return
	var/area/A = loc
	GLOB.spawned_turfs += src
	if(prob(30))
		if(!A.mob_spawn_allowed)
			return
		var/randumb = pickweight(mob_spawn_list)
		if(!randumb)
			return
		while(randumb == SPAWN_MEGAFAUNA)
			if(A.megafauna_spawn_allowed && megafauna_spawn_list && megafauna_spawn_list.len) //this is danger. it's boss time.
				var/maybe_boss = pickweight(megafauna_spawn_list)
				if(megafauna_spawn_list[maybe_boss])
					var/count = get_mega_count(maybe_boss)
					if(count < GLOB.cap_megas[maybe_boss])
						randumb = maybe_boss
					else
						randumb = pickweight(mob_spawn_list)
			else //this is not danger, don't spawn a boss, spawn something else
				randumb = pickweight(mob_spawn_list)

		for(var/mob/living/simple_animal/hostile/H in urange(12,T)) //prevents mob clumps
			if((ispath(randumb, /mob/living/simple_animal/hostile/megafauna) || ismegafauna(H)) && get_dist(src, H) <= 7)
				return //if there's a megafauna within standard view don't spawn anything at all
			if(ispath(randumb, /mob/living/simple_animal/hostile/asteroid) || istype(H, /mob/living/simple_animal/hostile/asteroid))
				return //if the random is a standard mob, avoid spawning if there's another one within 12 tiles
		if(ispath(randumb, /obj/structure/spawner/lavaland))
			for(var/obj/structure/spawner/lavaland/L in urange(12,T))
				return //prevents tendrils spawning in each other's collapse range

		new randumb(T)
		GLOB.success_spawned_turfs += src
	return TRUE

/turf/open/floor/plating/asteroid/airless/cave/proc/BruteForceSpawn(var/mob/living/simple_animal/hostile/megafauna/boss)
	if(!isarea(loc))
		return FALSE
	var/area/A = loc
	if(!A.mob_spawn_allowed)
		return FALSE
	if(!boss || !istype(boss))
		return FALSE
	if(A.megafauna_spawn_allowed && megafauna_spawn_list && megafauna_spawn_list.len) //this is danger. it's boss time.
		if(get_mega_count(boss) < GLOB.cap_megas[boss])
			new boss()
			return TRUE
	return FALSE

/turf/open/floor/plating/asteroid/airless/cave/proc/BruteForceTendril(var/obj/structure/spawner/lavaland/tend)
	if(!isarea(loc))
		return FALSE
	var/area/A = loc
	if(!A.mob_spawn_allowed)
		return FALSE
	if(!tend || !istype(tend))
		return FALSE
	if(get_tendril_count(tend) < 1)
		new tend()
		return TRUE
	return FALSE

/proc/get_mega_count(var/mob/living/simple_animal/hostile/megafauna/maybe_boss)
	var/count = 0
	for(var/mob/living/simple_animal/hostile/megafauna/M in GLOB.mob_living_list)
		if(istype(M, maybe_boss))
			count++
	return count

/proc/get_tendril_count(var/obj/structure/spawner/lavaland/meme)
	var/count = 0
	for(var/obj/structure/spawner/lavaland/T in GLOB.tendrils)
		if(istype(T, meme))
			count++
	return count
