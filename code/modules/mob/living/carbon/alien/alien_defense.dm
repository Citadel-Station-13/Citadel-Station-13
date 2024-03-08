
/mob/living/carbon/alien/get_eye_protection()
	return ..() + 2 //potential cyber implants + natural eye protection

/mob/living/carbon/alien/get_ear_protection()
	return 2 //no ears

/mob/living/carbon/alien/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	return ..(AM, skipcatch = TRUE, hitpush = FALSE)

/*Code for aliens attacking aliens. Because aliens act on a hivemind, I don't see them as very aggressive with each other.
As such, they can either help or harm other aliens. Help works like the human help command while harm is a simple nibble.
In all, this is a lot like the monkey code. /N
*/
/mob/living/carbon/alien/attack_alien(mob/living/carbon/alien/M)
	. = ..()
	if(!.) // the attack was blocked or was help/grab intent
		return
	switch(M.a_intent)
		if (INTENT_HELP)
			if(!(combat_flags & COMBAT_FLAG_HARD_STAMCRIT))
				set_resting(FALSE, TRUE, FALSE)
			AdjustAllImmobility(-60, FALSE)
			AdjustUnconscious(-60, FALSE)
			AdjustSleeping(-100, FALSE)
			update_mobility()
			visible_message("<span class='notice'>[M.name] nuzzles [src] trying to wake [p_them()] up!</span>",
				"<span class='notice'>[M.name] nuzzles you trying to wake you up!</span>", target = M,
				target_message = "<span class='notice'>You nuzzle [src] trying to wake [p_them()] up!</span>")
		if(INTENT_DISARM, INTENT_HARM)
			if(health > 0)
				M.do_attack_animation(src, ATTACK_EFFECT_BITE)
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M.name] bites [src]!</span>", \
						"<span class='userdanger'>[M.name] bites [src]!</span>", null, COMBAT_MESSAGE_RANGE, null, M,
						"<span class='danger'>You bite [src]!</span>")
				adjustBruteLoss(1)
				log_combat(M, src, "attacked")
				updatehealth()
			else
				to_chat(M, "<span class='warning'>[name] is too injured for that.</span>")


/mob/living/carbon/alien/attack_larva(mob/living/carbon/alien/larva/L)
	return attack_alien(L)


/mob/living/carbon/alien/on_attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(.) //To allow surgery to return properly.
		return
	switch(M.a_intent)
		if(INTENT_HELP)
			if(M == src && check_self_for_injuries())
				return
			help_shake_act(M)
		if(INTENT_GRAB)
			grabbedby(M)
		if (INTENT_HARM)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, "<span class='notice'>You don't want to hurt [src]!</span>")
				return TRUE
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		if(INTENT_DISARM)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, "<span class='notice'>You don't want to hurt [src]!</span>")
				return TRUE
			M.do_attack_animation(src, ATTACK_EFFECT_DISARM)


/mob/living/carbon/alien/attack_paw(mob/living/carbon/monkey/M)
	. = ..()
	if(.) //successful monkey bite.
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
		apply_damage(rand(1, 3), BRUTE, affecting)

/mob/living/carbon/alien/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		switch(M.melee_damage_type)
			if(BRUTE)
				adjustBruteLoss(damage)
			if(BURN)
				adjustFireLoss(damage)
			if(TOX)
				adjustToxLoss(damage)
			if(OXY)
				adjustOxyLoss(damage)
			if(CLONE)
				adjustCloneLoss(damage)
			if(STAMINA)
				adjustStaminaLoss(damage)

/mob/living/carbon/alien/attack_slime(mob/living/simple_animal/slime/M)
	. = ..()
	if(!.) //unsuccessful slime attack
		return
	var/damage = rand(5, 35)
	if(M.is_adult)
		damage = rand(10, 40)
	adjustBruteLoss(damage)
	log_combat(M, src, "attacked")
	updatehealth()

/mob/living/carbon/alien/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()
	switch (severity)
		if (EXPLODE_DEVASTATE)
			gib()
			return

		if (EXPLODE_HEAVY)
			take_overall_damage(60, 60)
			adjustEarDamage(30,120)

		if(EXPLODE_LIGHT)
			take_overall_damage(30,0)
			if(prob(50))
				Unconscious(20)
			adjustEarDamage(15,60)

/mob/living/carbon/alien/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	return FALSE

/mob/living/carbon/alien/acid_act(acidpwr, acid_volume)
	return 0//aliens are immune to acid.
