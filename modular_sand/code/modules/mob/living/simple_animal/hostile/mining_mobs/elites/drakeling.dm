#define LAVA_MOAT 1
#define LAVA_AROUND 2
#define FIRE_SPEW 3
#define FIRE_MOAT 4

/**
  * # Drakeling
  *
  * A small drake/dragon.
  * Has four attacks.
  * - Lava moat - Creates a moat of lava around themselves.
  * - Lava rivers - Creates lava rivers in all cardinal directions.
  * - Firespew - Spews fire in the direction they're facing.
  * - Fire moat - Spews fire in all directions.
  */

/mob/living/simple_animal/hostile/asteroid/elite/drakeling
	name = "Drakeling"
	desc = "A small but still fearsome dragon."
	icon = 'modular_sand/icons/mob/lavaland/lavaland_elites.dmi'
	icon_state = "ash_whelp"
	icon_living = "ash_whelp"
	icon_aggro = "ash_whelp"
	icon_dead = "ash_whelp_dead"
	icon_gib = "syndicate_gib"
	maxHealth = 800
	health = 800
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	speed = 1
	move_to_delay = 3
	mouse_opacity = MOUSE_OPACITY_ICON
	deathsound = 'sound/magic/WandODeath.ogg'
	deathmessage = "'s wings flail weakly until he settles down, dead"
	loot_drop = /obj/item/borg/upgrade/modkit/fire
	speak_emote = list("huffs")

	attack_action_types = list(/datum/action/innate/elite_attack/lavamoat,
								/datum/action/innate/elite_attack/lavaaround,
								/datum/action/innate/elite_attack/firespew,
								/datum/action/innate/elite_attack/firemoat)
	glorymessageshand = list("rips off the little dragon's horns, then shoves them into their mouth!", "grabs the drakeling's head and rips it off violently from their neck with their bare hands!")
	glorymessagescrusher = list("slashes the drakeling's head in half with their crusher, dividing it in two!")
	glorymessagespka = list("hits the drakeling's maw repeatedly with the stock of their PKA until it breaks off, then shoots it in the head for good measure!", "grabs the drakeling's neck, and shoots it's head off with their PKA!")
	glorymessagespkabayonet = list("kicks the drakeling onto the ground belly up, then slices their tummy open with the bayonet as it screams in agony!")

/datum/action/innate/elite_attack/lavamoat
	name = "Lava Moat"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "lava_moat"
	chosen_message = "<span class='boldwarning'>You will attempt to create a lava moat around you.</span>"
	chosen_attack_num = LAVA_MOAT

/datum/action/innate/elite_attack/lavaaround
	name = "Lava Rivers"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "lava_around"
	chosen_message = "<span class='boldwarning'>You will now create lava rivers at your cardinal directions.</span>"
	chosen_attack_num = LAVA_AROUND

/datum/action/innate/elite_attack/firespew
	name = "Fire Spew"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "fire_spew"
	chosen_message = "<span class='boldwarning'>You will now spew fire at your target.</span>"
	chosen_attack_num = FIRE_SPEW

/datum/action/innate/elite_attack/firemoat
	name = "Fire Moat"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "fire_moat"
	chosen_message = "<span class='boldwarning'>You will now spew fire at all cardinal directions.</span>"
	chosen_attack_num = FIRE_MOAT

/mob/living/simple_animal/hostile/asteroid/elite/drakeling/OpenFire()
	if(client)
		switch(chosen_attack)
			if(LAVA_MOAT)
				lava_moat(target)
			if(LAVA_AROUND)
				lava_around(target)
			if(FIRE_SPEW)
				fire_spew()
			if(FIRE_MOAT)
				fire_moat()
		return
	var/aiattack = rand(1,4)
	switch(aiattack)
		if(LAVA_MOAT)
			lava_moat(target)
		if(LAVA_AROUND)
			lava_around(target)
		if(FIRE_SPEW)
			fire_spew()
		if(FIRE_MOAT)
			fire_moat()

//Drakeling actions
/mob/living/simple_animal/hostile/asteroid/elite/drakeling/proc/lava_moat()
	ranged_cooldown = world.time + 25
	visible_message("<span class='boldwarning'>[src] spews lava around themselves! Get back!</span>")
	for(var/turf/T in oview(1, src))
		new /obj/effect/temp_visual/lava_warning(T)

/mob/living/simple_animal/hostile/asteroid/elite/drakeling/proc/lava_around()
	ranged_cooldown = world.time + 50
	for(var/d in GLOB.cardinals)
		INVOKE_ASYNC(src, .proc/lava_wall, d, 5)

/mob/living/simple_animal/hostile/asteroid/elite/drakeling/proc/fire_spew()
	ranged_cooldown = world.time + 25
	visible_message("<span class='boldwarning'>[src] spews fire!</span>")
	playsound(src,'sound/magic/Fireball.ogg', 200, 1)
	sleep(5)
	fire_wall(src.dir, 10)

/mob/living/simple_animal/hostile/asteroid/elite/drakeling/proc/fire_moat()
	ranged_cooldown = world.time + 100
	playsound(src,'sound/magic/Fireball.ogg', 200, 1)
	visible_message("<span class='boldwarning'>[src] violently puffs smoke!They're going to make a fire moat!</span>")
	sleep(5)
	for(var/d in GLOB.alldirs)
		INVOKE_ASYNC(src, .proc/fire_wall, d, 10)

// Drakeling helpers

/mob/living/simple_animal/hostile/asteroid/elite/drakeling/proc/fire_wall(dir, range)
	var/list/hitlist = list(src)
	var/turf/T = get_turf(src)
	for(var/i in 1 to range)
		new /obj/effect/hotspot(T)
		T.hotspot_expose(700,50,1)
		for(var/mob/living/L in T.contents)
			if(L in hitlist || (L == src))
				break
			else
				hitlist += L
				L.adjustFireLoss(20)
				to_chat(L, "<span class='userdanger'>You're hit by [src]'s fire breath!</span>")
		T = get_step(T, dir)
		sleep(1)

/mob/living/simple_animal/hostile/asteroid/elite/drakeling/proc/lava_wall(dir, range)
	var/turf/T = get_turf(src)
	for(var/i in 1 to range)
		new /obj/effect/temp_visual/lava_warning(T)
		T = get_step(T, dir)
		sleep(2)

/obj/effect/temp_visual/lava_warning
	icon_state = "lavastaff_warn"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 7

/obj/effect/temp_visual/lava_warning/ex_act()
	return

/obj/effect/temp_visual/lava_warning/Initialize(mapload, reset_time = 40)
	. = ..()
	INVOKE_ASYNC(src, .proc/fall, reset_time)
	src.alpha = 63.75
	animate(src, alpha = 255, time = duration)

/obj/effect/temp_visual/lava_warning/proc/fall(var/reset_time)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
	sleep(duration)
	playsound(T,'sound/magic/fireball.ogg', 200, TRUE)
	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/asteroid/elite/drakeling))
			continue
		L.adjustFireLoss(10)
		to_chat(L, "<span class='userdanger'>You fall directly into the pool of lava!</span>")

	// deals damage to mechs
	for(var/obj/mecha/M in T.contents)
		M.take_damage(45, BRUTE, "melee", 1)

	// changes turf to lava temporarily
	if(!istype(T, /turf/closed) && !istype(T, /turf/open/lava))
		var/lava_turf = /turf/open/lava/smooth
		var/reset_turf = T.type
		T.ChangeTurf(lava_turf, flags = CHANGETURF_INHERIT_AIR)
		addtimer(CALLBACK(T, /turf.proc/ChangeTurf, reset_turf, null, CHANGETURF_INHERIT_AIR), reset_time, TIMER_OVERRIDE|TIMER_UNIQUE)
