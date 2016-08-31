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

/mob/living/carbon/proc/vore_attack(mob/living/user, mob/M, var/mob/living/prey, var/mob/living/pred, devour_time = 100)

	if(!do_mob(src, user, devour_time))
		return

	var/mob/attacker = user  // Typecast to human

		// If you click yourself...

	if((user == attacker) && (src != prey) && (is_vore_predator(user)))
		if(!(is_vore_predator(user)))
			user.visible_message("<span class='notice'>You can't eat this.</span>")
			message_admins("[attacker] attempted to feed [prey] to their ([user.type]) but it is not predator-capable")
			return
		else
			var/belly = user.vore_selected
			return perform_the_nom(user, prey, user, belly)


		///// If grab clicked on grabbed
	else if((user == pred) && (src != attacker) && (attacker.a_intent == "grab") && (is_vore_predator(pred)))
		if(!(is_vore_predator(pred)))
			user.visible_message("<span class='notice'>[pred] can't eat that</span>")
			message_admins("[attacker] attempted to feed themselves to [pred] ([pred.type]) but it is not predator-capable")
			return

		else
			var/belly = input("Choose Belly") in pred.vore_organs
			return perform_the_nom(user, user, pred, belly)

		///// If grab clicked on anyone else
	else if((src != attacker) && (src != prey) && (is_vore_predator(M)))
		if(!(is_vore_predator(M)))
			user.visible_message("<span class='notice'>[M] can't eat that.</span>")
			message_admins("[attacker] attempted to feed [prey] to [M] ([M.type]) but it is not predator-capable")
		else
			var/belly = input("Choose Belly") in pred.vore_organs
			return perform_the_nom(user, prey, pred, belly)


/mob/living/carbon/proc/perform_the_nom(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/belly)
	//Sanity
	if(!user || !prey || !pred || !belly || !(belly in pred.vore_organs))
		log_attack("[user] attempted to feed [prey] to [pred], via [belly] but it went wrong.")
		return

	// The belly selected at the time of noms
	var/datum/belly/belly_target = pred.vore_organs[belly]
	var/attempt_msg = "ERROR: Vore message couldn't be created. Notify a dev. (at)"
	var/success_msg = "ERROR: Vore message couldn't be created. Notify a dev. (sc)"

	// Prepare messages
	if(user == pred) //Feeding someone to yourself
		attempt_msg = text("<span class='warning'>[] is attemping to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
	else //Feeding someone to another person
		attempt_msg = text("<span class='warning'>[] is attempting to make [] [] [] into their []!</span>",user,pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to make [] [] [] into their []!</span>",user,pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))

	// Announce that we start the attempt!
	user.visible_message(attempt_msg)

	// Now give the prey time to escape... return if they did
	var/swallow_time = istype(prey, /mob/living/carbon/human) ? belly_target.human_prey_swallow_time : belly_target.nonhuman_prey_swallow_time

	if(!do_mob(user, swallow_time))
		return 0 // Prey escpaed (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	playsound(user, belly_target.vore_sound, 100, 1)

	// Actually shove prey into the belly.
	belly_target.nom_mob(prey, user)
	user.update_icons()
	stop_pulling()

	// Inform Admins
	if (pred == user)
		message_admins("[key_name(pred)] ate [key_name(prey)]. ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		log_attack("[key_name(pred)] ate [key_name(prey)]")
	else if (prey == !client && stat != DEAD)
		message_admins("[key_name(pred)] ate [key_name(prey)] (braindead) ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		log_attack("[key_name(pred)] ate [key_name(prey)] (braindead)")
	else
		message_admins("[key_name(user)] forced [key_name(pred)] to eat [key_name(prey)]. ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		log_attack("[key_name(user)] forced [key_name(pred)] to eat [key_name(prey)].")
	return 1