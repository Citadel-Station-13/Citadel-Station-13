/mob/living/simple_animal/hostile/megafauna/bubblegum/hard
	name = "enraged bubblegum"
	desc = "In what passes for a hierarchy among slaughter demons, this one is king. It looks VERY enraged!"
	threat = 50
	health = 3000
	maxHealth = 3000
	armour_penetration = 60
	melee_damage_lower = 45
	melee_damage_upper = 45
	speed = 0.5 //A bit faster
	ranged_cooldown_time = 8 //Less cooldown
	crusher_loot = list(/obj/structure/closet/crate/necropolis/bubblegum/hard/crusher)
	loot = list(/obj/structure/closet/crate/necropolis/bubblegum/hard)

	var/imps = 0
	abyss_born = FALSE

/mob/living/simple_animal/hostile/megafauna/bubblegum/hard/proc/summon_imps()
	if(imps)
		return

	imps = 0
	for(var/obj/effect/decal/cleanable/blood/H in range(src, 7))
		if(prob(15))
			var/mob/living/simple_animal/hostile/imp/imp = new(H.loc)
			imp.origin = src
			imps += 1

	if(imps)
		new /obj/effect/decal/cleanable/blood(get_turf(src))
		playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 100, 1, -1)
		invisibility = 100
		dont_move = TRUE

		visible_message("<span class='danger'>[src] summons a shoal of imps, sinking into the blood!</span>")

/mob/living/simple_animal/hostile/megafauna/bubblegum/hard/OpenFire()
	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	if(charging || dont_move)
		return
	ranged_cooldown = world.time + ranged_cooldown_time
	blood_warp()
	bloodsmacks()
	if(prob(25))
		INVOKE_ASYNC(src, .proc/summon_imps)
		return
	if(prob(25))
		INVOKE_ASYNC(src, .proc/blood_spray)
		INVOKE_ASYNC(src, .proc/bloodsmacks)
	else
		if(health > maxHealth/2 && !client)
			INVOKE_ASYNC(src, .proc/charge)
		else
			INVOKE_ASYNC(src, .proc/triple_charge)

/mob/living/simple_animal/hostile/megafauna/bubblegum/hard/blood_spray()
	visible_message("<span class='danger'>[src] sprays a shower of gore around himself!</span>")
	for(var/turf/open/J in view(5, src)) //Hehe
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(J, get_dir(src, J))
		playsound(J,'sound/effects/splat.ogg', 100, 1, -1)
		new /obj/effect/decal/cleanable/blood(J)

/mob/living/simple_animal/hostile/megafauna/bubblegum/hard/Bump(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		L.visible_message("<span class='danger'>[src] slams into [L]!</span>", "<span class='userdanger'>[src] slams into you!</span>")
		L.apply_damage(40, BRUTE)
		playsound(get_turf(L), 'sound/effects/meteorimpact.ogg', 100, 1)
		shake_camera(L, 4, 3)
		shake_camera(src, 2, 3)
		var/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
		L.throw_at(throwtarget, 3)
	. = ..()

/mob/living/simple_animal/hostile/megafauna/bubblegum/hard/proc/imp_death()
	imps -= 1

	if(!imps)
		playsound(get_turf(src), 'sound/magic/exit_blood.ogg', 100, 1, -1)
		invisibility = initial(invisibility)
		dont_move = FALSE
		visible_message("<span class='danger'>[src] rises from the ground as the last imp dies!</span>")

/mob/living/simple_animal/hostile/imp
	name = "imp"
	desc = "A large, menacing creature covered in armored black scales."
	speak_emote = list("cackles")
	emote_hear = list("cackles","screeches")
	response_help_continuous = "thinks better of touching"
	response_help_simple = "think better of touching"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	icon = 'icons/mob/mob.dmi'
	icon_state = "imp"
	icon_living = "imp"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speed = 1
	a_intent = INTENT_HARM
	stop_automated_movement = 1
	status_flags = CANPUSH
	attack_sound = 'sound/magic/demon_attack1.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 250 //Weak to cold
	maxbodytemp = INFINITY
	faction = list("mining", "boss", "demon")
	attack_verb_continuous = "wildly tears into"
	attack_verb_simple = "wildly tear into"
	maxHealth = 50
	health = 50
	healable = 0
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 40
	melee_damage_lower = 10
	melee_damage_upper = 10
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	var/boost = 0

	var/mob/living/simple_animal/hostile/megafauna/bubblegum/hard/origin

/mob/living/simple_animal/hostile/imp/Initialize()
	..()
	boost = world.time + 30

/mob/living/simple_animal/hostile/imp/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	if(boost<world.time)
		speed = 1
	else
		speed = 0

/mob/living/simple_animal/hostile/imp/death()
	..(1)
	playsound(get_turf(src),'sound/magic/demon_dies.ogg', 200, 1)
	visible_message("<span class='danger'>[src] screams in agony as it sublimates into a sulfurous smoke.</span>")
	if(origin)
		origin.imp_death()
	qdel(src)