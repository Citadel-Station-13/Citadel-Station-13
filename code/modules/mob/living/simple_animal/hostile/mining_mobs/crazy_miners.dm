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
	var/medipens = 4
	var/weapon_type = "" //KA or KC. Empty means fists
	var/suit_type = ""
	loot = list()
	deathmessage = "falls, decaying into ashes"

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
			icon_state = "[initial(icon_state)]_seva"
			loot += /obj/item/clothing/suit/hooded/explorer/seva/standard

		if("EXO")
			maxHealth = 300
			health = 300
			speed = 1
			icon_state = "[initial(icon_state)]_exo"
			loot += /obj/item/clothing/suit/hooded/explorer/exo/standard

	switch(weapon_type)
		if("KA")
			ranged = 1
			projectiletype = /obj/item/projectile/kinetic
			icon_state = "[icon_state]_ka"
			loot += /obj/item/gun/energy/kinetic_accelerator
		if("KC")
			melee_damage_lower = 20
			melee_damage_upper = 20 //Its KC and you are the prey
			icon_state = "[icon_state]_kc"
			loot += /obj/item/kinetic_crusher

	update_icon()

/mob/living/simple_animal/hostile/asteroid/crazy_miner/seva
	suit_type = "SEVA"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/exo
	suit_type = "EXO"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/ka
	weapon_type = "KA"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/kc
	weapon_type = "KC"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/seva/ka
	weapon_type = "KA"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/seva/kc
	weapon_type = "KC"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/exo/ka
	weapon_type = "KA"

/mob/living/simple_animal/hostile/asteroid/crazy_miner/exo/kc
	weapon_type = "KC"