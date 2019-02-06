/datum/martial_art/dusters
	name = "Knuckles"

/datum/martial_art/dusters/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)

	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)

	var/atk_verb = pick("pummel", "smash")
	var/damage = 10
	if(!damage)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>", \
			"<span class='userdanger'>[A] has attempted to [atk_verb] [D]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(A, D, "attempted to hit", atk_verb)
		return 0

	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)

	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
			"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>", null, COMBAT_MESSAGE_RANGE)

	D.apply_damage(damage, BRUTE, affecting, armor_block)
	D.apply_damage(13, STAMINA, affecting)
	if(D.IsKnockdown() || D.resting || D.lying)
		D.apply_damage(5, BRUTE, affecting)
	log_combat(A, D, "punched (knuckledusters) ")
	if(D.getStaminaLoss() > 50)
		var/knockout_prob = (D.getStaminaLoss() + rand(-15,15))*0.75
		if((D.stat != DEAD) && prob(knockout_prob))
			D.visible_message("<span class='danger'>[A] has knocked [D] down with a FALCON PUNCH!</span>", \
								"<span class='userdanger'>[A] has knocked [D] down with a FALCON PUNCH!</span>")
			D.apply_effect(200,EFFECT_KNOCKDOWN,armor_block)
			log_combat(A, D, "knocked down (knuckledusters) ")
	return 1

/obj/item/clothing/gloves/knuckledusters
	var/datum/martial_art/dusters/style = new

/obj/item/clothing/gloves/knuckledusters/equipped(mob/user, slot)
	if(!ishuman(user))
		return
	if(slot == SLOT_GLOVES)
		style.teach(user,1)
	return

/obj/item/clothing/gloves/knuckledusters/dropped(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(SLOT_GLOVES) == src)
		style.remove(H)
	return
