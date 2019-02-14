/datum/species
	var/should_draw_citadel = FALSE

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
		log_combat(M, H, "attempted to touch")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return TRUE
	switch(M.a_intent)
		if(INTENT_HELP)
			if(M == H)
				althelp(M, H, attacker_style)
				return TRUE
			return FALSE
		if(INTENT_DISARM)
			altdisarm(M, H, attacker_style)
			return TRUE
	return FALSE

/datum/species/proc/althelp(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user == target && istype(user))
		if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
			to_chat(user, "<span class='warning'>You're too exhausted for that.</span>")
			return
		if(!user.resting)
			to_chat(user, "<span class='notice'>You can only force yourself up if you're on the ground.</span>")
			return
		user.visible_message("<span class='notice'>[user] forces [p_them()]self up to [p_their()] feet!</span>", "<span class='notice'>You force yourself up to your feet!</span>")
		user.resting = 0
		user.update_canmove()
		user.adjustStaminaLossBuffered(user.stambuffer) //Rewards good stamina management by making it easier to instantly get up from resting
		playsound(user, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/datum/species/proc/altdisarm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(user.getStaminaLoss() >= STAMINA_SOFTCRIT)
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
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(randomized_zone)

		if((!target.combatmode && user.combatmode || prob(target.getStaminaLoss()*(user.resting ? 0.25 : 1)*(user.combatmode ? 1 : 0.05))) && !target.resting) //probability depends on staminaloss. it's plausible, but unlikely that you'll be able to push someone over while resting, and pretty rare to successfully push someone outside of combat mode. The few people that even know how to right-click outside of combat mode are a rarity but let's take that into account regardless.
			playsound(target, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			target.visible_message("<span class='danger'>[user] [user.combatmode ? "has" : "gently"] pushed [target]!</span>",
				"<span class='userdanger'>[user] has pushed [target]!</span>", null, COMBAT_MESSAGE_RANGE)
			target.apply_effect(40, EFFECT_KNOCKDOWN, target.run_armor_check(affecting, "melee", "Your armor prevents your fall!", "Your armor softens your fall!"))
			target.forcesay(GLOB.hit_appends)
			log_combat(user, target, "disarmed", " pushing them to the ground")
			return

		playsound(target, 'sound/weapons/thudswoosh.ogg', 25, 1, -1)
		target.visible_message("<span class='danger'>[user] [user.combatmode ? "attempted to push" : "tries to gently push"] [target] over!</span>", \
						"<span class='userdanger'>[user] [user.combatmode ? "attempted to push" : "tries to gently push"] [target] over!</span>", null, COMBAT_MESSAGE_RANGE)
		if(!target.resting && !user.resting && user.combatmode)
			target.adjustStaminaLoss(rand(1,5)) //This is the absolute most inefficient way to get someone into soft stamcrit, but if you've got a crowd trying to shove you over, you've no option but to get knocked down and accept fate
		log_combat(user, target, "attempted to disarm push")

////////////////////
/////BODYPARTS/////
////////////////////


/obj/item/bodypart
	var/should_draw_citadel = FALSE

/datum/species/proc/citadel_mutant_bodyparts(bodypart, mob/living/carbon/human/H)
	switch(bodypart)
		if("ipc_screen")
			return GLOB.ipc_screens_list[H.dna.features["ipc_screen"]]
		if("ipc_antenna")
			return GLOB.ipc_antennas_list[H.dna.features["ipc_antenna"]]
		if("mam_tail")
			return GLOB.mam_tails_list[H.dna.features["mam_tail"]]
		if("mam_waggingtail")
			return GLOB.mam_tails_animated_list[H.dna.features["mam_tail"]]
		if("mam_body_markings")
			return GLOB.mam_body_markings_list[H.dna.features["mam_body_markings"]]
		if("mam_ears")
			return GLOB.mam_ears_list[H.dna.features["mam_ears"]]
		if("taur")
			return GLOB.taur_list[H.dna.features["taur"]]
		if("xenodorsal")
			return GLOB.xeno_dorsal_list[H.dna.features["xenodorsal"]]
		if("xenohead")
			return GLOB.xeno_head_list[H.dna.features["xenohead"]]
		if("xenotail")
			return GLOB.xeno_tail_list[H.dna.features["xenotail"]]
