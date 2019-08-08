/*

The Hierophant

The Hierophant spawns in its arena, which makes fighting it challenging but not impossible.

The text this boss speaks is ROT4, use ROT22 to decode

The Hierophant's attacks are as follows;
- These attacks happen at a random, increasing chance:
	If target is at least 2 tiles away; Blinks to the target after a very brief delay, damaging everything near the start and end points.
		As above, but does so multiple times if below half health.
	Rapidly creates cardinal and diagonal Cross Blasts under a target.
	If chasers are off cooldown, creates 4 chasers.

- IF TARGET IS OUTSIDE THE ARENA: Creates an arena around the target for 10 seconds, blinking to the target if not in the created arena.
	The arena has a 20 second cooldown, giving people a small window to get the fuck out.

- If no chasers exist, creates a chaser that will seek its target, leaving a trail of blasts.
	Is more likely to create a second, slower, chaser if hurt.
- If the target is at least 2 tiles away, may Blink to the target after a very brief delay, damaging everything near the start and end points.
- Creates a cardinal or diagonal blast(Cross Blast) under its target, exploding after a short time.
	If below half health, the created Cross Blast may fire in all directions.
- Creates an expanding AoE burst.

- IF ATTACKING IN MELEE: Creates an expanding AoE burst.

Cross Blasts and the AoE burst gain additional range as Hierophant loses health, while Chasers gain additional speed.

When Hierophant dies, it stops trying to murder you and shrinks into a small form, which, while much weaker, is still quite effective.
- The smaller club can place a teleport beacon, allowing the user to teleport themself and their allies to the beacon.

Difficulty: Hard

*/

#define HIEROPHANT_STAGE_ONE		1
#define HIEROPHANT_STAGE_TWO		2
#define HIEROPHANT_STAGE_THREE		3
#define HIEROPHANT_STAGE_FOUR		4
#define HIEROPHANT_STAGE_FIVE		5

#define HIEROPHANT_RAGE_BLASTSPAM		1
#define HIEROPHANT_RAGE_BLINKSPAM		2
#define HIEROPHANT_RAGE_CHASERSPAM		3

/mob/living/simple_animal/hostile/megafauna/hierophant
	name = "hierophant"
	desc = "A massive metal club that hangs in the air as though waiting. It'll make you dance to its beat."
	health = 2500
	maxHealth = 2500
	attacktext = "clubs"
	attack_sound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "hierophant"
	icon_living = "hierophant"
	friendly = "stares down"
	icon = 'icons/mob/lavaland/hierophant_new.dmi'
	faction = list("boss") //asteroid mobs? get that shit out of my beautiful square house
	speak_emote = list("preaches")
	armour_penetration = 75
	melee_damage_lower = 15
	melee_damage_upper = 20
	speed = 1
	move_to_delay = 5
	ranged = 1
	ranged_cooldown_time = 40
	aggro_vision_range = 21 //so it can see to one side of the arena to the other
	loot = list(/obj/item/hierophant_club)
	crusher_loot = list(/obj/item/hierophant_club)
	wander = FALSE
	medal_type = BOSS_MEDAL_HIEROPHANT
	score_type = HIEROPHANT_SCORE
	del_on_death = TRUE
	death_sound = 'sound/magic/repulse.ogg'

	var/stage = HIEROPHANT_STAGE_ONE
	var/blast_damage = 10
	var/max_chasers = 1
	var/max_enraged_chasrs = 2
	var/blast_range = 5
	var/burst_range = 3
	var/burst_on_blink = FALSE
	var/did_reset = TRUE //if we timed out, returned to our beacon, and healed some

	var/anger_modifier = 0		//ho nagry we are



	var/burst_range = 3 //range on burst aoe
	var/beam_range = 5 //range on cross blast beams
	var/chaser_speed = 2 //how fast chasers are currently
	var/chaser_cooldown = 50 //base cooldown/cooldown var between spawning chasers
	var/major_attack_cooldown = 40 //base cooldown for major attacks
	var/arena_cooldown = 200 //base cooldown/cooldown var for creating an arena
	var/blinking = FALSE //if we're doing something that requires us to stand still and not attack
	var/obj/effect/hierophant/spawned_beacon //the beacon we teleport back to
	var/timeout_time = 15 //after this many Life() ticks with no target, we return to our beacon
	var/list/kill_phrases = list("Wsyvgi sj irivkc xettih. Vitemvmrk...", "Irivkc wsyvgi jsyrh. Vitemvmrk...", "Jyip jsyrh. Egxmzexmrk vitemv gcgpiw...", "Kix fiex. Liepmrk...")
	var/list/target_phrases = list("Xevkix psgexih.", "Iriqc jsyrh.", "Eguymvih xevkix.")

/mob/living/simple_animal/hostile/megafauna/hierophant/Initialize()
	. = ..()
	internal = new/obj/item/gps/internal/hierophant(src)
	spawned_beacon = new(loc)
	AddComponent(/datum/component/vortex_magic, src)

/mob/living/simple_animal/hostile/megafauna/hierophant/spawn_crusher_loot()
	new /obj/item/crusher_trophy/vortex_talisman(get_turf(spawned_beacon))

/mob/living/simple_animal/hostile/megafauna/hierophant/Life()
	. = ..()
	if(. && spawned_beacon && !QDELETED(spawned_beacon) && !client)
		if(target || loc == spawned_beacon.loc)
			timeout_time = initial(timeout_time)
		else
			timeout_time--
		if(timeout_time <= 0 && !did_reset)
			did_reset = TRUE
			visible_message("<span class='hierophant_warning'>\"Vixyvrmrk xs fewi...\"</span>")
			blink(spawned_beacon)
			adjustHealth(min((health - maxHealth) * 0.5, -250)) //heal for 50% of our missing health, minimum 10% of maximum health
			wander = FALSE
			if(health > maxHealth * 0.9)
				visible_message("<span class='hierophant'>\"Vitemvw gsqtpixi. Stivexmrk ex qebmqyq ijjmgmirgc.\"</span>")
			else
				visible_message("<span class='hierophant'>\"Vitemvw gsqtpixi. Stivexmsrep ijjmgmirgc gsqtvsqmwih.\"</span>")

/mob/living/simple_animal/hostile/megafauna/hierophant/death()
	if(health > 0 || stat == DEAD)
		return
	else
		stat = DEAD
		blinking = TRUE //we do a fancy animation, release a huge burst(), and leave our staff.
		burst_range = 20
		visible_message("<span class='hierophant'>\"Mrmxmexmrk wipj-hiwxvygx wiuyirgi...\"</span>")
		visible_message("<span class='hierophant_warning'>[src] shrinks, releasing a massive burst of energy!</span>")
		burst(get_turf(src))
		..()

/mob/living/simple_animal/hostile/megafauna/hierophant/Destroy()
	qdel(spawned_beacon)
	. = ..()

/mob/living/simple_animal/hostile/megafauna/hierophant/devour(mob/living/L)
	for(var/obj/item/W in L)
		if(!L.dropItemToGround(W))
			qdel(W)
	visible_message("<span class='hierophant_warning'>\"[pick(kill_phrases)]\"</span>")
	visible_message("<span class='hierophant_warning'>[src] annihilates [L]!</span>","<span class='userdanger'>You annihilate [L], restoring your health!</span>")
	adjustHealth(-L.maxHealth*0.5)
	L.dust()

/mob/living/simple_animal/hostile/megafauna/hierophant/CanAttack(atom/the_target)
	. = ..()
	if(istype(the_target, /mob/living/simple_animal/hostile/asteroid/hivelordbrood)) //ignore temporary targets in favor of more permanent targets
		return FALSE

/mob/living/simple_animal/hostile/megafauna/hierophant/GiveTarget(new_target)
	var/targets_the_same = (new_target == target)
	. = ..()
	if(. && target && !targets_the_same)
		visible_message("<span class='hierophant_warning'>\"[pick(target_phrases)]\"</span>")
		if(spawned_beacon && loc == spawned_beacon.loc && did_reset)
			arena_trap(src)

/mob/living/simple_animal/hostile/megafauna/hierophant/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(src && . > 0 && !blinking)
		wander = TRUE
		did_reset = FALSE

/mob/living/simple_animal/hostile/megafauna/hierophant/AttackingTarget()
	if(!blinking)
		if(target && isliving(target))
			var/mob/living/L = target
			if(L.stat != DEAD)
				if(ranged_cooldown <= world.time)
					calculate_rage()
					ranged_cooldown = world.time + max(5, ranged_cooldown_time - anger_modifier * 0.75)
					INVOKE_ASYNC(src, .proc/burst, get_turf(src))
				else
					burst_range = 3
					INVOKE_ASYNC(src, .proc/burst, get_turf(src), 0.25) //melee attacks on living mobs cause it to release a fast burst if on cooldown
			else
				devour(L)
		else
			return ..()

/mob/living/simple_animal/hostile/megafauna/hierophant/DestroySurroundings()
	if(!blinking)
		..()

/mob/living/simple_animal/hostile/megafauna/hierophant/Move()
	if(!blinking)
		. = ..()

/mob/living/simple_animal/hostile/megafauna/hierophant/Moved(oldLoc, movement_dir)
	. = ..()
	if(!stat && .)
		var/obj/effect/temp_visual/hierophant/squares/HS = new(oldLoc)
		HS.setDir(movement_dir)
		playsound(src, 'sound/mecha/mechmove04.ogg', 150, 1, -4)
		if(target)
			arena_trap(target)

/mob/living/simple_animal/hostile/megafauna/hierophant/Goto(target, delay, minimum_distance)
	wander = TRUE
	if(!blinking)
		..()

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/calculate_stage() //how angry we are overall
	did_reset = FALSE //oh hey we're doing SOMETHING, clearly we might need to heal if we recall
	stage = CEILING((maxHealth - health) / 500, 1)
	switch(stage)
		if(HIEROPHANT_STAGE_ONE)
			max_tracers = 1
			max_enraged_chasers = 2
			burst_range = 3
			beam_range = 5
		if(HIEROPHANT_STAGE_TWO)
			max_tracers = 2
			max_enraged_chasers = 3
			burst_range = 5
			beam_range = 7
		if(HIEROPHANT_STAGE_THREE)
			max_tracers = 3
			max_enraged_chasers = 4
			burst_range = 6
			beam_range = 9
		if(HIEROPHANT_STAGE_FOUR)
			max_tracers = 3
			max_enraged_chasers = 3
			burst_range = 7
			beam_range = 11
		if(HIEROPHANT_STAGE_FIVE)
			max_tracers = 3
			max_enraged_chasers = 5
			burst_range = 8
			beam_range = 15

	anger_modifier = CLAMP(((maxHealth - health) / 42),0,50)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/process_stage()
	switch(stage)
		if(HIEROPHANT_STAGE_ONE)

		if(HIEROPHANT_STAGE_TWO)

		if(HIEROPHANT_STAGE_THREE)

		if(HIEROPHANT_STAGE_FOUR)

		if(HIEROPHANT_STAGE_FIVE)


/mob/living/simple_animal/hostile/megafauna/hierophant/proc/enrage(mob/victim)


/mob/living/simple_animal/hostile/megafauna/hierophant/OpenFire()
	calculate_rage()
	if(blinking)
		return

	var/target_slowness = 0
	if(isliving(target))
		var/mob/living/L = target
		if(!blinking && L.stat == DEAD && get_dist(src, L) > 2)
			blink(L)
			return
		target_slowness += L.movement_delay()
	target_slowness = max(target_slowness, 1)
	chaser_speed = max(1, (2 - anger_modifier * 0.04) + ((target_slowness - 1) * 0.5))

	arena_trap(target)
	ranged_cooldown = world.time + max(5, ranged_cooldown_time - anger_modifier * 0.75) //scale cooldown lower with high anger.

	if(prob(anger_modifier * 0.75)) //major ranged attack
		var/list/possibilities = list()
		var/cross_counter = 1 + round(anger_modifier * 0.12)
		if(cross_counter > 1)
			possibilities += "cross_blast_spam"
		if(get_dist(src, target) > 2)
			possibilities += "blink_spam"
		if(chaser_cooldown < world.time)
			if(prob(anger_modifier * 2))
				possibilities = list("chaser_swarm")
			else
				possibilities += "chaser_swarm"
		if(possibilities.len)
			ranged_cooldown = world.time + max(5, major_attack_cooldown - anger_modifier * 0.75) //we didn't cancel out of an attack, use the higher cooldown
			var/blink_counter = 1 + round(anger_modifier * 0.08)
			switch(pick(possibilities))
				if("blink_spam") //blink either once or multiple times.
					if(health < maxHealth * 0.5 && blink_counter > 1)
						visible_message("<span class='hierophant'>\"Mx ampp rsx iwgeti.\"</span>")
						var/oldcolor = color
						animate(src, color = "#660099", time = 6)
						sleep(6)
						while(health && !QDELETED(target) && blink_counter)
							if(loc == target.loc || loc == target) //we're on the same tile as them after about a second we can stop now
								break
							blink_counter--
							blinking = FALSE
							blink(target)
							blinking = TRUE
							sleep(4 + target_slowness)
						animate(src, color = oldcolor, time = 8)
						addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)
						sleep(8)
						blinking = FALSE
					else
						blink(target)
				if("cross_blast_spam") //fire a lot of cross blasts at a target.
					visible_message("<span class='hierophant'>\"Piezi mx rsalivi xs vyr.\"</span>")
					blinking = TRUE
					var/oldcolor = color
					animate(src, color = "#660099", time = 6)
					sleep(6)
					while(health && !QDELETED(target) && cross_counter)
						cross_counter--
						if(prob(60))
							INVOKE_ASYNC(src, .proc/cardinal_blasts, target)
						else
							INVOKE_ASYNC(src, .proc/diagonal_blasts, target)
						sleep(6 + target_slowness)
					animate(src, color = oldcolor, time = 8)
					addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)
					sleep(8)
					blinking = FALSE
				if("chaser_swarm") //fire four fucking chasers at a target and their friends.
					visible_message("<span class='hierophant'>\"Mx gerrsx lmhi.\"</span>")
					blinking = TRUE
					var/oldcolor = color
					animate(src, color = "#660099", time = 6)
					sleep(6)
					var/list/targets = ListTargets()
					var/list/cardinal_copy = GLOB.cardinals.Copy()
					while(health && targets.len && cardinal_copy.len)
						var/mob/living/pickedtarget = pick(targets)
						if(targets.len >= cardinal_copy.len)
							pickedtarget = pick_n_take(targets)
						if(!istype(pickedtarget) || pickedtarget.stat == DEAD)
							pickedtarget = target
							if(QDELETED(pickedtarget) || (istype(pickedtarget) && pickedtarget.stat == DEAD))
								break //main target is dead and we're out of living targets, cancel out
						var/obj/effect/temp_visual/hierophant/chaser/C = new(loc, src, pickedtarget, chaser_speed, FALSE)
						C.moving = 3
						C.moving_dir = pick_n_take(cardinal_copy)
						sleep(8 + target_slowness)
					chaser_cooldown = world.time + initial(chaser_cooldown)
					animate(src, color = oldcolor, time = 8)
					addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)
					sleep(8)
					blinking = FALSE
			return


	if(chaser_cooldown < world.time) //if chasers are off cooldown, fire some!
		var/obj/effect/temp_visual/hierophant/chaser/C = new /obj/effect/temp_visual/hierophant/chaser(loc, src, target, chaser_speed, FALSE)
		chaser_cooldown = world.time + initial(chaser_cooldown)
		if((prob(anger_modifier) || target.Adjacent(src)) && target != src)
			var/obj/effect/temp_visual/hierophant/chaser/OC = new(loc, src, target, chaser_speed * 1.5, FALSE)
			OC.moving = 4
			OC.moving_dir = pick(GLOB.cardinals - C.moving_dir)





chaser(turf/source, atom/target, duration = 100, damage = 10, bonus_mob_damage = 10, speed = 2, diagonals = FALSE, tiles_before_recalculation = 4, tiles_per_step = 1, initial_dir, initial_move_dist)








	else if(prob(10 + (anger_modifier * 0.5)) && get_dist(src, target) > 2)
		blink(target)

	else if(prob(70 - anger_modifier)) //a cross blast of some type
		if(prob(anger_modifier * (2 / target_slowness)) && health < maxHealth * 0.5) //we're super angry do it at all dirs
			INVOKE_ASYNC(src, .proc/alldir_blasts, target)
		else if(prob(60))
			INVOKE_ASYNC(src, .proc/cardinal_blasts, target)
		else
			INVOKE_ASYNC(src, .proc/diagonal_blasts, target)
	else //just release a burst of power
		INVOKE_ASYNC(src, .proc/burst, get_turf(src))


/mob/living/simple_animal/hostile/megafauna/hierophant/proc/diagonal_blasts(mob/victim) //fire diagonal cross blasts with a delay
	var/turf/T = get_turf(victim)
	if(!T)
		return
	new /obj/effect/temp_visual/hierophant/telegraph/diagonal(T, src)
	playsound(T,'sound/effects/bin_close.ogg', 200, 1)
	sleep(2)
	SEND_SIGNAL(src, COMSIG_VORTEXMAGIC_BLAST, T, NORTHEAST|NORTHWEST|SOUTHEAST|SOUTHWEST, blast_damage, blast_damage)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/cardinal_blasts(mob/victim) //fire cardinal cross blasts with a delay
	var/turf/T = get_turf(victim)
	if(!T)
		return
	new /obj/effect/temp_visual/hierophant/telegraph/cardinal(T, src)
	playsound(T,'sound/effects/bin_close.ogg', 200, 1)
	sleep(2)
	SEND_SIGNAL(src, COMSIG_VORTEXMAGIC_BLAST, T, NORTH|SOUTH|EAST|WEST, blast_damage, blast_damage)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/alldir_blasts(mob/victim) //fire alldir cross blasts with a delay
	var/turf/T = get_turf(victim)
	if(!T)
		return
	new /obj/effect/temp_visual/hierophant/telegraph(T, src)
	playsound(T,'sound/effects/bin_close.ogg', 200, 1)
	sleep(2)
	SEND_SIGNAL(src, COMSIG_VORTEXMAGIC_BLAST, T, NORTH|SOUTH|EAST|WEST|NORTHEAST|NORTHWEST|SOUTHEAST|SOUTHWEST, blast_damage, blast_damage)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/burst(turf/original, spread_speed = 0.5) //release a wave of blasts
	SEND_SIGNAL(src, COMSIG_VORTEXMAGIC_BURST, original, burst_range, null, null, spread_speed, blast_damage, blast_damage)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/melee_blast(mob/victim) //make a 3x3 blast around a target
	var/turf/T = get_turf(victim)
	if(!T)
		return
	new /obj/effect/temp_visual/hierophant/telegraph(T, src)
	playsound(T,'sound/effects/bin_close.ogg', 200, 1)
	sleep(2)
	SEND_SIGNAL(src, COMSIG_VORTEXMAGIC_BURST, T, 2, 0, 0, 0, blast_damage, blast_damage)

/mob/living/simple_animal/hostile/megafauna/hierophant/AltClickOn(atom/A) //player control handler(don't give this to a player holy fuck)
	if(!istype(A) || get_dist(A, src) <= 2)
		return
	blink(A)

/obj/item/gps/internal/hierophant
	icon_state = null
	gpstag = "Zealous Signal"
	desc = "Heed its words."
	invisibility = 100





/mob/living/simple_animal/hostile/megafauna/hierophant/proc/arena_trap(mob/victim) //trap a target in an arena
	var/turf/T = get_turf(victim)
	if(!istype(victim) || victim.stat == DEAD || !T || arena_cooldown > world.time)
		return
	if((istype(get_area(T), /area/ruin/unpowered/hierophant) || istype(get_area(src), /area/ruin/unpowered/hierophant)) && victim != src)
		return
	arena_cooldown = world.time + initial(arena_cooldown)
	for(var/d in GLOB.cardinals)
		INVOKE_ASYNC(src, .proc/arena_squares, T, d)
	for(var/t in RANGE_TURFS(11, T))
		if(t && get_dist(t, T) == 11)
			new /obj/effect/temp_visual/hierophant/wall(t, src)
			new /obj/effect/temp_visual/hierophant/blast(t, src, FALSE)
	if(get_dist(src, T) >= 11) //hey you're out of range I need to get closer to you!
		INVOKE_ASYNC(src, .proc/blink, T)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/arena_squares(turf/T, set_dir) //make a fancy effect extending from the arena target
	var/turf/previousturf = T
	var/turf/J = get_step(previousturf, set_dir)
	for(var/i in 1 to 10)
		var/obj/effect/temp_visual/hierophant/squares/HS = new(J)
		HS.setDir(set_dir)
		previousturf = J
		J = get_step(previousturf, set_dir)
		sleep(0.5)

/mob/living/simple_animal/hostile/megafauna/hierophant/proc/blink(mob/victim) //blink to a target
	SEND_SIGNAL(src, COMSIG_VORTEXMAGIC_USERBLINK, get_turf(victim), TRUE, 1, FALSE, 2, 30, 80, burst_on_blink? CALLBACK(src, .proc/burst, get_turf(victim)): NONE)
