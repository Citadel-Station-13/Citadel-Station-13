/mob/living/simple_animal/hostile/retaliate/bat/vampire_bat
	name = "vampire bat"
	desc = "A tougher than usual bat that sucks blood. Keep away from medical bays."
	turns_per_move = 1
	response_help = "brushes aside"
	response_disarm = "flails at"
	response_harm = "hits"
	speak_chance = 0
	maxHealth = 50 //Hey, dont die in one shot.
	health = 50
	see_in_dark = 10
	harm_intent_damage = 5
	melee_damage_lower = 7
	melee_damage_upper = 13 //So it might be actually usefull in combat
	faction = list("hostile", "vampire")
	var/mob/living/controller

/mob/living/simple_animal/hostile/retaliate/bat/vampire_bat/CanAttack(atom/the_target)
	. = ..()
	if(isliving(the_target) && is_vampire(the_target))
		return FALSE

/mob/living/simple_animal/hostile/retaliate/bat/vampire_bat/death()
	if(isliving(controller))
		controller.forceMove(loc)
		mind.transfer_to(controller)
		controller.status_flags &= ~GODMODE
		controller.adjustStaminaLoss(90)
		controller.Knockdown(20)
		to_chat(controller, "<span class='userdanger'>The force of being exiled from your bat form knocks you down!</span>")
	. = ..()
