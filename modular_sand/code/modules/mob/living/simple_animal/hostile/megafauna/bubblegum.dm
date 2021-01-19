#define MEDAL_PREFIX "Bubblegum"

/*

BUBBLEGUM

Removes slaughterlings (because they are bullshit), instead replacing them with the blood rending thing from tg

*/

/mob/living/simple_animal/hostile/megafauna/bubblegum
	death_sound = 'modular_sand/sound/misc/gorenest.ogg' //fuck it
	var/movesound = 'sound/effects/meteorimpact.ogg'
	songs = list("1860" = sound(file = 'modular_sand/sound/ambience/bfgdivision.ogg', repeat = 0, wait = 0, volume = 70, channel = CHANNEL_JUKEBOX), "2070" = sound(file = 'modular_sand/sound/ambience/theonlythingtheyfearisyou.ogg', repeat = 0, wait = 0, volume = 70, channel = CHANNEL_JUKEBOX)) //Thanks Mr. Infringio!
	glorymessageshand = list("grabs bubblegum by the leg, and pulls them down! While downed, they climb on their torso and punch through it, smashing their demonic heart!", "goes around bubblegum and climbs them by their back, once on top of their head they punch right through the demon's skull, ripping out brain matter and killing it as it limply falls on the ground!")
	glorymessagescrusher = list("jumps and chops off both of bubblegum's legs in one swift move with their crusher! To finish off the now wheelchair-bound demon, they chop at the torso vertically, getting the crusher stuck in the process but killing the demonic fiend!", "goes around bubblegum and climbs them by their back, once on the top they chop their head off with the crusher!")
	glorymessagespka = list("shoots the weakened demon in the chest, opening a hole and exposing their inner core! With another blast, the demon's heart explodes, and they fall dead and limp on the ground!", "shoots the weakened demon's head, stunning them and revealing their brain! Another PKA blast finishes off what little brainmatter they had!")
	glorymessagespkabayonet = list("shoots the weakened demon in the chest, opening a hole and exposing their inner core! They run onto the now exposed heart and stab it repeatedly with their bayonet, killing the demon off!")
	footstep_type = FOOTSTEP_MOB_HEAVY
	var/dont_move = TRUE //impedes bubbles from moving while using the blood jaunt


/mob/living/simple_animal/hostile/megafauna/bubblegum/Move()
	. = ..()
	if(dont_move)
		return FALSE
	playsound(src, movesound, 200, TRUE, 2, TRUE)

/mob/living/simple_animal/hostile/megafauna/bubblegum/OpenFire()
	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	if(charging)
		return
	ranged_cooldown = world.time + ranged_cooldown_time
	blood_warp()
	bloodsmacks()
	if(prob(25))
		INVOKE_ASYNC(src, .proc/blood_spray)
		INVOKE_ASYNC(src, .proc/bloodsmacks)
	else
		if(health > maxHealth/2 && !client)
			INVOKE_ASYNC(src, .proc/charge)
		else
			INVOKE_ASYNC(src, .proc/triple_charge)

/mob/living/simple_animal/hostile/megafauna/bubblegum/charge()
	bloodsmacks()
	var/turf/T = get_turf(target)
	if(!T || T == loc)
		return
	new /obj/effect/temp_visual/dragon_swoop(T)
	charging = 1
	DestroySurroundings()
	walk(src, 0)
	setDir(get_dir(src, T))
	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc,src)
	animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 5)
	sleep(5)
	throw_at(T, get_dist(src, T), 1, src, 0)
	charging = 0
	Goto(target, move_to_delay, minimum_distance)
	bloodsmacks()

/mob/living/simple_animal/hostile/megafauna/bubblegum/proc/bloodsmacks()
	for(var/obj/effect/decal/cleanable/blood/B in view(7, src))
		var/turf/T = get_turf(B)
		var/mobcount = 0
		for(var/mob/living/L in T.contents)
			if(L != src)
				mobcount++
		if(mobcount)
			var/hand = rand(0,1)
			INVOKE_ASYNC(src, .proc/bloodsmack, T, hand)

/mob/living/simple_animal/hostile/megafauna/bubblegum/proc/bloodsmack(turf/T, handedness)
	if(handedness)
		new /obj/effect/temp_visual/bubblegum_hands/rightsmack(T)
	else
		new /obj/effect/temp_visual/bubblegum_hands/leftsmack(T)
	sleep(5)
	for(var/mob/living/L in T)
		if(!faction_check_mob(L))
			to_chat(L, "<span class='userdanger'>[src] rends you!</span>")
			playsound(T, attack_sound, 100, TRUE, -1)
			var/limb_to_hit = L.get_bodypart(pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
			L.apply_damage(30, BRUTE, limb_to_hit, L.run_armor_check(limb_to_hit, "melee", null, null)) // You really, really, really better not stand in blood!
	sleep(3)

/mob/living/simple_animal/hostile/megafauna/bubblegum/blood_warp()
	var/obj/effect/decal/cleanable/blood/found_bloodpool
	var/list/pools = list()
	var/can_jaunt = FALSE
	for(var/obj/effect/decal/cleanable/blood/nearby in view(src,2))
		if(nearby.bloodiness >= 20)
			can_jaunt = TRUE
		break
	if(!can_jaunt)
		return
	for(var/obj/effect/decal/cleanable/blood/nearby in view(get_turf(target),2))
		if(nearby.bloodiness >= 20)
			pools += nearby
	if(pools.len)
		shuffle_inplace(pools)
		found_bloodpool = pick(pools)
	if(found_bloodpool)
		visible_message("<span class='danger'>[src] sinks into the blood...</span>")
		playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 100, 1, -1)
		alpha = 0
		dont_move = TRUE
		sleep(rand(2, 4))
		forceMove(get_turf(found_bloodpool))
		playsound(get_turf(src), 'sound/magic/exit_blood.ogg', 100, 1, -1)
		alpha = 100
		dont_move = FALSE
		visible_message("<span class='danger'>And springs back out!</span>")


/obj/effect/temp_visual/bubblegum_hands
	icon = 'icons/effects/bubblegum.dmi'
	duration = 9

/obj/effect/temp_visual/bubblegum_hands/rightthumb
	icon_state = "rightthumbgrab"

/obj/effect/temp_visual/bubblegum_hands/leftthumb
	icon_state = "leftthumbgrab"

/obj/effect/temp_visual/bubblegum_hands/rightpaw
	icon_state = "rightpawgrab"
	layer = BELOW_MOB_LAYER

/obj/effect/temp_visual/bubblegum_hands/leftpaw
	icon_state = "leftpawgrab"
	layer = BELOW_MOB_LAYER

/obj/effect/temp_visual/bubblegum_hands/rightsmack
	icon_state = "rightsmack"

/obj/effect/temp_visual/bubblegum_hands/leftsmack
	icon_state = "leftsmack"

#undef MEDAL_PREFIX
