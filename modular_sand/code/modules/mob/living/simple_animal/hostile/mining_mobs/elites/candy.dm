#define BLOOD_CHARGE 1
#define BLOODY_TRAP 2
#define MEAT_SHIELD 3
#define KNOCKDOWN 4

/**
  * # Candy
  *
  * Kind of like bubblegum's rebellious teenage son/daughter.
  * Has 4 attacks.
  * Charge - Charges at it's target.
  * Bloody Trap - Traps it's target between some walls, and then charges at them.
  * Meat Shield - Knockbacks all targets in the 3 tiles he faces, and then creates a wall.
  * Knockdown - Deals damage and knockbacks all targets in a 2 tile radius.
  */

/mob/living/simple_animal/hostile/asteroid/elite/candy
	name = "Candy"
	desc = "In what passes as a hierarchy for slaughter demons, this one is prince."
	icon = 'modular_sand/icons/mob/lavaland/lavaland_elites.dmi'
	icon_state = "candy"
	icon_living = "candy"
	icon_aggro = "candy"
	icon_dead = "candy_dead"
	icon_gib = "syndicate_gib"
	maxHealth = 800
	health = 800
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/magic/demon_consume.ogg'
	speed = 1
	move_to_delay = 3
	mouse_opacity = MOUSE_OPACITY_ICON
	deathsound = 'modular_sand/sound/misc/gorenest.ogg'
	deathmessage = " screams in agony, before falling headfirst onto the floor."
	loot_drop = /obj/item/bloodcrawlbottle
	speak_emote = list("gurgle")

	attack_action_types = list(/datum/action/innate/elite_attack/bloodcharge,
								/datum/action/innate/elite_attack/bloody_trap,
								/datum/action/innate/elite_attack/meat_shield,
								/datum/action/innate/elite_attack/knockdown)
	glorymessageshand = list("tries punching Candy's head, but they parry it and grab their hand! However, another hard punch comes through with the other arm, this time killing the demon swiftly and exploding their skull!", "grabs Candy by their neck, then pressures into until it explodes and it's head comes flying off!")
	glorymessagescrusher = list("slashes Candy in half vertically with their crusher, each of the parts falling off onto the ground limply!")
	glorymessagespka = list("shoots at Candy's head, breaking their skull open and revealing their brain! Then, they bash the brain into mush with their PKA's stock!", "kicks Candy into the ground, and repeatedly slams their PKA against their skull until they finally die!")
	glorymessagespkabayonet = list("stabs through Candy's maw and lifts them into the air, shooting their PKA and exploding their head as the limp body falls off!")

/datum/action/innate/elite_attack/bloodcharge
	name = "Blood Charge"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "blood_charge"
	chosen_message = "<span class='boldwarning'>You will attempt to charge your target.</span>"
	chosen_attack_num = BLOOD_CHARGE

/datum/action/innate/elite_attack/bloody_trap
	name = "Bloody Trap"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "bloody_trap"
	chosen_message = "<span class='boldwarning'>You will attempt to trap your target.</span>"
	chosen_attack_num = BLOODY_TRAP

/datum/action/innate/elite_attack/meat_shield
	name = "Meat Shield"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "meat_shield"
	chosen_message = "<span class='boldwarning'>You will attempt to shield yourself.</span>"
	chosen_attack_num = MEAT_SHIELD

/datum/action/innate/elite_attack/knockdown
	name = "Knockdown"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "knockdown"
	chosen_message = "<span class='boldwarning'>You will knock down every mob around you.</span>"
	chosen_attack_num = KNOCKDOWN


/mob/living/simple_animal/hostile/asteroid/elite/candy/OpenFire()
	if(client)
		switch(chosen_attack)
			if(BLOOD_CHARGE)
				bloodcharge(target)
			if(BLOODY_TRAP)
				bloodytrap(target)
			if(MEAT_SHIELD)
				meatshield()
			if(KNOCKDOWN)
				knockdown()
		return
	var/aiattack = rand(1,4)
	switch(aiattack)
		if(BLOOD_CHARGE)
			bloodcharge(target)
		if(BLOODY_TRAP)
			bloodytrap(target)
		if(MEAT_SHIELD)
			meatshield()
		if(KNOCKDOWN)
			knockdown()

// Candy actions
/mob/living/simple_animal/hostile/asteroid/elite/candy/proc/bloodcharge(target)
	ranged_cooldown = world.time + 50
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/turf/T = get_turf(src)
	playsound(src,'sound/magic/demon_attack1.ogg', 200, 1)
	visible_message("<span class='boldwarning'>[src] prepares to charge!</span>")
	for(var/i in 1 to 6)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter/candy(T, get_dir(T, target))
		T = get_step(T, dir_to_target)
		sleep(1)
	addtimer(CALLBACK(src, .proc/blood_charge_2, dir_to_target, 0), 5)

/mob/living/simple_animal/hostile/asteroid/elite/candy/proc/bloodytrap(mob/target)
	playsound(src,'sound/magic/Blind.ogg', 200, 1)
	var/dir_to_target = get_dir(src, target)
	var/turf/T = get_step(src, dir_to_target)
	var/list/bline = getline(T, target.loc)
	if(bline.len > 6)
		return FALSE
	ranged_cooldown = world.time + 100
	visible_message("<span class='boldwarning'>[src] traps [target]!</span>")
	for(var/turf/J in view(1, target) - get_turf(target))
		new /obj/effect/temp_visual/bloodwall(J, src)
	sleep(5)
	src.bloodcharge(target)
	var/list/bloodwalls = list()
	for(var/d in GLOB.cardinals)
		var/turf/N = get_step(target, d)
		if(N == get_step(src, src.dir) || N == get_turf(src))
			continue
		else
			for(var/obj/effect/temp_visual/bloodwall/B in N.contents)
				bloodwalls += B
	var/obj/effect/temp_visual/bloodwall/chosen = pick(bloodwalls)
	visible_message("<span class='boldwarning'>One of the blood walls disappear!</span>")
	qdel(chosen)

/mob/living/simple_animal/hostile/asteroid/elite/candy/proc/meatshield()
	ranged_cooldown = world.time + 25
	playsound(src,'sound/magic/Blind.ogg', 200, 1)
	visible_message("<span class='boldwarning'>[src] raises a wall!</span>")
	var/turf/T = get_turf(get_step(src, src.dir))
	var/list/hit_things = list()
	new /obj/effect/temp_visual/bloodwall(T, src)
	for(var/mob/living/L in T.contents)
		if(L != src && !(L in hit_things))
			var/throwtarget = get_edge_target_turf(src, get_dir(src, L))
			L.safe_throw_at(throwtarget, 10, 1, src)
			L.Stun(20)
			hit_things += L
	var/turf/otherT = get_step(T, turn(src.dir, 90))
	for(var/mob/living/L in otherT.contents)
		if(L != src && !(L in hit_things))
			var/throwtarget = get_edge_target_turf(src, get_dir(src, L))
			L.safe_throw_at(throwtarget, 10, 1, src)
			L.Stun(20)
			hit_things += L
	if(otherT)
		new /obj/effect/temp_visual/bloodwall(otherT, src)
	otherT = get_step(T, turn(src.dir, -90))
	for(var/mob/living/L in otherT.contents)
		if(L != src && !(L in hit_things))
			var/throwtarget = get_edge_target_turf(src, get_dir(src, L))
			L.safe_throw_at(throwtarget, 10, 1, src)
			L.Stun(20)
			hit_things += L
	if(otherT)
		new /obj/effect/temp_visual/bloodwall(otherT, src)

/mob/living/simple_animal/hostile/asteroid/elite/candy/proc/knockdown()
	ranged_cooldown = world.time + 100
	playsound(src,'sound/misc/crunch.ogg', 200, 1)
	visible_message("<span class='boldwarning'>[src] clenches his fists and smashes the ground!</span>")
	var/list/hit_things = list()
	sleep(10)
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T.contents)
			if(L != src && !(L in hit_things))
				var/throwtarget = get_edge_target_turf(src, get_dir(src, L))
				L.safe_throw_at(throwtarget, 10, 1, src)
				L.Stun(20)
				L.adjustBruteLoss(50)
	var/source_turf = src.loc
	sleep(5)
	for(var/turf/T in view(2, source_turf) - view(1, source_turf))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/L in T.contents)
			if(L != src && !(L in hit_things))
				var/throwtarget = get_edge_target_turf(src, get_dir(src, L))
				L.safe_throw_at(throwtarget, 10, 1, src)
				L.Stun(20)
				L.adjustBruteLoss(50)

// Candy helpers

/mob/living/simple_animal/hostile/asteroid/elite/candy/proc/blood_charge_2(var/move_dir, var/times_ran)
	if(times_ran >= 6)
		return
	var/turf/T = get_step(get_turf(src), move_dir)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	if(T.density)
		return
	for(var/obj/structure/window/W in T.contents)
		return
	for(var/obj/machinery/door/D in T.contents)
		return
	forceMove(T)
	playsound(src,'sound/effects/bang.ogg', 200, 1)
	var/list/hit_things = list()
	var/throwtarget = get_edge_target_turf(src, move_dir)
	for(var/mob/living/L in T.contents - hit_things - src)
		if(faction_check_mob(L))
			return
		hit_things += L
		visible_message("<span class='boldwarning'>[src] attacks [L] with much force!</span>")
		to_chat(L, "<span class='userdanger'>[src] grabs you and throws you with much force!</span>")
		L.safe_throw_at(throwtarget, 10, 1, src)
		//L.Paralyze(20)
		L.Stun(20) //substituting this for the Paralyze from the line above, because we don't have tg paralysis stuff
		L.adjustBruteLoss(50)
	addtimer(CALLBACK(src, .proc/blood_charge_2, move_dir, (times_ran + 1)), 2)

/obj/effect/temp_visual/dir_setting/bloodsplatter/candy
	duration = 10
	color = "#FF0000"

/obj/effect/temp_visual/bloodwall
	name = "blood wall"
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult"
	color = "#FF0000"
	duration = 50
	smooth = SMOOTH_TRUE
	var/mob/living/caster

/obj/effect/temp_visual/bloodwall/Initialize(mapload, new_caster)
	. = ..()
	caster = new_caster
	queue_smooth_neighbors(src)
	queue_smooth(src)

/obj/effect/temp_visual/bloodwall/Destroy()
	queue_smooth_neighbors(src)
	return ..()

/obj/effect/temp_visual/bloodwall/CanPass(atom/movable/mover, turf/target)
	if(QDELETED(caster))
		return FALSE
	if(mover == caster.pulledby)
		return TRUE
	if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		if(P.firer == caster)
			return TRUE
	if(mover == caster)
		return TRUE
	return FALSE

//loot

/obj/item/bloodcrawlbottle
	name = "bloodlust in a bottle"
	desc = "Drinking this will give you unimaginable powers... and mildly disgust you because of it's metallic taste."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "vial"

/obj/item/bloodcrawlbottle/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You drink the bottle's contents.</span>")
	var/obj/effect/proc_holder/spell/bloodcrawl/S = new /obj/effect/proc_holder/spell/bloodcrawl/
	user.mind.AddSpell(S)
	user.log_message("learned the spell bloodcrawl ([S])", LOG_ATTACK, color="orange")
	qdel(src)
