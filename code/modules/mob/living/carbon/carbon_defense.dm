
/mob/living/carbon/get_eye_protection()
	var/number = ..()

	if(istype(src.head, /obj/item/clothing/head))			//are they wearing something on their head
		var/obj/item/clothing/head/HFP = src.head			//if yes gets the flash protection value from that item
		number += HFP.flash_protect

	if(istype(src.glasses, /obj/item/clothing/glasses))		//glasses
		var/obj/item/clothing/glasses/GFP = src.glasses
		number += GFP.flash_protect

	if(istype(src.wear_mask, /obj/item/clothing/mask))		//mask
		var/obj/item/clothing/mask/MFP = src.wear_mask
		number += MFP.flash_protect

	var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		number = INFINITY //Can't get flashed without eyes
	else
		number += E.flash_protect

	return number

/mob/living/carbon/get_ear_protection()
	var/number = ..()
	var/obj/item/organ/ears/E = getorganslot(ORGAN_SLOT_EARS)
	if(!E)
		number = INFINITY
	else
		number += E.bang_protect
	return number

/mob/living/carbon/is_mouth_covered(head_only = 0, mask_only = 0)
	if( (!mask_only && head && (head.flags_cover & HEADCOVERSMOUTH)) || (!head_only && wear_mask && (wear_mask.flags_cover & MASKCOVERSMOUTH)) )
		return TRUE

/mob/living/carbon/is_eyes_covered(check_glasses = 1, check_head = 1, check_mask = 1)
	if(check_glasses && glasses && (glasses.flags_cover & GLASSESCOVERSEYES))
		return TRUE
	if(check_head && head && (head.flags_cover & HEADCOVERSEYES))
		return TRUE
	if(check_mask && wear_mask && (wear_mask.flags_cover & MASKCOVERSMOUTH))
		return TRUE

/mob/living/carbon/check_projectile_dismemberment(obj/item/projectile/P, def_zone)
	var/obj/item/bodypart/affecting = get_bodypart(def_zone)
	if(affecting && affecting.dismemberable && affecting.get_damage() >= (affecting.max_damage - P.dismemberment))
		affecting.dismember(P.damtype)

/mob/living/carbon/catch_item(obj/item/I, skip_throw_mode_check = FALSE)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_AUTO_CATCH_ITEM) && !skip_throw_mode_check && !in_throw_mode)
		return
	if(incapacitated())
		return
	if (get_active_held_item())
		if (HAS_TRAIT_FROM(src, TRAIT_AUTO_CATCH_ITEM,RISING_BASS_TRAIT))
			visible_message("<span class='warning'>[src] chops [I] out of the air!</span>")
			return TRUE
		return
	I.attack_hand(src)
	if(get_active_held_item() == I) //if our attack_hand() picks up the item...
		visible_message("<span class='warning'>[src] catches [I]!</span>") //catch that sucker!
		throw_mode_off()
		return TRUE

/mob/living/carbon/embed_item(obj/item/I)
	throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
	var/obj/item/bodypart/L = pick(bodyparts)
	L.embedded_objects |= I
	I.add_mob_blood(src)//it embedded itself in you, of course it's bloody!
	I.forceMove(src)
	I.embedded()
	L.receive_damage(I.w_class*I.embedding.embedded_impact_pain_multiplier)
	visible_message("<span class='danger'>[I] embeds itself in [src]'s [L.name]!</span>","<span class='userdanger'>[I] embeds itself in your [L.name]!</span>")
	SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "embedded", /datum/mood_event/embedded)

/mob/living/carbon/attacked_by(obj/item/I, mob/living/user)
	var/totitemdamage = pre_attacked_by(I, user)
	var/impacting_zone = (user == src)? check_zone(user.zone_selected) : ran_zone(user.zone_selected)
	if((user != src) && (mob_run_block(I, totitemdamage, "the [I]", ATTACK_TYPE_MELEE, I.armour_penetration, user, impacting_zone, null) & BLOCK_SUCCESS))
		return FALSE
	var/obj/item/bodypart/affecting = get_bodypart(impacting_zone)
	if(!affecting) //missing limb? we select the first bodypart (you can never have zero, because of chest)
		affecting = bodyparts[1]
	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)
	send_item_attack_message(I, user, affecting.name)
	I.do_stagger_action(src, user, totitemdamage)
	if(I.force)
		apply_damage(totitemdamage, I.damtype, affecting) //CIT CHANGE - replaces I.force with totitemdamage
		if(I.damtype == BRUTE && affecting.status == BODYPART_ORGANIC)
			var/basebloodychance = affecting.brute_dam + totitemdamage
			if(prob(basebloodychance))
				I.add_mob_blood(src)
				var/turf/location = get_turf(src)
				add_splatter_floor(location)
				if(totitemdamage >= 10 && get_dist(user, src) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(src)

				if(affecting.body_zone == BODY_ZONE_HEAD)
					if(wear_mask && prob(basebloodychance))
						wear_mask.add_mob_blood(src)
						update_inv_wear_mask()
					if(wear_neck && prob(basebloodychance))
						wear_neck.add_mob_blood(src)
						update_inv_neck()
					if(head && prob(basebloodychance))
						head.add_mob_blood(src)
						update_inv_head()

		//dismemberment
		var/probability = I.get_dismemberment_chance(affecting)
		if(prob(probability))
			if(affecting.dismember(I.damtype))
				I.add_mob_blood(src)
				playsound(get_turf(src), I.get_dismember_sound(), 80, 1)
		return TRUE //successful attack

/mob/living/carbon/attack_drone(mob/living/simple_animal/drone/user)
	return //so we don't call the carbon's attack_hand().

//ATTACK HAND IGNORING PARENT RETURN VALUE
/mob/living/carbon/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.) //was the attack blocked?
		return
	for(var/thing in diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			user.ContactContractDisease(D)

	for(var/thing in user.diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	if(lying && surgeries.len)
		if(user.a_intent == INTENT_HELP || user.a_intent == INTENT_DISARM)
			for(var/datum/surgery/S in surgeries)
				if(S.next_step(user, user.a_intent))
					return TRUE


/mob/living/carbon/attack_paw(mob/living/carbon/monkey/M)

	if(can_inject(M, TRUE))
		for(var/thing in diseases)
			var/datum/disease/D = thing
			if((D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN) && prob(85))
				M.ContactContractDisease(D)

	for(var/thing in M.diseases)
		var/datum/disease/D = thing
		if(D.spread_flags & DISEASE_SPREAD_CONTACT_SKIN)
			ContactContractDisease(D)

	if(M.a_intent == INTENT_HELP)
		help_shake_act(M)
		return 0

	. = ..()
	if(.) //successful monkey bite.
		for(var/thing in M.diseases)
			var/datum/disease/D = thing
			ForceContractDisease(D)
		return 1


/mob/living/carbon/attack_slime(mob/living/simple_animal/slime/M)
	. = ..()
	if(!.)
		return
	if(M.powerlevel > 0)
		var/stunprob = M.powerlevel * 7 + 10  // 17 at level 1, 80 at level 10
		if(prob(stunprob))
			M.powerlevel -= 3
			if(M.powerlevel < 0)
				M.powerlevel = 0

			visible_message("<span class='danger'>The [M.name] has shocked [src]!</span>", \
			"<span class='userdanger'>The [M.name] has shocked you!</span>", target = M,
			target_message = "<span class='danger'>You have shocked [src]!</span>")

			do_sparks(5, TRUE, src)
			var/power = M.powerlevel + rand(0,3)
			DefaultCombatKnockdown(power*20)
			if(stuttering < power)
				stuttering = power
			if (prob(stunprob) && M.powerlevel >= 8)
				adjustFireLoss(M.powerlevel * rand(6,10))
				updatehealth()

/mob/living/carbon/proc/dismembering_strike(mob/living/attacker, dam_zone)
	if(!attacker.limb_destroyer)
		return dam_zone
	var/obj/item/bodypart/affecting
	if(dam_zone && attacker.client)
		affecting = get_bodypart(ran_zone(dam_zone))
	else
		var/list/things_to_ruin = shuffle(bodyparts.Copy())
		for(var/B in things_to_ruin)
			var/obj/item/bodypart/bodypart = B
			if(bodypart.body_zone == BODY_ZONE_HEAD || bodypart.body_zone == BODY_ZONE_CHEST)
				continue
			if(!affecting || ((affecting.get_damage() / affecting.max_damage) < (bodypart.get_damage() / bodypart.max_damage)))
				affecting = bodypart
	if(affecting)
		dam_zone = affecting.body_zone
		if(affecting.get_damage() >= affecting.max_damage)
			affecting.dismember()
			return null
		return affecting.body_zone
	return dam_zone


/mob/living/carbon/blob_act(obj/structure/blob/B)
	if (stat == DEAD)
		return
	else
		show_message("<span class='userdanger'>The blob attacks!</span>")
		adjustBruteLoss(10)

/mob/living/carbon/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/X in internal_organs)
		var/obj/item/organ/O = X
		O.emp_act(severity)

///Adds to the parent by also adding functionality to propagate shocks through pulling and doing some fluff effects.
/mob/living/carbon/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	. = ..()
	if(!.)
		return
	//Propagation through pulling, fireman carry
	if(!(flags & SHOCK_ILLUSION))
		var/list/shocking_queue = list()
		if(iscarbon(pulling) && source != pulling)
			shocking_queue += pulling
		if(iscarbon(pulledby) && source != pulledby)
			shocking_queue += pulledby
		if(iscarbon(buckled) && source != buckled)
			shocking_queue += buckled
		for(var/mob/living/carbon/carried in buckled_mobs)
			if(source != carried)
				shocking_queue += carried
		//Found our victims, now lets shock them all
		for(var/victim in shocking_queue)
			var/mob/living/carbon/C = victim
			C.electrocute_act(shock_damage*0.75, src, 1, flags)
	//Stun
	var/should_stun = (!(flags & SHOCK_TESLA) || siemens_coeff > 0.5) && !(flags & SHOCK_NOSTUN)
	if(should_stun)
		Stun(40)
	//Jitter and other fluff.
	jitteriness += 1000
	do_jitter_animation(jitteriness)
	stuttering += 2
	addtimer(CALLBACK(src, .proc/secondary_shock, should_stun), 20)
	return shock_damage

///Called slightly after electrocute act to reduce jittering and apply a secondary stun.
/mob/living/carbon/proc/secondary_shock(should_stun)
	jitteriness = max(jitteriness - 990, 10)
	if(should_stun)
		DefaultCombatKnockdown(60)

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(on_fire)
		to_chat(M, "<span class='warning'>You can't put [p_them()] out with just your bare hands!</span>")
		return

	if(health >= 0 && !(HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		var/friendly_check = FALSE
		if(mob_run_block(M, 0, M.name, ATTACK_TYPE_UNARMED, 0, null, null, null))
			return
		if(lying)
			if(buckled)
				to_chat(M, "<span class='warning'>You need to unbuckle [src] first to do that!")
				return
			M.visible_message("<span class='notice'>[M] shakes [src] trying to get [p_them()] up!</span>", \
							"<span class='notice'>You shake [src] trying to get [p_them()] up!</span>", target = src,
							target_message = "<span class='notice'>[M] shakes you trying to get you up!</span>")

		else if(M.zone_selected == BODY_ZONE_PRECISE_MOUTH) // I ADDED BOOP-EH-DEH-NOSEH - Jon
			M.visible_message( \
				"<span class='notice'>[M] boops [src]'s nose.</span>", \
				"<span class='notice'>You boop [src] on the nose.</span>", target = src,
				target_message = "<span class='notice'>[M] boops your nose.</span>")
			playsound(src, 'sound/items/Nose_boop.ogg', 50, 0)

		else if(check_zone(M.zone_selected) == BODY_ZONE_HEAD)
			var/datum/species/S
			if(ishuman(src))
				S = dna.species

			M.visible_message("<span class='notice'>[M] gives [src] a pat on the head to make [p_them()] feel better!</span>", \
						"<span class='notice'>You give [src] a pat on the head to make [p_them()] feel better!</span>", target = src,
						target_message = "<span class='notice'>[M] gives you a pat on the head to make you feel better!</span>")
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "headpat", /datum/mood_event/headpat)
			friendly_check = TRUE
			if(S?.can_wag_tail(src) && !dna.species.is_wagging_tail())
				var/static/list/many_tails = list("tail_human", "tail_lizard", "mam_tail")
				for(var/T in many_tails)
					if(S.mutant_bodyparts[T] && dna.features[T] != "None")
						emote("wag")
						break

		else if(check_zone(M.zone_selected) == BODY_ZONE_R_ARM || check_zone(M.zone_selected) == BODY_ZONE_L_ARM)
			M.visible_message( \
				"<span class='notice'>[M] shakes [src]'s hand.</span>", \
				"<span class='notice'>You shake [src]'s hand.</span>", target = src,
				target_message = "<span class='notice'>[M] shakes your hand.</span>")

		else
			M.visible_message("<span class='notice'>[M] hugs [src] to make [p_them()] feel better!</span>", \
						"<span class='notice'>You hug [src] to make [p_them()] feel better!</span>", target = src,\
						target_message = "<span class='notice'>[M] hugs you to make you feel better!</span>")
			SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "hug", /datum/mood_event/hug)
			friendly_check = TRUE

		if(friendly_check && HAS_TRAIT(M, TRAIT_FRIENDLY))
			var/datum/component/mood/mood = M.GetComponent(/datum/component/mood)
			if(mood)
				if (mood.sanity >= SANITY_GREAT)
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "friendly_hug", /datum/mood_event/besthug, M)
				else if (mood.sanity >= SANITY_DISTURBED)
					SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "friendly_hug", /datum/mood_event/betterhug, M)

		AdjustAllImmobility(-60, FALSE)
		AdjustUnconscious(-60, FALSE)
		AdjustSleeping(-100, FALSE)
		if(combat_flags & COMBAT_FLAG_HARD_STAMCRIT)
			adjustStaminaLoss(-15)
		else
			set_resting(FALSE, FALSE)
		update_mobility()
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)


/mob/living/carbon/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0)
	. = ..()

	var/damage = intensity - get_eye_protection()
	if(.) // we've been flashed
		var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
		if (!eyes)
			return
		if(visual)
			return

		if (damage == 1)
			to_chat(src, "<span class='warning'>Your eyes sting a little.</span>")
			if(prob(40))
				eyes.applyOrganDamage(1)

		else if (damage == 2)
			to_chat(src, "<span class='warning'>Your eyes burn.</span>")
			eyes.applyOrganDamage(rand(2, 4))

		else if( damage >= 3)
			to_chat(src, "<span class='warning'>Your eyes itch and burn severely!</span>")
			eyes.applyOrganDamage(rand(12, 16))

		if(eyes.damage > 10)
			blind_eyes(damage)
			blur_eyes(damage * rand(3, 6))

			if(eyes.damage > 20)
				if(prob(eyes.damage - 20))
					if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
						to_chat(src, "<span class='warning'>Your eyes start to burn badly!</span>")
					become_nearsighted(EYE_DAMAGE)

				else if(prob(eyes.damage - 25))
					if(!HAS_TRAIT(src, TRAIT_BLIND))
						to_chat(src, "<span class='warning'>You can't see anything!</span>")
					eyes.applyOrganDamage(eyes.maxHealth)

			else
				to_chat(src, "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>")
		if(has_bane(BANE_LIGHT))
			mind.disrupt_spells(-500)
		return 1
	else if(damage == 0) // just enough protection
		if(prob(20))
			to_chat(src, "<span class='notice'>Something bright flashes in the corner of your vision!</span>")
		if(has_bane(BANE_LIGHT))
			mind.disrupt_spells(0)


/mob/living/carbon/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	var/list/reflist = list(intensity) // Need to wrap this in a list so we can pass a reference
	SEND_SIGNAL(src, COMSIG_CARBON_SOUNDBANG, reflist)
	intensity = reflist[1]
	var/ear_safety = get_ear_protection()
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	var/effect_amount = intensity - ear_safety
	if(effect_amount > 0)
		if(stun_pwr)
			DefaultCombatKnockdown(stun_pwr*effect_amount)

		if(istype(ears) && (deafen_pwr || damage_pwr))
			var/ear_damage = damage_pwr * effect_amount
			var/deaf = deafen_pwr * effect_amount
			adjustEarDamage(ear_damage,deaf)

			if(ears.damage >= 15)
				to_chat(src, "<span class='warning'>Your ears start to ring badly!</span>")
				if(prob(ears.damage - 5))
					to_chat(src, "<span class='userdanger'>You can't hear anything!</span>")
					ears.damage = min(ears.damage, ears.maxHealth)
					// you need earmuffs, inacusiate, or replacement
			else if(ears.damage >= 5)
				to_chat(src, "<span class='warning'>Your ears start to ring!</span>")
			SEND_SOUND(src, sound('sound/weapons/flash_ring.ogg',0,1,0,250))
		return effect_amount //how soundbanged we are


/mob/living/carbon/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/hit_clothes
		if(wear_mask)
			hit_clothes = wear_mask
		if(wear_neck)
			hit_clothes = wear_neck
		if(head)
			hit_clothes = head
		if(hit_clothes)
			hit_clothes.take_damage(damage_amount, damage_type, damage_flag, 0)

/mob/living/carbon/can_hear()
	. = FALSE
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	if(istype(ears) && !ears.deaf)
		. = TRUE

/mob/living/carbon/getBruteLoss_nonProsthetic()
	var/amount = 0
	for(var/obj/item/bodypart/BP in bodyparts)
		if (BP.status < 2)
			amount += BP.brute_dam
	return amount

/mob/living/carbon/getFireLoss_nonProsthetic()
	var/amount = 0
	for(var/obj/item/bodypart/BP in bodyparts)
		if (BP.status < 2)
			amount += BP.burn_dam
	return amount
