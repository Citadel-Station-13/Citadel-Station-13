/datum/species/proc/alt_spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return TRUE
	CHECK_DNA_AND_SPECIES(M)
	CHECK_DNA_AND_SPECIES(H)

	if(!istype(M)) //sanity check for drones.
		return TRUE
	if(M.mind)
		attacker_style = M.mind.martial_art
	if((M != H) && M.a_intent != INTENT_HELP && H.check_shields(M, 0, M.name, attack_type = UNARMED_ATTACK))
		add_logs(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return TRUE
	switch(M.a_intent)
		if("disarm")
			altdisarm(M, H, attacker_style)
			return TRUE
	return FALSE

/datum/species/proc/altdisarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user.staminaloss >= STAMINA_SOFTCRIT)
		to_chat(user, "<span class='warning'>You're too exhausted.</span>")
		return FALSE
	else if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s disarm attempt!</span>")
		return 0
	if(attacker_style && attacker_style.disarm_act(user,target))
		return 1
	else
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)

		user.adjustStaminaLossBuffered(4) //CITADEL CHANGE - makes disarmspam cause staminaloss

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		var/randomized_zone = ran_zone(user.zone_selected)
		target.SendSignal(COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(randomized_zone)
		var/randn = rand(1, 100)
		if(user.resting)
			randn += 20 //Makes it plausible, but unlikely, to push someone over while resting
		if(!user.combatmode)
			randn += 25 //Makes it impossible to push actually push someone outside of combat mode

		if(randn <= 25)
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			target.visible_message("<span class='danger'>[user] has pushed [target]!</span>",
				"<span class='userdanger'>[user] has pushed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(40, KNOCKDOWN, target.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
			target.forcesay(GLOB.hit_appends)
			add_logs(user, target, "disarmed", " pushing them to the ground")
			return

		playsound(target, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
		target.visible_message("<span class='danger'>[user] attempted to push [target]!</span>", \
						"<span class='userdanger'>[user] attemped to push [target]!</span>", null, COMBAT_MESSAGE_RANGE)
