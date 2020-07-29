#define MEDAL_PREFIX "Bubblegum"

/*

BUBBLEGUM

Bubblegum spawns randomly wherever a lavaland creature is able to spawn. It is the most powerful slaughter demon in existence.
Bubblegum's footsteps are heralded by shaking booms, proving its tremendous size.

It acts as a melee creature, chasing down and attacking its target while also using different attacks to augment its power that increase as it takes damage.

It often charges, dealing massive damage to anything unfortunate enough to be standing where it's aiming.
Whenever it isn't chasing something down, it will sink into nearby blood pools (if possible) and springs out of the closest one to its target.
To make this possible, it sprays streams of blood at random.
From these blood pools Bubblegum may summon slaughterlings - weak, low-damage minions designed to impede the target's progress.

When Bubblegum dies, it leaves behind a H.E.C.K. suit+helmet as well as a chest that can contain three things:
 1. A spellblade that can slice off limbs at range
 2. A bottle that, when activated, drives everyone nearby into a frenzy
 3. A super double-barrel shotgun that shoots both shells at the same time.

Difficulty: Hard

*/

/mob/living/simple_animal/hostile/megafauna/bubblegum
	name = "bubblegum"
	desc = "In what passes for a hierarchy among slaughter demons, this one is king."
	threat = 35
	health = 2500
	maxHealth = 2500
	attack_verb_continuous = "rends"
	attack_verb_simple = "rend"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	icon_state = "bubblegum"
	icon_living = "bubblegum"
	icon_dead = ""
	friendly_verb_continuous = "stares down"
	friendly_verb_simple = "stare down"
	icon = 'icons/mob/lavaland/96x96megafauna.dmi'
	speak_emote = list("gurgles")
	armour_penetration = 40
	melee_damage_lower = 40
	melee_damage_upper = 40
	faction = list("mining", "boss", "demon")
	speed = 1
	move_to_delay = 10
	ranged_cooldown_time = 10
	ranged = 1
	pixel_x = -32
	gender = MALE
	del_on_death = 1
	crusher_loot = list(/obj/structure/closet/crate/necropolis/bubblegum/crusher)
	loot = list(/obj/structure/closet/crate/necropolis/bubblegum)
	var/charging = 0
	medal_type = BOSS_MEDAL_BUBBLEGUM
	score_type = BUBBLEGUM_SCORE
	deathmessage = "sinks into a pool of blood, fleeing the battle. You've won, for now... "
	death_sound = 'sound/magic/enter_blood.ogg'

	footstep_type = FOOTSTEP_MOB_HEAVY

	var/dont_move //so it wont move in jaunt

	abyss_born = TRUE
	enraged_type = /mob/living/simple_animal/hostile/megafauna/bubblegum/hard
	enrage_message = "starts growing bigger as it feels the energy of Abyss flowing in his veins!"

/obj/item/gps/internal/bubblegum
	icon_state = null
	gpstag = "Bloody Signal"
	desc = "You're not quite sure how a signal can be bloody."
	invisibility = 100

/mob/living/simple_animal/hostile/megafauna/bubblegum/BiologicalLife(seconds, times_fired)
	if(!(. = ..()))
		return
	move_to_delay = clamp(round((health/maxHealth) * 10), 3, 10)

/mob/living/simple_animal/hostile/megafauna/bubblegum/OpenFire()
	anger_modifier = clamp(((maxHealth - health)/50),0,20)
	if(charging || dont_move)
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


/mob/living/simple_animal/hostile/megafauna/bubblegum/Initialize()
	. = ..()
	for(var/mob/living/simple_animal/hostile/megafauna/bubblegum/B in GLOB.mob_list)
		if(B != src)
			return INITIALIZE_HINT_QDEL //There can be only one
	var/obj/effect/proc_holder/spell/bloodcrawl/bloodspell = new
	AddSpell(bloodspell)
	if(istype(loc, /obj/effect/dummy/phased_mob/slaughter))
		bloodspell.phased = TRUE
	internal = new/obj/item/gps/internal/bubblegum(src)

/mob/living/simple_animal/hostile/megafauna/bubblegum/grant_achievement(medaltype,scoretype)
	. = ..()
	if(.)
		SSshuttle.shuttle_purchase_requirements_met |= "bubblegum"

/mob/living/simple_animal/hostile/megafauna/bubblegum/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(charging)
		return
	..()

/mob/living/simple_animal/hostile/megafauna/bubblegum/AttackingTarget()
	if(charging)
		return
	..()

/mob/living/simple_animal/hostile/megafauna/bubblegum/Goto(target, delay, minimum_distance)
	if(charging)
		return
	..()

/mob/living/simple_animal/hostile/megafauna/bubblegum/Move()
	if(dont_move)
		return FALSE
	if(!stat)
		playsound(src.loc, 'sound/effects/meteorimpact.ogg', 200, 1, 2, 1)
	if(charging)
		new/obj/effect/temp_visual/decoy/fading(loc,src)
		DestroySurroundings()
	. = ..()
	if(charging)
		DestroySurroundings()

/mob/living/simple_animal/hostile/megafauna/bubblegum/proc/triple_charge()
	charge()
	sleep(10)
	charge()
	sleep(10)
	charge()

/mob/living/simple_animal/hostile/megafauna/bubblegum/proc/charge()
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


/mob/living/simple_animal/hostile/megafauna/bubblegum/Bump(atom/A)
	if(charging)
		if(isturf(A) || isobj(A) && A.density)
			A.ex_act(EXPLODE_HEAVY)
		DestroySurroundings()
	..()

/mob/living/simple_animal/hostile/megafauna/bubblegum/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!charging)
		return ..()

	else if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.visible_message("<span class='danger'>[src] slams into [L]!</span>", "<span class='userdanger'>[src] slams into you!</span>")
		L.apply_damage(40, BRUTE)
		playsound(get_turf(L), 'sound/effects/meteorimpact.ogg', 100, 1)
		shake_camera(L, 4, 3)
		shake_camera(src, 2, 3)
		var/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
		L.throw_at(throwtarget, 3)

	charging = 0


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

/mob/living/simple_animal/hostile/megafauna/bubblegum/proc/blood_warp()
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




/mob/living/simple_animal/hostile/megafauna/bubblegum/proc/blood_spray()
	visible_message("<span class='danger'>[src] sprays a stream of gore!</span>")
	var/turf/E = get_edge_target_turf(src, src.dir)
	var/range = 10
	var/turf/previousturf = get_turf(src)
	for(var/turf/J in getline(src,E))
		if(!range)
			break
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(previousturf, get_dir(previousturf, J))
		if(!previousturf.CanAtmosPass(J))
			break
		playsound(J,'sound/effects/splat.ogg', 100, 1, -1)
		new /obj/effect/decal/cleanable/blood(J)
		range--
		previousturf = J
		sleep(1)

#undef MEDAL_PREFIX
