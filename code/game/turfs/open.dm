/turf/open
	var/slowdown = 0 //negative for faster, positive for slower

	var/wet = 0
	var/wet_time = 0 // Time in seconds that this floor will be wet for.
	var/mutable_appearance/wet_overlay
	var/postdig_icon_change = FALSE
	var/postdig_icon
	var/list/archdrops

/turf/open/indestructible
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"

/turf/open/indestructible/TerraformTurf(path, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/open/indestructible/sound
	name = "squeeky floor"
	var/sound

/turf/open/indestructible/sound/Entered(var/mob/AM)
	..()
	if(istype(AM))
		playsound(src,sound,50,1)

/turf/open/indestructible/necropolis
	name = "necropolis floor"
	desc = "It's regarding you suspiciously."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro1"
	baseturf = /turf/open/indestructible/necropolis
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/indestructible/necropolis/Initialize()
	. = ..()
	if(prob(12))
		icon_state = "necro[rand(2,3)]"

/turf/open/indestructible/necropolis/air
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/open/indestructible/boss //you put stone tiles on this and use it as a base
	name = "necropolis floor"
	icon = 'icons/turf/boss_floors.dmi'
	icon_state = "boss"
	baseturf = /turf/open/indestructible/boss
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/indestructible/boss/air
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"

/turf/open/indestructible/hierophant
	icon = 'icons/turf/floors/hierophant_floor.dmi'
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	baseturf = /turf/open/indestructible/hierophant
	smooth = SMOOTH_TRUE

/turf/open/indestructible/hierophant/two

/turf/open/indestructible/hierophant/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/open/indestructible/paper
	name = "notebook floor"
	desc = "A floor made of invulnerable notebook paper."
	icon_state = "paperfloor"

/turf/open/indestructible/clock_spawn_room
	name = "cogmetal"
	desc = "Brass plating that gently radiates heat. For some reason, it reminds you of blood."
	icon_state = "reebe"
	baseturf = /turf/open/indestructible/clock_spawn_room

/turf/open/indestructible/clock_spawn_room/Entered()
	..()
	START_PROCESSING(SSfastprocess, src)

/turf/open/indestructible/clock_spawn_room/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	. = ..()

/turf/open/indestructible/clock_spawn_room/process()
	if(!port_servants())
		STOP_PROCESSING(SSfastprocess, src)

/turf/open/indestructible/clock_spawn_room/proc/port_servants()
	. = FALSE
	for(var/mob/living/L in src)
		if(is_servant_of_ratvar(L))
			. = TRUE
			L.forceMove(get_turf(pick(GLOB.servant_spawns)))
			visible_message("<span class='warning'>[L] vanishes in a flash of red!</span>")
			L.visible_message("<span class='warning'>[L] appears in a flash of red!</span>", \
			"<span class='bold cult'>sas'so c'arta forbici</span><br><span class='danger'>You're yanked away from [src]!</span>")
			playsound(src, 'sound/magic/enter_blood.ogg', 50, TRUE)
			playsound(L, 'sound/magic/exit_blood.ogg', 50, TRUE)
			flash_color(L, flash_color = "#C80000", flash_time = 10)

/turf/open/Initalize_Atmos(times_fired)
	excited = 0
	update_visuals()

	current_cycle = times_fired

	//cache some vars
	var/list/atmos_adjacent_turfs = src.atmos_adjacent_turfs

	for(var/direction in GLOB.cardinals)
		var/turf/open/enemy_tile = get_step(src, direction)
		if(!istype(enemy_tile))
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= enemy_tile
			continue
		var/datum/gas_mixture/enemy_air = enemy_tile.return_air()

		//only check this turf, if it didn't check us when it was initalized
		if(enemy_tile.current_cycle < times_fired)
			if(CANATMOSPASS(src, enemy_tile))
				LAZYINITLIST(atmos_adjacent_turfs)
				LAZYINITLIST(enemy_tile.atmos_adjacent_turfs)
				atmos_adjacent_turfs[enemy_tile] = TRUE
				enemy_tile.atmos_adjacent_turfs[src] = TRUE
			else
				if (atmos_adjacent_turfs)
					atmos_adjacent_turfs -= enemy_tile
				if (enemy_tile.atmos_adjacent_turfs)
					enemy_tile.atmos_adjacent_turfs -= src
				UNSETEMPTY(enemy_tile.atmos_adjacent_turfs)
				continue
		else
			if (!atmos_adjacent_turfs || !atmos_adjacent_turfs[enemy_tile])
				continue


		var/is_active = air.compare(enemy_air)

		if(is_active)
			//testing("Active turf found. Return value of compare(): [is_active]")
			if(!excited) //make sure we aren't already excited
				excited = 1
				SSair.active_turfs |= src
	UNSETEMPTY(atmos_adjacent_turfs)
	if (atmos_adjacent_turfs)
		src.atmos_adjacent_turfs = atmos_adjacent_turfs

/turf/open/proc/GetHeatCapacity()
	. = air.heat_capacity()

/turf/open/proc/GetTemperature()
	. = air.temperature

/turf/open/proc/TakeTemperature(temp)
	air.temperature += temp
	air_update_turf()

/turf/open/proc/freon_gas_act()
	for(var/obj/I in contents)
		if(I.resistance_flags & FREEZE_PROOF)
			return
		if(!(I.flags_2 & FROZEN_2)) //let it go
			I.make_frozen_visual()
	for(var/mob/living/L in contents)
		if(L.bodytemperature <= 50)
			L.apply_status_effect(/datum/status_effect/freon)
	MakeSlippery(TURF_WET_PERMAFROST, 5)
	return 1

/turf/open/proc/water_vapor_gas_act()
	MakeSlippery(min_wet_time = 10, wet_time_to_add = 5)

	for(var/mob/living/simple_animal/slime/M in src)
		M.apply_water()

	clean_blood()
	for(var/obj/effect/O in src)
		if(is_cleanable(O))
			qdel(O)

	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in src)
	if(hotspot && !isspaceturf(src))
		air.temperature = max(min(air.temperature-2000,air.temperature/2),0)
		qdel(hotspot)
	return 1

/turf/open/handle_slip(mob/living/carbon/C, knockdown_amount, obj/O, lube)
	if(C.movement_type & FLYING)
		return 0
	if(has_gravity(src))
		var/obj/buckled_obj
		if(C.buckled)
			buckled_obj = C.buckled
			if(!(lube&GALOSHES_DONT_HELP)) //can't slip while buckled unless it's lube.
				return 0
		else
			if(C.lying || !(C.status_flags & CANKNOCKDOWN)) // can't slip unbuckled mob if they're lying or can't fall.
				return 0
			if(C.m_intent == MOVE_INTENT_WALK && (lube&NO_SLIP_WHEN_WALKING))
				return 0
		if(!(lube&SLIDE_ICE))
			to_chat(C, "<span class='notice'>You slipped[ O ? " on the [O.name]" : ""]!</span>")
			C.log_message("<font color='orange'>Slipped[O ? " on the [O.name]" : ""][(lube&SLIDE)? " (LUBE)" : ""]!</font>", INDIVIDUAL_ATTACK_LOG)
		if(!(lube&SLIDE_ICE))
			playsound(C.loc, 'sound/misc/slip.ogg', 50, 1, -3)

		for(var/obj/item/I in C.held_items)
			C.accident(I)

		var/olddir = C.dir
		if(!(lube & SLIDE_ICE))
			C.Knockdown(knockdown_amount)
			C.stop_pulling()
		else
			C.Stun(20)

		if(buckled_obj)
			buckled_obj.unbuckle_mob(C)
			lube |= SLIDE_ICE

		if(lube&SLIDE)
			new /datum/forced_movement(C, get_ranged_target_turf(C, olddir, 4), 1, FALSE, CALLBACK(C, /mob/living/carbon/.proc/spin, 1, 1))
		else if(lube&SLIDE_ICE)
			new /datum/forced_movement(C, get_ranged_target_turf(C, olddir, 1), 1, FALSE)	//spinning would be bad for ice, fucks up the next dir
		return 1

/turf/open/copyTurf(turf/T)
	. = ..()
	if(. && isopenturf(T) && wet_time)
		var/turf/open/O = T
		O.MakeSlippery(wet_setting = wet, wet_time_to_add = wet_time) //we're copied, copy how wet we are also

/turf/open/proc/MakeSlippery(wet_setting = TURF_WET_WATER, min_wet_time = 0, wet_time_to_add = 0) // 1 = Water, 2 = Lube, 3 = Ice, 4 = Permafrost, 5 = Slide
	wet_time = max(wet_time+wet_time_to_add, min_wet_time)
	if(wet >= wet_setting)
		return
	wet = wet_setting
	UpdateSlip()
	if(wet_setting != TURF_DRY)
		if(wet_overlay)
			cut_overlay(wet_overlay)
		else
			wet_overlay = mutable_appearance()
		var/turf/open/floor/F = src
		if(istype(F))
			if(wet_setting == TURF_WET_PERMAFROST)
				wet_overlay.icon = 'icons/effects/water.dmi'
				wet_overlay.icon_state = "ice_floor"
			else if(wet_setting == TURF_WET_ICE)
				wet_overlay.icon = 'icons/turf/overlays.dmi'
				wet_overlay.icon_state = "snowfloor"
			else
				wet_overlay.icon = 'icons/effects/water.dmi'
				wet_overlay.icon_state = "wet_floor_static"
		else
			wet_overlay.icon = 'icons/effects/water.dmi'
			wet_overlay.icon_state = "wet_static"
		add_overlay(wet_overlay)
	HandleWet()

/turf/open/proc/UpdateSlip()
	var/intensity
	var/lube_flags
	switch(wet)
		if(TURF_WET_WATER)
			intensity = 60
			lube_flags = NO_SLIP_WHEN_WALKING
		if(TURF_WET_LUBE)
			intensity = 80
			lube_flags = SLIDE | GALOSHES_DONT_HELP
		if(TURF_WET_ICE)
			intensity = 120
			lube_flags = SLIDE | GALOSHES_DONT_HELP
		if(TURF_WET_PERMAFROST)
			intensity = 120
			lube_flags = SLIDE_ICE | GALOSHES_DONT_HELP
		if(TURF_WET_SLIDE)
			intensity = 80
			lube_flags = SLIDE | GALOSHES_DONT_HELP
		else
			qdel(GetComponent(/datum/component/slippery))
			return
	var/datum/component/slippery/S = LoadComponent(/datum/component/slippery)
	S.intensity = intensity
	S.lube_flags = lube_flags

/turf/open/ComponentActivated(datum/component/C)
	..()
	var/datum/component/slippery/S = C
	if(!istype(S))
		return
	if(wet == TURF_WET_LUBE)
		var/mob/living/L = S.slip_victim
		L.confused = max(L.confused, 8)

/turf/open/proc/MakeDry(wet_setting = TURF_WET_WATER)
	if(wet > wet_setting || !wet)
		return
	spawn(rand(0,20))
		if(wet == TURF_WET_PERMAFROST)
			wet = TURF_WET_ICE
		else if(wet == TURF_WET_ICE)
			wet = TURF_WET_WATER
		else
			wet = TURF_DRY
			if(wet_overlay)
				cut_overlay(wet_overlay)
		UpdateSlip()

/turf/open/proc/HandleWet()
	if(!wet)
		//It's possible for this handler to get called after all the wetness is
		//cleared, so bail out if that is the case
		return
	if(!wet_time && wet < TURF_WET_ICE)
		MakeDry(TURF_WET_ICE)
	if(wet_time > MAXIMUM_WET_TIME)
		wet_time = MAXIMUM_WET_TIME
	if(wet == TURF_WET_ICE && air.temperature > T0C)
		for(var/obj/O in contents)
			if(O.flags_2 & FROZEN_2)
				O.make_unfrozen()
		MakeDry(TURF_WET_ICE)
		MakeSlippery(TURF_WET_WATER)
	if(wet != TURF_WET_PERMAFROST)
		switch(air.temperature)
			if(-INFINITY to T0C)
				if(wet != TURF_WET_ICE && wet)
					MakeDry(TURF_WET_ICE)
					MakeSlippery(TURF_WET_ICE)
			if(T0C to T20C)
				wet_time = max(0, wet_time-1)
			if(T20C to T0C + 40)
				wet_time = max(0, wet_time-2)
			if(T0C + 40 to T0C + 60)
				wet_time = max(0, wet_time-3)
			if(T0C + 60 to T0C + 80)
				wet_time = max(0, wet_time-5)
			if(T0C + 80 to T0C + 100)
				wet_time = max(0, wet_time-10)
			if(T0C + 100 to INFINITY)
				wet_time = 0
	else if (GetTemperature() > BODYTEMP_COLD_DAMAGE_LIMIT)	//seems like a good place
		MakeDry(TURF_WET_PERMAFROST)
	else
		wet_time = max(0, wet_time-5)
	if(wet && wet < TURF_WET_ICE && !wet_time)
		MakeDry(TURF_WET_ICE)
	if(!wet && wet_time)
		wet_time = 0
	if(wet)
		addtimer(CALLBACK(src, .proc/HandleWet), 15, TIMER_UNIQUE)

/turf/open/get_dumping_location()
	return src

/turf/open/proc/ClearWet()//Nuclear option of immediately removing slipperyness from the tile instead of the natural drying over time
	wet = TURF_DRY
	UpdateSlip()
	if(wet_overlay)
		cut_overlay(wet_overlay)

