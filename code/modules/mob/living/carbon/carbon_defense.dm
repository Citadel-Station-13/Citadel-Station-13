/mob/living/carbon/hitby(atom/movable/AM, skipcatch, hitpush = 1, blocked = 0)
	if(!skipcatch)	//ugly, but easy
		if(in_throw_mode && !get_active_hand())	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(istype(AM, /obj/item))
					var/obj/item/I = AM
					if(isturf(I.loc))
						put_in_active_hand(I)
						visible_message("<span class='warning'>[src] catches [I]!</span>")
						throw_mode_off()
						return 1
	..()

/mob/living/carbon/throw_impact(atom/hit_atom)
	. = ..()
	if(hit_atom.density && isturf(hit_atom))
		Weaken(1)
		take_organ_damage(10)

/mob/living/carbon/attackby(obj/item/I, mob/user, params)
	if(lying)
		if(surgeries.len)
			if(user != src && user.a_intent == "help")
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	return ..()


/mob/living/carbon/attack_hand(mob/living/carbon/human/user)
	if(!iscarbon(user))
		return

	for(var/datum/disease/D in viruses)
		if(D.IsSpreadByTouch())
			user.ContractDisease(D)

	for(var/datum/disease/D in user.viruses)
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(lying)
		if(user.a_intent == "help")
			if(surgeries.len)
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(user, src))
						return 1
	return 0


/mob/living/carbon/attack_paw(mob/living/carbon/monkey/M)
	if(!istype(M, /mob/living/carbon))
		return 0

	for(var/datum/disease/D in viruses)
		if(D.IsSpreadByTouch())
			M.ContractDisease(D)

	for(var/datum/disease/D in M.viruses)
		if(D.IsSpreadByTouch())
			ContractDisease(D)

	if(M.a_intent == "help")
		help_shake_act(M)
		return 0

	if(..()) //successful monkey bite.
		for(var/datum/disease/D in M.viruses)
			ForceContractDisease(D)
		return 1


/mob/living/carbon/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime attack
		if(M.powerlevel > 0)
			var/stunprob = M.powerlevel * 7 + 10  // 17 at level 1, 80 at level 10
			if(prob(stunprob))
				M.powerlevel -= 3
				if(M.powerlevel < 0)
					M.powerlevel = 0

				visible_message("<span class='danger'>The [M.name] has shocked [src]!</span>", \
				"<span class='userdanger'>The [M.name] has shocked [src]!</span>")

				var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				var/power = M.powerlevel + rand(0,3)
				Weaken(power)
				if(stuttering < power)
					stuttering = power
				Stun(power)
				if (prob(stunprob) && M.powerlevel >= 8)
					adjustFireLoss(M.powerlevel * rand(6,10))
					updatehealth()
		return 1

/mob/living/carbon/proc/devour_mob(mob/living/carbon/C, devour_time = 130)
	C.visible_message("<span class='danger'>[src] is attempting to devour [C]!</span>", \
					"<span class='userdanger'>[src] is attempting to devour you!</span>")
	if(!do_mob(src, C, devour_time))
		return
	if(pulling && pulling == C && grab_state >= GRAB_AGGRESSIVE && a_intent == "grab")
		C.visible_message("<span class='danger'>[src] devours [C]!</span>", \
						"<span class='userdanger'>[src] devours you!</span>")
		C.forceMove(src)
		stomach_contents.Add(C)
		add_logs(src, C, "devoured")