/mob/living/simple_animal/hostile/crayon
	desc = "A creature made from paint. How is this even possible?!"
	icon = 'icons/effects/crayondecal.dmi'

	// drawings don't care much for the atmosphere
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list("drawing")
	pressure_resistance = 200

// low health and high damage, can move in space
/mob/living/simple_animal/hostile/crayon/carp
	name = "paint carp"
	icon_state = "carp_mob"
	icon_dead = "carp_mob_dead"
	icon_dead = "carp_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	taunt_chance = 30
	speed = 0
	maxHealth = 35
	health = 35
	spacewalk = TRUE
	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("gnashes")
	movement_type = FLYING

// low health and low damage but cheap
/mob/living/simple_animal/hostile/crayon/stickman
	name = "paint stickman"
	icon_state = "stickman_mob"
	icon_dead = "stickman_mob_dead"
	mob_biotypes = MOB_HUMANOID
	gender = MALE
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	blood_volume = 0
	stat_attack = UNCONSCIOUS
	robust_searching = TRUE
	environment_smash = ENVIRONMENT_SMASH_NONE
	maxHealth = 20
	health = 20
	harm_intent_damage = 5
	obj_damage = 0
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	status_flags = CANPUSH

// low damage but tanky
/mob/living/simple_animal/hostile/crayon/slime
	name = "paint slime"
	icon_state = "slime_mob"
	health = 80
	maxHealth = 80
	icon_dead = "slime_mob_dead"
	response_help_continuous  = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "stomps on"
	response_harm_simple = "stomp on"
	emote_see = list("jiggles", "bounces in place")
	speak_emote = list("blorbles")
	bubble_icon = "slime"
	initial_language_holder = /datum/language_holder/slime
	verb_say = "blorbles"
	verb_ask = "inquisitively blorbles"
	verb_exclaim = "loudly blorbles"
	verb_yell = "loudly blorbles"
	status_flags = CANUNCONSCIOUS|CANPUSH
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "glomps"
	attack_verb_simple = "glomp"

// even tankier with high damage, but costs more
/mob/living/simple_animal/hostile/crayon/monster
	name = "paint monster"
	desc = "This looks human enough, but its flesh is made of paint. It almost seems like this was once human."
	icon_state = "monster"
	icon_living = "monster"
	icon_dead = "monster"
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	deathmessage = "falls apart into a fine dust."
