/mob/living/simple_animal/hostile/megafauna/rogueprocess
	name = "Rogue Process"
	desc = "Once an experimental mecha carrying an advanced mining AI, now it's out for blood."
	health = 2500
	maxHealth = 2500
	movement_type = GROUND
	attack_verb_continuous = "drills"
	attack_verb_simple = "drill"
	attack_sound = 'sound/weapons/drill.ogg'
	icon = 'sandcode/icons/mob/lavaland/rogue.dmi'
	icon_state = "rogue"
	icon_living = "rogue"
	icon_dead = "rogue-broken"
	friendly_verb_continuous = "pokes"
	friendly_verb_simple = "poke"
	speak_emote = list("screeches")
	mob_biotypes = MOB_ROBOTIC
	melee_damage_lower = 30
	melee_damage_upper = 30
	speed = 1
	move_to_delay = 10
	ranged_cooldown_time = 80
	ranged = 1
	del_on_death = 0
	crusher_loot = list(/obj/structure/closet/crate/necropolis/rogue/crusher)
	loot = list(/obj/structure/closet/crate/necropolis/rogue)
	deathmessage = "sparkles and emits corrupted screams in agony, falling defeated on the ground."
	death_sound = 'sound/mecha/critdestr.ogg'
	anger_modifier = 0
	footstep_type = FOOTSTEP_MOB_HEAVY
	mob_biotypes = MOB_ROBOTIC
	songs = list("2930" = sound(file = 'sandcode/sound/ambience/mbrsystemshock.ogg', repeat = 0, wait = 0, volume = 60, channel = CHANNEL_BOSSMUSIC)) //System shock theme remix by Master Boot Record
	var/special = FALSE
	wander = FALSE
	faction = list("mining", "boss")
	weather_immunities = list("lava","ash")
	blood_volume = 0
	var/min_sparks = 1
	var/max_sparks = 4

/obj/item/gps/internal/rogueprocess
	icon_state = null
	gpstag = "Corrupted Signal"
	desc = "It's full of ransomware."
	invisibility = 100

/obj/item/projectile/plasma/rogue
	dismemberment = 0
	damage = 25
	pixels_per_second = TILES_TO_PIXELS(10)
	range = 21
	color = "#FF0000"

/mob/living/simple_animal/hostile/megafauna/rogueprocess/Initialize()
	. = ..()
	internal = new /obj/item/gps/internal/rogueprocess(src)

/mob/living/simple_animal/hostile/megafauna/rogueprocess/adjustHealth(amount, updating_health, forced)
	. = ..()
	if(.)
		anger_modifier = round(clamp(((maxHealth - health) / 42),0,60))
		move_to_delay = clamp(round((src.health/src.maxHealth) * 10), 2.5, 8)
		wander = FALSE
		do_sparks(rand(min_sparks,max_sparks), FALSE, src)

/mob/living/simple_animal/hostile/megafauna/rogueprocess/OpenFire(target)
	if(special)
		return FALSE
	ranged_cooldown = world.time + min((ranged_cooldown_time - anger_modifier), 60)
	switch(anger_modifier)
		if(0 to 25)
			if(prob(50))
				INVOKE_ASYNC(src, .proc/plasmashot, target, FALSE)
				sleep(6)
				INVOKE_ASYNC(src, .proc/plasmashot, target, FALSE)
				sleep(4)
				INVOKE_ASYNC(src, .proc/plasmashot, target, FALSE)
			else
				INVOKE_ASYNC(src, .proc/shockwave, src.dir, 7, TRUE)
		if(25 to 50)
			if(prob(60))
				INVOKE_ASYNC(src, .proc/plasmaburst, target, FALSE)
				sleep(5)
				INVOKE_ASYNC(src, .proc/plasmaburst, target, TRUE)
				sleep(3)
				INVOKE_ASYNC(src, .proc/plasmashot, target, FALSE)
				sleep(3)
				if(prob(50))
					INVOKE_ASYNC(src, .proc/plasmashot, target, FALSE)
			else
				INVOKE_ASYNC(src, .proc/shockwave, WEST, 10, TRUE)
				INVOKE_ASYNC(src, .proc/shockwave, EAST, 10, TRUE)
				sleep(7)
				INVOKE_ASYNC(src, .proc/shockwave, NORTH, 10, TRUE)
				INVOKE_ASYNC(src, .proc/shockwave, SOUTH, 10, TRUE)
		if(50 to INFINITY)
			if(prob(65))
				if(prob(60))
					INVOKE_ASYNC(src, .proc/plasmaburst, target, FALSE)
					INVOKE_ASYNC(src, .proc/shockwave, src.dir, 15, FALSE)
					sleep(5)
					INVOKE_ASYNC(src, .proc/plasmaburst, target, FALSE)
					sleep(5)
					INVOKE_ASYNC(src, .proc/plasmaburst, target, FALSE)
					sleep(3)
					INVOKE_ASYNC(src, .proc/plasmaburst, target, FALSE)
				else 
					var/turf/up = locate(x, y + 10, z)
					var/turf/down = locate(x, y - 10, z)
					var/turf/left = locate(x - 10, y, z)
					var/turf/right = locate(x + 10, y, z)
					INVOKE_ASYNC(src, .proc/plasmaburst, up, TRUE)
					INVOKE_ASYNC(src, .proc/plasmaburst, down, FALSE)
					sleep(3)
					INVOKE_ASYNC(src, .proc/plasmashot, left, FALSE)
					INVOKE_ASYNC(src, .proc/plasmashot, right, FALSE)
					sleep(10)
					if(prob(35))
						for(var/dire in GLOB.cardinals)
							INVOKE_ASYNC(src, .proc/shockwave, dire, 7, TRUE)
			else
				INVOKE_ASYNC(src, .proc/ultishockwave, 7, TRUE)

/mob/living/simple_animal/hostile/megafauna/rogueprocess/Move()
	. = ..()
	if(special)
		return FALSE
	playsound(src.loc, 'sound/mecha/mechmove01.ogg', 200, 1, 2, 1)

/mob/living/simple_animal/hostile/megafauna/rogueprocess/Bump(atom/A)
	. = ..()
	if(isturf(A) || isobj(A) && A.density)
		A.ex_act(EXPLODE_HEAVY)
		DestroySurroundings()

/mob/living/simple_animal/hostile/megafauna/rogueprocess/proc/plasmashot(atom/target, var/specialize = TRUE)
	var/path = get_dist(src, target)
	if(path > 2)
		if(!target)
			return
		visible_message("<span class='boldwarning'>[src] raises it's plasma cutter!</span>")
		if(specialize)
			special = TRUE
		sleep(3)
		var/turf/startloc = get_turf(src)
		var/obj/item/projectile/P = new /obj/item/projectile/plasma/rogue(startloc)
		playsound(src, 'sound/weapons/laser.ogg', 100, TRUE)
		P.preparePixelProjectile(target, startloc)
		P.firer = src
		P.original = target
		var/set_angle = Get_Angle(src, target)
		P.fire(set_angle)
		if(specialize)
			special = FALSE

/mob/living/simple_animal/hostile/megafauna/rogueprocess/proc/plasmaburst(atom/target, var/specialize = TRUE)
	var/list/theline = get_dist(src, target)
	if(theline > 2)
		if(!target)
			return
		visible_message("<span class='boldwarning'>[src] raises it's tri-shot plasma cutter!</span>")
		if(specialize)
			special = TRUE
		var/ogangle = Get_Angle(src, target)
		sleep(7)
		var/turf/startloc = get_turf(src)
		var/obj/item/projectile/P = new /obj/item/projectile/plasma/rogue(startloc)
		var/turf/otherangle = (ogangle + 45)
		var/turf/otherangle2 = (ogangle - 45)
		playsound(src, 'sound/weapons/laser.ogg', 100, TRUE)
		P.preparePixelProjectile(target, startloc)
		P.firer = src
		P.original = target
		P.fire(ogangle)
		var/obj/item/projectile/X = new /obj/item/projectile/plasma/rogue(startloc)
		playsound(src, 'sound/weapons/laser.ogg', 100, TRUE)
		X.preparePixelProjectile(target, startloc)
		X.firer = src
		X.original = target
		X.fire(otherangle)		
		var/obj/item/projectile/Y = new /obj/item/projectile/plasma/rogue(startloc)
		playsound(src, 'sound/weapons/laser.ogg', 100, TRUE)
		Y.preparePixelProjectile(target, startloc)
		Y.firer = src
		Y.original = target
		Y.fire(otherangle2)
		if(specialize)
			special = FALSE

/mob/living/simple_animal/hostile/megafauna/rogueprocess/proc/knockdown(var/specialize = TRUE)
	visible_message("<span class='boldwarning'>[src] smashes into the ground!</span>")
	if(specialize)
		special = TRUE
	playsound(src,'sound/misc/crunch.ogg', 200, 1)
	var/list/hit_things = list()
	sleep(7)
	for(var/turf/T in oview(2, src))
		if(!T)
			if(specialize)
				special = FALSE
			return
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T.contents)
			if(L != src && !(L in hit_things))
				if(!faction_check(faction, L.faction))
					var/throwtarget = get_edge_target_turf(src, get_dir(src, L))
					L.safe_throw_at(throwtarget, 10, 1, src)
					L.Stun(20)
					L.apply_damage_type(40, BRUTE)
					hit_things += L
	sleep(3)
	if(specialize)
		special = FALSE

/mob/living/simple_animal/hostile/megafauna/rogueprocess/proc/shockwave(direction, range, var/specialize = TRUE)
	visible_message("<span class='boldwarning'>[src] smashes the ground in a general direction!!</span>")
	if(specialize)
		special = TRUE
	playsound(src,'sound/misc/crunch.ogg', 200, 1)
	sleep(5)
	var/list/hit_things = list()
	var/turf/T = get_turf(get_step(src, src.dir))
	var/ogdir = direction
	var/turf/otherT = get_step(T, turn(ogdir, 90))
	var/turf/otherT2 = get_step(T, turn(ogdir, -90))
	if(!T)
		if(specialize)
			special = FALSE
		return
	for(var/i in 1 to range)
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		new /obj/effect/temp_visual/small_smoke/halfsecond(otherT)
		new /obj/effect/temp_visual/small_smoke/halfsecond(otherT2)
		for(var/mob/living/L in T.contents)
			if(L != src && !(L in hit_things))
				var/throwtarget = get_edge_target_turf(T, get_dir(T, L))
				L.safe_throw_at(throwtarget, 5, 1, src)
				L.Stun(10)
				L.apply_damage_type(25, BRUTE)
				hit_things += L
		for(var/mob/living/L in otherT.contents)
			if(L != src && !(L in hit_things))
				var/throwtarget = get_edge_target_turf(otherT, get_dir(otherT, L))
				L.safe_throw_at(throwtarget, 5, 1, src)
				L.Stun(10)
				L.apply_damage_type(25, BRUTE)
				hit_things += L
		for(var/mob/living/L in otherT2.contents)
			if(L != src && !(L in hit_things))
				var/throwtarget = get_edge_target_turf(otherT2, get_dir(otherT2, L))
				L.safe_throw_at(throwtarget, 5, 1, src)
				L.Stun(10)
				L.apply_damage_type(25, BRUTE)
				hit_things += L
		T = get_step(T, ogdir)
		otherT = get_step(otherT, ogdir)
		otherT2 = get_step(otherT2, ogdir)
		sleep(1.5)
	if(specialize)
		special = FALSE

/mob/living/simple_animal/hostile/megafauna/rogueprocess/proc/ultishockwave(range, var/specialize = TRUE)
	visible_message("<span class='boldwarning'>[src] smashes the ground around them!!</span>")
	if(specialize)
		special = TRUE
	playsound(src,'sound/misc/crunch.ogg', 200, 1)
	sleep(10)
	var/list/hit_things = list()
	for(var/i in 1 to range)
		for(var/turf/T in (view(i, src) - view(i - 1, src)))
			if(!T)
				if(specialize)
					special = FALSE
				return
			new /obj/effect/temp_visual/small_smoke/halfsecond(T)
			for(var/mob/living/L in T.contents)
				if(L != src && !(L in hit_things) && !faction_check(L.faction, faction))
					var/throwtarget = get_edge_target_turf(T, get_dir(T, L))
					L.safe_throw_at(throwtarget, 5, 1, src)
					L.Stun(10)
					L.apply_damage_type(25, BRUTE)
					hit_things += L
		sleep(3)
	if(specialize)
		special = FALSE
