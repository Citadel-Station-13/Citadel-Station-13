#define AXE_SLAM 1
#define SUMMON_SHAMBLER 2
#define DASH 3
#define AXE_THROW 4

/**
  * # Necropolis priest
  *
  * Kind of like BD miner's son trying to impress their dad.
  * Has four attacks.
  * - Axe Slam - Slams his axe on the ground, hurting everyone is his direction in a 3 tile radius
  * - Summon Shambler - Summons a shambling miner that focuses on the target.
  * - Dash - Dashes in the target's general direction
  * - Axe Throw - Throws an axe at the target
  */

/mob/living/simple_animal/hostile/asteroid/elite/minerpriest
	name = "Necropolis Priest"
	desc = "Once used to be a miner, now a worshipper of the necropolis."
	icon = 'modular_sand/icons/mob/lavaland/lavaland_elites.dmi'
	icon_state = "minerpriest"
	icon_living = "minerpriest"
	icon_aggro = "minerpriest"
	icon_dead = "minerpriest_dead"
	icon_gib = "syndicate_gib"
	maxHealth = 800
	health = 800
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	speed = 1
	move_to_delay = 2
	mouse_opacity = MOUSE_OPACITY_ICON
	deathsound = 'sound/voice/human/manlaugh1.ogg'
	deathmessage = "realizes what they've been doing all this time, and return to their true self."
	loot_drop = /obj/item/melee/diamondaxe
	speak_emote = list("yells")
	del_on_death = TRUE
	projectiletype = /obj/item/projectile/kinetic/axe
	attack_action_types = list(/datum/action/innate/elite_attack/axe_slam,
								/datum/action/innate/elite_attack/summon_shambler,
								/datum/action/innate/elite_attack/dash,
								/datum/action/innate/elite_attack/axe_throw)
	glorymessageshand = list("grabs the priest's arm and breaks it, exposing sharp bone which is promptly shoved inside their skull!", "punches into the priest's guts, ripping off their stomach and whatever else was inside!")
	glorymessagescrusher = list("chops the priest's leg off with their crusher, then uses it to beat their skull open while they're downed!")
	glorymessagespka = list("shoots at the priest's hand, exploding it and making them let go of their axe, which is promptly grabbed and slashes their neck open!", "kicks the priest on the ground, then shoots their guts and viscera off with a PKA blast to the chest!")
	glorymessagespkabayonet = list("stabs through the priest's heart and pulls it out, letting them see one last beat before they die!")

/datum/action/innate/elite_attack/axe_slam
	name = "Axe Slam"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "axe_slam"
	chosen_message = "<span class='boldwarning'>You will attempt to slam your axe.</span>"
	chosen_attack_num = AXE_SLAM

/datum/action/innate/elite_attack/summon_shambler
	name = "Summon Shambler"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "summon_shambler"
	chosen_message = "<span class='boldwarning'>You will attempt to summon a shambling miner.</span>"
	chosen_attack_num = SUMMON_SHAMBLER

/datum/action/innate/elite_attack/dash
	name = "Dash"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "dash"
	chosen_message = "<span class='boldwarning'>You will attempt to dash near your target.</span>"
	chosen_attack_num = DASH

/datum/action/innate/elite_attack/axe_throw
	name = "Axe Throw"
	icon_icon = 'modular_sand/icons/mob/actions/actions_elites.dmi'
	button_icon_state = "axe_throw"
	chosen_message = "<span class='boldwarning'>You will attempt to throw your axe.</span>"
	chosen_attack_num = AXE_THROW

/mob/living/simple_animal/hostile/asteroid/elite/minerpriest/OpenFire()
	if(client)
		switch(chosen_attack)
			if(AXE_SLAM)
				axe_slam(target)
			if(SUMMON_SHAMBLER)
				summon_shambler(target)
			if(DASH)
				dash(target)
			if(AXE_THROW)
				axe_throw(target)
		return
	var/aiattack = rand(1,4)
	switch(aiattack)
		if(AXE_SLAM)
			axe_slam(target)
		if(SUMMON_SHAMBLER)
			summon_shambler(target)
		if(DASH)
			dash(target)
		if(AXE_THROW)
			axe_throw(target)

// priest actions
/mob/living/simple_animal/hostile/asteroid/elite/minerpriest/proc/axe_slam(target)
	ranged_cooldown = world.time + 30
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	var/turf/T = get_step(get_turf(src), dir_to_target)
	for(var/i in 1 to 3)
		new /obj/effect/temp_visual/dragon_swoop/priest(T)
		T = get_step(T, dir_to_target)
	visible_message("<span class='boldwarning'>[src] prepares to slam his axe!</span>")
	sleep(5)
	playsound(src,'sound/misc/crunch.ogg', 200, 1)
	T = get_step(get_turf(src), dir_to_target)
	var/list/hit_things = list()
	visible_message("<span class='boldwarning'>[src] slams his axe!</span>")
	for(var/i in 1 to 3)
		for(var/mob/living/L in T.contents)
			if(faction_check_mob(L))
				return
			hit_things += L
			visible_message("<span class='boldwarning'>[src] slams his axe on [L]!</span>")
			to_chat(L, "<span class='userdanger'>[src] slams his axe on you!</span>")
			L.Stun(15)
			L.adjustBruteLoss(30)
		T = get_step(T, dir_to_target)

/mob/living/simple_animal/hostile/asteroid/elite/minerpriest/proc/summon_shambler(target)
	ranged_cooldown = world.time + 150
	visible_message("<span class='boldwarning'>[src] summons a minion!</span>")
	playsound(src,'sound/magic/CastSummon.ogg', 200, 1)
	var/list/turfs = list()
	for(var/turf/T in oview(2, src))
		turfs += T
	var/turf/pick1 = pick(turfs)
	new /obj/effect/temp_visual/small_smoke/halfsecond(pick1)
	var/mob/living/simple_animal/hostile/asteroid/miner/m1 = new /mob/living/simple_animal/hostile/asteroid/miner(pick1)
	m1.faction = faction.Copy()
	m1.GiveTarget(target)

/mob/living/simple_animal/hostile/asteroid/elite/minerpriest/proc/dash(atom/dash_target)
	ranged_cooldown = world.time + 20
	visible_message("<span class='boldwarning'>[src] dashes into the air!</span>")
	playsound(src,'sound/magic/blink.ogg', 200, 1)
	var/list/accessable_turfs = list()
	var/self_dist_to_target = 0
	var/turf/own_turf = get_turf(src)
	if(!QDELETED(dash_target))
		self_dist_to_target += get_dist(dash_target, own_turf)
	for(var/turf/open/O in RANGE_TURFS(4, own_turf))
		var/turf_dist_to_target = 0
		if(!QDELETED(dash_target))
			turf_dist_to_target += get_dist(dash_target, O)
		if(get_dist(src, O) <= 4 && turf_dist_to_target <= self_dist_to_target && !islava(O) && !ischasm(O))
			var/valid = TRUE
			for(var/turf/T in getline(own_turf, O))
				if(is_blocked_turf(T, TRUE))
					valid = FALSE
					continue
			if(valid)
				accessable_turfs[O] = turf_dist_to_target
	var/turf/target_turf
	if(!QDELETED(dash_target))
		var/closest_dist = 4
		for(var/t in accessable_turfs)
			if(accessable_turfs[t] < closest_dist)
				closest_dist = accessable_turfs[t]
		for(var/t in accessable_turfs)
			if(accessable_turfs[t] != closest_dist)
				accessable_turfs -= t
	if(!LAZYLEN(accessable_turfs))
		return
	target_turf = pick(accessable_turfs)
	var/turf/step_back_turf = get_step(target_turf, -(src.dir))
	new /obj/effect/temp_visual/small_smoke/halfsecond(step_back_turf)
	new /obj/effect/temp_visual/small_smoke/halfsecond(own_turf)
	forceMove(step_back_turf)
	return TRUE


/mob/living/simple_animal/hostile/asteroid/elite/minerpriest/proc/axe_throw(target)
	ranged_cooldown = world.time + 20
	visible_message("<span class='boldwarning'>[src] prepares to throw his axe!</span>")
	var/turf/targetturf = get_turf(target)
	playsound(src,'sound/weapons/fwoosh.wav', 200, 1)
	Shoot(targetturf)
	new /obj/item/melee/diamondaxe/priest(targetturf)

/mob/living/simple_animal/hostile/asteroid/elite/minerpriest/drop_loot()
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src.loc)
	if(src.client)
		H.client = src.client
		to_chat(H, "<span class='userdanger'>You have been finally enlightened.  Serving the necropolis is not your duty anymore, thanks to whoever defeated you. You owe them a great debt.</span")
		to_chat(H, "<span class='big bold'>Note that you now share the loyalties of the one who defeated you.  You are expected not to intentionally sabotage their faction unless commanded to!</span>")
	else
		H.adjustBruteLoss(200)
	H.equipOutfit(/datum/outfit/job/miner/equipped/priest)

// priest helpers
/datum/outfit/job/miner/equipped/priest
	name = "Shaft Miner (Necropolis Priest)"
	shoes = /obj/item/clothing/shoes/bronze
	mask = /obj/item/clothing/mask/gas
	backpack_contents = list(
		/obj/item/flashlight/seclite=1,\
		/obj/item/kitchen/knife/combat/survival=1,
		/obj/item/mining_voucher=1,
		/obj/item/t_scanner/adv_mining_scanner/lesser=1,
		/obj/item/gun/energy/kinetic_accelerator=1,\
		/obj/item/stack/marker_beacon/ten=1,
		/obj/item/melee/diamondaxe = 1,
		/obj/item/clothing/head/bronze = 1,
		/obj/item/clothing/suit/bronze = 1)

/obj/effect/temp_visual/dragon_swoop/priest
	duration = 5
	color = rgb(255,0,0)

/obj/effect/temp_visual/dragon_swoop/priest/Initialize()
	. = ..()
	transform *= 0.33

/obj/item/projectile/kinetic/axe
	name = "kinetic axe"
	damage = 20
	damage_type = BRUTE
	color = "#00FFFF"

/obj/item/projectile/kinetic/axe/prehit(atom/target)
	return

//loot

/obj/item/melee/diamondaxe
	name = "Priest's Axe"
	desc = "Used to be a diamond pickaxe, now there's no pick, just axe."
	icon = 'modular_sand/icons/obj/lavaland/artefacts.dmi'
	icon_state = "diamondaxe"
	lefthand_file = 'modular_sand/icons/mob/inhands/weapons/axes_lefthand.dmi'
	righthand_file = 'modular_sand/icons/mob/inhands/weapons/axes_righthand.dmi'
	item_state = "diamondaxe"
	attack_verb = list("slashed", "sliced", "torn", "ripped", "diced", "cut")
	w_class = WEIGHT_CLASS_BULKY
	force = 20
	throwforce = 18
	embedding = list("embedded_pain_multiplier" = 3, "embed_chance" = 90, "embedded_fall_chance" = 50)
	armour_penetration = 50
	block_chance = 25
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/slash.ogg'

/obj/item/melee/diamondaxe/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 50, 100, null, null, TRUE)

/obj/item/melee/diamondaxe/priest

/obj/item/melee/diamondaxe/priest/Initialize()
	..()
	QDEL_IN(src, 30)
