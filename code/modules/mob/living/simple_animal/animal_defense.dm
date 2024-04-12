

/mob/living/simple_animal/on_attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(.) //the attack was blocked
		return
	switch(M.a_intent)
		if(INTENT_HELP)
			if (health > 0)
				visible_message("<span class='notice'>[M] [response_help_continuous] [src].</span>", \
								"<span class='notice'>[M] [response_help_continuous] you.</span>", null, null, null,
								M, "<span class='notice'>You [response_help_simple] [src].</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

		if(INTENT_GRAB)
			if(grab_state >= GRAB_AGGRESSIVE && isliving(pulling))
				vore_attack(M, pulling)
			else
				grabbedby(M)

		if(INTENT_DISARM)
			M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
			visible_message("<span class='danger'>[M] [response_disarm_continuous] [src]!</span>",\
							"<span class='danger'>[M] [response_disarm_continuous] you!</span>", null, COMBAT_MESSAGE_RANGE, null, \
							M, "<span class='danger'>You [response_disarm_simple] [src]!</span>")
			playsound(src, 'sound/weapons/thudswoosh.ogg', 25, 1)
			log_combat(M, src, "disarmed")

		if(INTENT_HARM)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, "<span class='notice'>You don't want to hurt [src]!</span>")
				return
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			visible_message("<span class='danger'>[M] [response_harm_continuous] [src]!</span>",\
							"<span class='userdanger'>[M] [response_harm_continuous] you!</span>", null, COMBAT_MESSAGE_RANGE, null, \
							M, "<span class='danger'>You [response_harm_simple] [src]!</span>")
			playsound(loc, attacked_sound, 25, 1, -1)
			attack_threshold_check(harm_intent_damage)
			log_combat(M, src, "attacked")
			updatehealth()
			return TRUE

/mob/living/simple_animal/attack_hulk(mob/living/carbon/human/user, does_attack_animation = FALSE)
	if(user.a_intent == INTENT_HARM)
		. = ..(user, TRUE)
		if(.)
			return
		playsound(loc, "punch", 25, 1, -1)
		visible_message("<span class='danger'>[user] punches [src]!</span>", \
			"<span class='userdanger'>[user] punches you!</span>", null, COMBAT_MESSAGE_RANGE, null, \
			user, "<span class='danger'>You punch [src]!</span>")
		adjustBruteLoss(15)
		return TRUE

/mob/living/simple_animal/attack_paw(mob/living/carbon/monkey/M)
	. = ..()
	if(.) //successful larva bite
		var/damage = rand(1, 3)
		attack_threshold_check(damage)
		return TRUE
	if (M.a_intent == INTENT_HELP)
		if (health > 0)
			visible_message("<span class='notice'>[M.name] [response_help_continuous] [src].</span>", \
							"<span class='notice'>[M.name] [response_help_continuous] you.</span>", \
							target = M, target_message = "<span class='notice'>You [response_help_simple] [src].</span>")
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/simple_animal/attack_alien(mob/living/carbon/alien/humanoid/M)
	. = ..()
	if(!.) // the attack was blocked or was help/grab intent
		return
	if(M.a_intent == INTENT_DISARM)
		playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
		visible_message("<span class='danger'>[M] [response_disarm_continuous] [name]!</span>", \
				"<span class='userdanger'>[M] [response_disarm_continuous] [name]!</span>", null, COMBAT_MESSAGE_RANGE, null, \
				M, "<span class='danger'>You [response_disarm_simple] [name]!</span>")
		log_combat(M, src, "disarmed")
	else
		visible_message("<span class='danger'>[M] has slashed at [src]!</span>", \
				"<span class='userdanger'>[M] has slashed at [src]!</span>", null, COMBAT_MESSAGE_RANGE, null, \
				M, "<span class='danger'>[M] has slashed at [src]!</span>")
		playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
		attack_threshold_check(M.meleeSlashSAPower)
		log_combat(M, src, "attacked")

/mob/living/simple_animal/attack_larva(mob/living/carbon/alien/larva/L)
	. = ..()
	if(. && stat != DEAD) //successful larva bite
		var/damage = rand(5, 10)
		. = attack_threshold_check(damage)
		if(.)
			L.amount_grown = min(L.amount_grown + damage, L.max_grown)

/mob/living/simple_animal/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		var/damage = .
		return attack_threshold_check(damage, M.melee_damage_type)

/mob/living/simple_animal/attack_slime(mob/living/simple_animal/slime/M)
	. = ..()
	if(.) //successful slime shock
		var/damage = rand(15, 25)
		if(M.is_adult)
			damage = rand(20, 35)
		return attack_threshold_check(damage)

/mob/living/simple_animal/attack_drone(mob/living/simple_animal/drone/M)
	if(M.a_intent == INTENT_HARM) //No kicking dogs even as a rogue drone. Use a weapon.
		return
	return ..()

/mob/living/simple_animal/proc/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = MELEE)
	var/temp_damage = damage
	if(!damage_coeff[damagetype])
		temp_damage = 0
	else
		temp_damage *= damage_coeff[damagetype]

	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message("<span class='warning'>[src] looks unharmed!</span>")
		return FALSE
	else
		apply_damage(damage, damagetype, null, getarmor(null, armorcheck))
		return TRUE

/mob/living/simple_animal/bullet_act(obj/item/projectile/Proj, def_zone, piercing_hit = FALSE)
	if(!Proj)
		return
	apply_damage(Proj.damage, Proj.damage_type, 0, piercing_hit)
	Proj.on_hit(src)
	return BULLET_ACT_HIT

/mob/living/simple_animal/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()
	var/bomb_armor = getarmor(null, BOMB)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(prob(bomb_armor))
				adjustBruteLoss(500)
			else
				gib()
				return
		if (EXPLODE_HEAVY)
			var/bloss = 60
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

		if(EXPLODE_LIGHT)
			var/bloss = 30
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

/mob/living/simple_animal/blob_act(obj/structure/blob/B)
	adjustBruteLoss(20)
	return

/mob/living/simple_animal/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
