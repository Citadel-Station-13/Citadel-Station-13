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
	if(target.check_block())
		target.visible_message("<span class='warning'>[target] blocks [user]'s shoving attempt!</span>")
		return FALSE
	if(attacker_style && attacker_style.disarm_act(user,target))
		return TRUE
	if(user.resting)
		return FALSE
	else
		if(user == target)
			return
		user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
		user.adjustStaminaLossBuffered(4)
		playsound(target, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)

		if(target.w_uniform)
			target.w_uniform.add_fingerprint(user)
		SEND_SIGNAL(target, COMSIG_HUMAN_DISARM_HIT, user, user.zone_selected)

		if(!target.resting)
			target.adjustStaminaLoss(5)


		var/turf/target_oldturf = target.loc
		var/shove_dir = get_dir(user.loc, target_oldturf)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)
		var/mob/living/carbon/human/target_collateral_human
		var/obj/structure/table/target_table
		var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied

		//Thank you based whoneedsspace
		target_collateral_human = locate(/mob/living/carbon/human) in target_shove_turf.contents
		if(target_collateral_human)
			shove_blocked = TRUE
		else
			target.Move(target_shove_turf, shove_dir)
			if(get_turf(target) == target_oldturf)
				if(target_shove_turf.density)
					shove_blocked = TRUE
				else
					var/thoushallnotpass = FALSE
					for(var/obj/O in target_shove_turf)
						if(istype(O, /obj/structure/table))
							target_table = O
						else if(!O.CanPass(src, target_shove_turf))
							shove_blocked = TRUE
							thoushallnotpass = TRUE
					if(thoushallnotpass)
						target_table = null

		if(target.is_shove_knockdown_blocked())
			return

		if(shove_blocked || target_table)
			var/directional_blocked = FALSE
			if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
				var/target_turf = get_turf(target)
				for(var/obj/O in target_turf)
					if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
						directional_blocked = TRUE
						break
				if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
					for(var/obj/O in target_shove_turf)
						if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
							directional_blocked = TRUE
							break
			var/targetatrest = target.resting
			if(((!target_table && !target_collateral_human) || directional_blocked) && !targetatrest)
				target.Knockdown(SHOVE_KNOCKDOWN_SOLID)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name], knocking them down!</span>",
					"<span class='danger'>You shove [target.name], knocking them down!</span>", null, COMBAT_MESSAGE_RANGE)
				log_combat(user, target, "shoved", "knocking them down")
			else if(target_table)
				if(!targetatrest)
					target.Knockdown(SHOVE_KNOCKDOWN_TABLE)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name] onto \the [target_table]!</span>",
					"<span class='danger'>You shove [target.name] onto \the [target_table]!</span>", null, COMBAT_MESSAGE_RANGE)
				target.forceMove(target_shove_turf)
				log_combat(user, target, "shoved", "onto [target_table]")
			else if(target_collateral_human && !targetatrest)
				target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
				if(!target_collateral_human.resting)
					target_collateral_human.Knockdown(SHOVE_KNOCKDOWN_COLLATERAL)
				user.visible_message("<span class='danger'>[user.name] shoves [target.name] into [target_collateral_human.name]!</span>",
					"<span class='danger'>You shove [target.name] into [target_collateral_human.name]!</span>", null, COMBAT_MESSAGE_RANGE)
				log_combat(user, target, "shoved", "into [target_collateral_human.name]")

		else
			user.visible_message("<span class='danger'>[user.name] shoves [target.name]!</span>",
				"<span class='danger'>You shove [target.name]!</span>", null, COMBAT_MESSAGE_RANGE)
			var/target_held_item = target.get_active_held_item()
			var/knocked_item = FALSE
			if(!is_type_in_typecache(target_held_item, GLOB.shove_disarming_types))
				target_held_item = null
			if(!target.has_movespeed_modifier(SHOVE_SLOWDOWN_ID))
				target.add_movespeed_modifier(SHOVE_SLOWDOWN_ID, multiplicative_slowdown = SHOVE_SLOWDOWN_STRENGTH)
				if(target_held_item)
					target.visible_message("<span class='danger'>[target.name]'s grip on \the [target_held_item] loosens!</span>",
						"<span class='danger'>Your grip on \the [target_held_item] loosens!</span>", null, COMBAT_MESSAGE_RANGE)
				addtimer(CALLBACK(target, /mob/living/carbon/human/proc/clear_shove_slowdown), SHOVE_SLOWDOWN_LENGTH)
			else if(target_held_item)
				target.dropItemToGround(target_held_item)
				knocked_item = TRUE
				target.visible_message("<span class='danger'>[target.name] drops \the [target_held_item]!!</span>",
					"<span class='danger'>You drop \the [target_held_item]!!</span>", null, COMBAT_MESSAGE_RANGE)
			var/append_message = ""
			if(target_held_item)
				if(knocked_item)
					append_message = "causing them to drop [target_held_item]"
				else
					append_message = "loosening their grip on [target_held_item]"
			log_combat(user, target, "shoved", append_message)


////////////////////
/////BODYPARTS/////
////////////////////


/obj/item/bodypart
	var/should_draw_citadel = FALSE
