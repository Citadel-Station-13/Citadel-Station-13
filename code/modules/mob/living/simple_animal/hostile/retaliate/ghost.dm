/mob/living/simple_animal/retaliate/ghost
	name = "ghost"
	desc = "A soul of the dead, spooky."
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	speak_chance = 0
	turns_per_move = 5
	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"
	a_intent = "harm"
	healable = 0
	speed = 0
	maxHealth = 40
	health = 40
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	del_on_death = 1
	emote_see = list("weeps silently", "groans", "mumbles")
	attacktext = "grips"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	speak_emote = list("weeps")
	deathmessage = "wails, disintegrating into a pile of ectoplasm!"
	loot = list(/obj/item/weapon/ectoplasm)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	flying = 1
	pressure_resistance = 200
	gold_core_spawnable = 0 //too spooky for science
	var/ghost_hair_style
	var/ghost_hair_color
	var/image/ghost_hair = null
	var/ghost_facial_hair_style
	var/ghost_facial_hair_color
	var/image/ghost_facial_hair = null
	var/random = TRUE //if you want random names for ghosts or not

/mob/living/simple_animal/retaliate/ghost/New()
	..()
	if(!random)
		give_hair()
	else
		switch(rand(0,1))
			if(0)
				name = "ghost of [pick(first_names_male)] [pick(last_names)]"
			if(1)
				name = "ghost of [pick(first_names_female)] [pick(last_names)]"
		give_hair()


/mob/living/simple_animal/retaliate/ghost/proc/give_hair()
	if(ghost_hair_style != null)
		ghost_hair = image('icons/mob/human_face.dmi', "hair_[ghost_hair_style]_s")
		ghost_hair.layer = -HAIR_LAYER
		ghost_hair.alpha = 200
		ghost_hair.color = ghost_hair_color
		add_overlay(ghost_hair)
	if(ghost_facial_hair_style != null)
		ghost_facial_hair = image('icons/mob/human_face.dmi', "facial_[ghost_facial_hair_style]_s")
		ghost_facial_hair.layer = -HAIR_LAYER
		ghost_facial_hair.alpha = 200
		ghost_facial_hair.color = ghost_facial_hair_color
		add_overlay(ghost_facial_hair)