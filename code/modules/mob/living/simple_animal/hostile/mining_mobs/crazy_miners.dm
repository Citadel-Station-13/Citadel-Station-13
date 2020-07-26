/mob/living/simple_animal/hostile/asteroid/crazy_miner
	name = "crazy miner"
	desc = "One of many miners, that lost their mind on Lavaland."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "miner"
	icon_living = "miner"
	icon_dead = "miner"
	faction = list("miners") //So they will fight other fauna
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	threat = 3
	move_to_delay = 2
	ranged = 0
	ranged_cooldown_time = 15
	friendly_verb_continuous = "wails at"
	friendly_verb_simple = "wail at"
	speak_emote = list("screams")
	speed = 0
	maxHealth = 200
	health = 200
	environment_smash = 0
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	throw_message = "bumps from the strenghed suit of"
	vision_range = 7
	aggro_vision_range = 7
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_VERY_STRONG
	pull_force = MOVE_FORCE_VERY_STRONG
	var/medipens = 3
	var/weapon_type = "" //KA or KC. Empty means fists
	var/suit_type = ""
	loot = list()
	deathmessage = "falls, decaying into ashes"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/death(gibbed)
    . = ..()
    qdel(src)

/mob/living/simple_animal/hostile/asteroid/crazy_miner/AttackingTarget()
	if(health < maxHealth / 3 && medipens > 0)
		if(prob(15))
			visible_message("<span class='warning'>[src] uses a survival medipen!</span>")
			health = min(health + maxHealth * 0.5, maxHealth)
			medipens -= 1
			return
	. = ..()

/mob/living/simple_animal/hostile/asteroid/crazy_miner/Initialize()
	. = ..()
	medipens = rand(2, 6)
	switch(suit_type)
		if("")
			loot += /obj/item/clothing/suit/hooded/explorer/standard

		if("SEVA")
			maxHealth = 150
			health = 150
			speed = -1 //Fast
			loot += /obj/item/clothing/suit/hooded/explorer/seva/standard

		if("EXO")
			maxHealth = 300
			health = 300
			speed = 1
			loot += /obj/item/clothing/suit/hooded/explorer/exo/standard

	switch(weapon_type)
		if("KA")
			ranged = 1
			projectiletype = /obj/item/projectile/kinetic
			loot += /obj/item/gun/energy/kinetic_accelerator
		if("KC")
			melee_damage_lower = 20
			melee_damage_upper = 20 //Its KC and you are the prey
			loot += /obj/item/kinetic_crusher

	update_icon()

/mob/living/simple_animal/hostile/asteroid/crazy_miner/seva
	suit_type = "SEVA"
	icon_state = "miner_seva"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/exo
	suit_type = "EXO"
	icon_state = "miner_exo"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/ka
	weapon_type = "KA"
	icon_state = "miner_ka"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/kc
	weapon_type = "KC"
	icon_state = "miner_kc"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/seva/ka
	weapon_type = "KA"
	icon_state = "miner_seva_ka"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/seva/kc
	weapon_type = "KC"
	icon_state = "miner_seva_kc"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/exo/ka
	weapon_type = "KA"
	icon_state = "miner_ka"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/exo/kc
	weapon_type = "KC"
	icon_state = "miner_kc"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/random/Initialize()
	. = ..()
	var/miner = rand(1, 21)
	switch(miner)
		if(1)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner(loc)
		if(2)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/seva(loc)
		if(3)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/exo(loc) //Small chances of fist-only miners
		if(4 to 6)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/ka(loc)
		if(7 to 9)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/kc(loc)
		if(10 to 12)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/seva/ka(loc)
		if(13 to 15)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/seva/kc(loc)
		if(16 to 18)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/exo/ka(loc)
		if(19 to 21)
			new /mob/living/simple_animal/hostile/asteroid/crazy_miner/exo/kc(loc)
	return INITIALIZE_HINT_QDEL