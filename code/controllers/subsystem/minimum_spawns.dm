SUBSYSTEM_DEF(min_spawns)
	name = "Minimum Spawns" // it should be more like "failsafe spawns" or "backup spawns" or something
	init_order = INIT_ORDER_DEFAULT
	flags = SS_BACKGROUND | SS_NO_FIRE
	wait = 2
	var/snaxi_snowflake_check = FALSE
	var/list/active_spawns = list() // lavaland, snaxi, etc. primary spawn list
	var/list/active_spawns_2 = list() // snaxi underground, etc. secondary spawn list
	var/list/valid_mining_turfs = list() // lavaland/snaxi turfs
	var/list/valid_mining_turfs_2 = list() // snaxi underground turfs

GLOBAL_LIST_INIT(minimum_lavaland_spawns, list(
	/obj/structure/spawner/lavaland,
	/obj/structure/spawner/lavaland/goliath,
	/obj/structure/spawner/lavaland/legion,
	/mob/living/simple_animal/hostile/megafauna/dragon,
	/mob/living/simple_animal/hostile/megafauna/colossus,
	/mob/living/simple_animal/hostile/megafauna/bubblegum
))

GLOBAL_LIST_INIT(minimum_snow_surface_spawns, list(
	/obj/structure/spawner/ice_moon,
	/obj/structure/spawner/ice_moon/polarbear
))
GLOBAL_LIST_INIT(minimum_snow_under_spawns, list(
	/obj/structure/spawner/ice_moon/demonic_portal,
	/obj/structure/spawner/ice_moon/demonic_portal/ice_whelp,
	/obj/structure/spawner/ice_moon/demonic_portal/snowlegion
))

// step 1: check for which list(s) to use - done
// step 2: check for caves - done
// step 3: check for mobs - done
// step 4: start throwing shit down - done
// step 5: snaxi support - done?

/datum/controller/subsystem/min_spawns/Initialize(start_timeofday)
	if(SSmapping.levels_by_trait(ZTRAIT_LAVA_RUINS)) //todo: recognizing maps that aren't lavaland mining but are also not snaxi
		active_spawns = GLOB.minimum_lavaland_spawns
	else if(SSmapping.levels_by_trait(ZTRAIT_ICE_RUINS))
		active_spawns = GLOB.minimum_snow_surface_spawns
		active_spawns_2 = GLOB.minimum_snow_under_spawns
		snaxi_snowflake_check = TRUE
	if(!active_spawns && !active_spawns_2)
		return ..() // call it a day i guess
	// borrowing this from auxbase code - see code\modules\mining\aux_base.dm
	if(snaxi_snowflake_check)
		for(var/z_level in SSmapping.levels_by_trait(ZTRAIT_ICE_RUINS))
			for(var/turf/TT in Z_TURFS(z_level))
				if(!isarea(TT.loc))
					continue
				var/area/A = TT.loc
				if(!A.mob_spawn_allowed)
					continue
				if(!istype(TT, /turf/open/floor/plating/asteroid))
					continue
				if(typesof(/turf/open/lava) in orange(9, TT))
					continue
				valid_mining_turfs.Add(TT)
		for(var/z_level in SSmapping.levels_by_trait(ZTRAIT_ICE_RUINS_UNDERGROUND))
			for(var/turf/TT in Z_TURFS(z_level))
				if(!isarea(TT.loc))
					continue
				var/area/A = TT.loc
				if(!A.mob_spawn_allowed)
					continue
				if(!istype(TT, /turf/open/floor/plating/asteroid))
					continue
				if(typesof(/turf/open/lava) in orange(9, TT))
					continue
				valid_mining_turfs_2.Add(TT)	
	else
		for(var/z_level in SSmapping.levels_by_trait(ZTRAIT_LAVA_RUINS))
			for(var/turf/TT in Z_TURFS(z_level))
				if(!isarea(TT.loc))
					continue
				var/area/A = TT.loc
				if(!A.mob_spawn_allowed)
					continue
				if(!istype(TT, /turf/open/floor/plating/asteroid))
					continue
				if(typesof(/turf/open/lava) in orange(9, TT))
					continue
				valid_mining_turfs.Add(TT)
	if(!valid_mining_turfs)
		return ..() // call it a day i guess
	// if we're at this point we might as well fucking hit it
	where_we_droppin_boys()
	return ..()

/datum/controller/subsystem/min_spawns/proc/where_we_droppin_boys()
	while(active_spawns.len)
		CHECK_TICK
		var/turf/RT = pick_n_take(valid_mining_turfs) //Pick a random mining Z-level turf
		var/MS_tospawn = pick_n_take(active_spawns)
		for(var/mob/living/simple_animal/hostile/H in urange(70,RT)) //prevents mob clumps
			if((ispath(MS_tospawn, /mob/living/simple_animal/hostile/megafauna) || ismegafauna(H)) && get_dist(src, H) <= 70)
				active_spawns.Add(MS_tospawn)
				return //let's try not to dump megas too close to each other?	
			if((ispath(MS_tospawn, /obj/structure/spawner) || istype(H, /obj/structure/spawner)) && get_dist(src, H) <= 35)
				active_spawns.Add(MS_tospawn)
				return //let's at least /try/ to space these out?
		for(var/obj/structure/spawner/LT in urange(70,RT)) //prevents tendril/mega clumps
			if((ispath(MS_tospawn, /mob/living/simple_animal/hostile/megafauna)) && get_dist(src, LT) <= 70)
				active_spawns.Add(MS_tospawn)
				return //let's try not to dump megas too close to each other?	
			if((ispath(MS_tospawn, /obj/structure/spawner)) && get_dist(src, LT) <= 35)
				active_spawns.Add(MS_tospawn)
				return //let's at least /try/ to space these out?
			// man the overhead on this is gonna SUCK
		new MS_tospawn(RT)
	while(active_spawns_2.len)
		CHECK_TICK
		var/turf/RT = pick_n_take(valid_mining_turfs_2) //Pick a random mining Z-level turf
		var/MS2_tospawn = pick_n_take(active_spawns_2)
		for(var/mob/living/simple_animal/hostile/H in urange(70,RT)) //prevents mob clumps
			if((ispath(MS2_tospawn, /mob/living/simple_animal/hostile/megafauna) || ismegafauna(H)) && get_dist(src, H) <= 70)
				active_spawns_2.Add(MS2_tospawn)
				return //let's try not to dump megas too close to each other?	
			if((ispath(MS2_tospawn, /obj/structure/spawner) || istype(H, /obj/structure/spawner)) && get_dist(src, H) <= 35)
				active_spawns_2.Add(MS2_tospawn)
				return //let's at least /try/ to space these out?
		for(var/obj/structure/spawner/LT in urange(70,RT)) //prevents tendril/mega clumps
			if((ispath(MS2_tospawn, /mob/living/simple_animal/hostile/megafauna)) && get_dist(src, LT) <= 70)
				active_spawns_2.Add(MS2_tospawn)
				return //let's try not to dump megas too close to each other?	
			if((ispath(MS2_tospawn, /obj/structure/spawner)) && get_dist(src, LT) <= 35)
				active_spawns.Add(MS2_tospawn)
				return //let's at least /try/ to space these out?
			// man the overhead on this is gonna SUCK
		new MS2_tospawn(RT)
