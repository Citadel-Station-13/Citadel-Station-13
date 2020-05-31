/mob/living/simple_animal/hostile/retaliate/bat
	name = "Space Bat"
	desc = "A rare breed of bat which roosts in spaceships, probably not vampiric."
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	blood_volume = 250
	response_help_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "hits"
	response_harm_simple = "hit"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	maxHealth = 15
	health = 15
	spacewalk = TRUE
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1)
	pass_flags = PASSTABLE
	faction = list("hostile")
	attack_sound = 'sound/weapons/bite.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	movement_type = FLYING
	speak_emote = list("squeaks")
	var/max_co2 = 0 //to be removed once metastation map no longer use those for Sgt Araneus
	var/min_oxy = 0
	var/max_tox = 0


	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/retaliate/bat/secbat
	name = "Security Bat"
	icon_state = "secbat"
	icon_living = "secbat"
	icon_dead = "secbat_dead"
	icon_gib = "secbat_dead"
	desc = "A fruit bat with a tiny little security hat who is ready to inject cuteness into any security operation."
	emote_see = list("is ready to law down the law.", "flaps about with an air of authority.")
	response_help_continuous = "respects the authority of"
	response_help_simple = "respect the authority of"
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/hostile/retaliate/bat/vampire_bat
	name = "vampire bat"
	desc = "A tougher than usual bat that sucks blood. Keep away from medical bays."
	speak_chance = 0
	maxHealth = 50 //Hey, dont die in one shot.
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 7
	melee_damage_upper = 13 //So it might be actually usefull in combat
	faction = list("hostile", "vampire")
	var/mob/living/controller

/mob/living/simple_animal/hostile/retaliate/bat/vampire_bat/CanAttack(atom/the_target)
	. = ..()
	if(isliving(the_target) && is_vampire(the_target))
		return FALSE

/mob/living/simple_animal/update_sight()
	. = ..()
	if(mind)
		var/datum/antagonist/vampire/V = mind.has_antag_datum(/datum/antagonist/vampire)
		if(V)
			if(V.get_ability(/datum/vampire_passive/full))
				sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
				lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
			else if(V.get_ability(/datum/vampire_passive/vision))
				sight |= (SEE_MOBS)
				lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE

/mob/living/simple_animal/hostile/retaliate/bat/vampire_bat/death()
	if(isliving(controller))
		controller.forceMove(loc)
		mind.transfer_to(controller)
		controller.status_flags &= ~GODMODE
		controller.adjustStaminaLoss(90)
		controller.Knockdown(20)
		to_chat(controller, "<span class='userdanger'>The force of being exiled from your bat form knocks you down!</span>")
	. = ..()
