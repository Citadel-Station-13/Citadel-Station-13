/mob/living/simple_animal/bot/secbot
	name = "\improper Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "secbot"
	density = FALSE
	anchored = FALSE
	health = 25
	maxHealth = 25
	damage_coeff = list(BRUTE = 0.5, BURN = 0.7, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	pass_flags = PASSMOB

	radio_key = /obj/item/encryptionkey/secbot //AI Priv + Security
	radio_channel = RADIO_CHANNEL_SECURITY //Security channel
	bot_type = SEC_BOT
	model = "Securitron"
	bot_core_type = /obj/machinery/bot_core/secbot
	window_id = "autosec"
	window_name = "Automatic Security Unit v1.6"
	allow_pai = 0
	data_hud_type = DATA_HUD_SECURITY_ADVANCED
	path_image_color = "#FF0000"

	var/baton_type = /obj/item/melee/baton
	var/mob/living/carbon/target
	var/oldtarget_name
	var/threatlevel = FALSE
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/declare_arrests = TRUE //When making an arrest, should it notify everyone on the security channel?
	var/idcheck = FALSE //If true, arrest people with no IDs
	var/weaponscheck = FALSE //If true, arrest people for weapons if they lack access
	var/check_records = TRUE //Does it check security records?
	var/arrest_type = FALSE //If true, don't handcuff

	var/obj/item/clothing/head/bot_accessory
	var/datum/beepsky_fashion/stored_fashion

	//emotes (BOT is replaced with bot name, CRIMINAL with criminal name, THREAT_LEVEL with threat level)
	var/death_emote = "BOT blows apart!"
	var/capture_one = "BOT is trying to put zipties on CRIMINAL!"
	var/capture_two = "BOT is trying to put zipties on you!"
	var/infraction = "Level THREAT_LEVEL infraction alert!"
	var/taunt = "<b>BOT</b> points at CRIMINAL!"
	var/attack_one = "BOT has stunned CRIMINAL!"
	var/attack_two = "BOT has stunned you!"
	var/list/arrest_texts = list("Detaining", "Arresting")
	var/arrest_emote = "ARREST_TYPE level THREAT_LEVEL scumbag CRIMINAL in LOCATION."

/mob/living/simple_animal/bot/secbot/beepsky
	name = "Officer Beep O'sky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	idcheck = FALSE
	weaponscheck = FALSE
	auto_patrol = TRUE

/mob/living/simple_animal/bot/secbot/beepsky/jr
	name = "Officer Pipsqueak"
	desc = "It's Officer Beep O'sky's smaller, just-as aggressive cousin, Pipsqueak."

/mob/living/simple_animal/bot/secbot/beepsky/jr/Initialize(mapload)
	. = ..()
	resize = 0.8
	update_transform()

/mob/living/simple_animal/bot/secbot/proc/process_emote(var/emote_type, var/atom/criminal, var/threat, var/arrest = -1, var/location)
	var/emote = "The continuity of space itself collapses around [src]. You should probably report that to someone higher up."
	switch(emote_type)
		if("DEATH")
			emote = death_emote
		if("CAPTURE_ONE")
			emote = capture_one
		if("CAPTURE_TWO")
			emote = capture_two
		if("INFRACTION")
			emote = infraction
		if("TAUNT")
			emote = taunt
		if("ATTACK_ONE")
			emote = attack_one
		if("ATTACK_TWO")
			emote = attack_two
		if("ARREST")
			emote = arrest_emote

	//now replace pieces of the text with the information we have
	if(emote_type != "TAUNT" && emote_type != "ARREST")
		emote = replacetext(emote, "BOT", name)
	else
		emote = replacetext(emote, "BOT", "<b>[name]</b>") //needs to be bold if its a taunt or an arrest text
	if(criminal)
		emote = replacetext(emote, "CRIMINAL", criminal.name)
	if(num2text(threat)) //because a threat of 0 will be false
		emote = replacetext(emote, "THREAT_LEVEL", threat)
	if(arrest > -1)
		emote = replacetext(emote, "ARREST_TYPE", arrest_texts[arrest + 1])
	if(location)
		emote = replacetext(emote, "LOCATION", location)
	return emote

/mob/living/simple_animal/bot/secbot/proc/apply_fashion(var/datum/beepsky_fashion/fashion)
	stored_fashion = new fashion
	if(stored_fashion.name)
		name = stored_fashion.name

	if(stored_fashion.desc)
		desc = stored_fashion.desc

	if(stored_fashion.death_emote)
		death_emote = stored_fashion.death_emote

	if(stored_fashion.capture_one)
		capture_one = stored_fashion.capture_one

	if(stored_fashion.capture_two)
		capture_two = stored_fashion.capture_two

	if(stored_fashion.infraction)
		infraction = stored_fashion.infraction

	if(stored_fashion.taunt)
		taunt = stored_fashion.taunt

	if(stored_fashion.attack_one)
		attack_one = stored_fashion.attack_one

	if(stored_fashion.attack_two)
		attack_two = stored_fashion.attack_two

	if(stored_fashion.patrol_emote)
		patrol_emote = stored_fashion.patrol_emote

	if(stored_fashion.patrol_fail_emote)
		patrol_fail_emote = stored_fashion.patrol_fail_emote

	if(stored_fashion.arrest_texts)
		arrest_texts = stored_fashion.arrest_texts

	if(stored_fashion.arrest_emote)
		arrest_emote = stored_fashion.arrest_emote

	regenerate_icons()

/mob/living/simple_animal/bot/secbot/proc/reset_fashion()
	bot_accessory.forceMove(get_turf(src))
	//reset all emotes/sounds and name/desc
	name = initial(name)
	desc = initial(desc)
	death_emote = initial(death_emote)
	capture_one = initial(capture_one)
	capture_two = initial(capture_two)
	infraction = initial(infraction)
	taunt = initial(taunt)
	attack_one = initial(attack_one)
	attack_two = initial(attack_two)
	arrest_texts = initial(arrest_texts)
	arrest_emote = initial(arrest_emote)
	patrol_emote = initial(patrol_emote)
	arrest_texts = initial(arrest_texts)
	arrest_emote = initial(arrest_emote)
	bot_accessory = null
	regenerate_icons()

/mob/living/simple_animal/bot/secbot/beepsky/explode()
	var/atom/Tsec = drop_location()
	new /obj/item/stock_parts/cell/potato(Tsec)
	var/obj/item/reagent_containers/food/drinks/drinkingglass/shotglass/S = new(Tsec)
	S.reagents.add_reagent(/datum/reagent/consumable/ethanol/whiskey, 15)
	S.on_reagent_change(ADD_REAGENT)
	..()

/mob/living/simple_animal/bot/secbot/pingsky
	name = "Officer Pingsky"
	desc = "It's Officer Pingsky! Delegated to satellite guard duty for harbouring anti-human sentiment."
	radio_channel = RADIO_CHANNEL_AI_PRIVATE

/mob/living/simple_animal/bot/secbot/Initialize(mapload)
	. = ..()
	update_icon()
	var/datum/job/detective/J = new/datum/job/detective
	access_card.access += J.get_access()
	prev_access = access_card.access

	//SECHUD
	var/datum/atom_hud/secsensor = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	secsensor.add_hud_to(src)

/mob/living/simple_animal/bot/secbot/update_icon()
	if(mode == BOT_HUNT)
		icon_state = "[initial(icon_state)]-c"
		return
	..()

/mob/living/simple_animal/bot/secbot/turn_off()
	..()
	mode = BOT_IDLE

/mob/living/simple_animal/bot/secbot/bot_reset()
	..()
	target = null
	oldtarget_name = null
	anchored = FALSE
	walk_to(src,0)
	last_found = world.time

/mob/living/simple_animal/bot/secbot/set_custom_texts()

	text_hack = "You overload [name]'s target identification system."
	text_dehack = "You reboot [name] and restore the target identification."
	text_dehack_fail = "[name] refuses to accept your authority!"

// Variables sent to TGUI
/mob/living/simple_animal/bot/secbot/ui_data(mob/user)
	var/list/data = ..()
	if(!locked || hasSiliconAccessInArea(user) || IsAdminGhost(user))
		data["custom_controls"]["check_id"] = idcheck
		data["custom_controls"]["check_weapons"] = weaponscheck
		data["custom_controls"]["check_warrants"] = check_records
		data["custom_controls"]["handcuff_targets"] = !arrest_type
		data["custom_controls"]["arrest_alert"] = declare_arrests
	return data

// Actions received from TGUI
/mob/living/simple_animal/bot/secbot/ui_act(action, params)
	. = ..()
	if(. || !hasSiliconAccessInArea(usr) && !IsAdminGhost(usr) && !(bot_core.allowed(usr) || !locked))
		return TRUE
	switch(action)
		if("check_id")
			idcheck = !idcheck
		if("check_weapons")
			weaponscheck = !weaponscheck
		if("check_warrants")
			check_records = !check_records
		if("handcuff_targets")
			arrest_type = !arrest_type
		if("arrest_alert")
			declare_arrests = !declare_arrests
	return

/mob/living/simple_animal/bot/secbot/proc/retaliate(mob/living/carbon/human/H)
	var/judgement_criteria = judgement_criteria()
	threatlevel = H.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))
	threatlevel += 6
	if(threatlevel >= 4)
		target = H
		mode = BOT_HUNT

/mob/living/simple_animal/bot/secbot/proc/judgement_criteria()
	var/final = FALSE
	if(idcheck)
		final = final|JUDGE_IDCHECK
	if(check_records)
		final = final|JUDGE_RECORDCHECK
	if(weaponscheck)
		final = final|JUDGE_WEAPONCHECK
	if(emagged == 2)
		final = final|JUDGE_EMAGGED
	return final

/mob/living/simple_animal/bot/secbot/proc/special_retaliate_after_attack(mob/user) //allows special actions to take place after being attacked.
	return

/mob/living/simple_animal/bot/secbot/on_attack_hand(mob/living/carbon/human/H)
	if((H.a_intent == INTENT_HARM) || (H.a_intent == INTENT_DISARM))
		retaliate(H)
		if(special_retaliate_after_attack(H))
			return
	if(H.a_intent == INTENT_HELP && bot_accessory)

		to_chat(H, "<span class='warning'>You knock [bot_accessory] off of [src]'s head!</span>")
		reset_fashion()
		return

	return ..()

/mob/living/simple_animal/bot/secbot/attackby(obj/item/W, mob/user, params)
	..()
	if(W.tool_behaviour == TOOL_WELDER && user.a_intent != INTENT_HARM) // Any intent but harm will heal, so we shouldn't get angry.
		return
	if(istype(W, /obj/item/clothing/head))
		attempt_place_on_head(user, W)
		return
	if(!W.tool_behaviour == TOOL_SCREWDRIVER && (W.force) && (!target) && (W.damtype != STAMINA) ) // Added check for welding tool to fix #2432. Welding tool behavior is handled in superclass.
		retaliate(user)
		if(special_retaliate_after_attack(user))
			return

/mob/living/simple_animal/bot/secbot/proc/attempt_place_on_head(mob/user, obj/item/clothing/head/H)
	if(user && !user.temporarilyRemoveItemFromInventory(H))
		to_chat(user, "<span class='warning'>\The [H] is stuck to your hand, you cannot put it on [src]'s head!</span>")
		return
	if(bot_accessory)
		to_chat("<span class='warning'>\[src] already has an accessory, and the laws of physics disallow him from wearing a second!</span>")
		return

	if(H.beepsky_fashion)
		to_chat(user, "<span class='warning'>You set [H] on [src].</span>")
		bot_accessory = H
		H.forceMove(src)
		apply_fashion(H.beepsky_fashion)
	else
		to_chat(user, "<span class='warning'>You set [H] on [src]'s head, but it falls off!</span>")
		H.forceMove(drop_location())

/mob/living/simple_animal/bot/secbot/regenerate_icons()
	..()
	if(bot_accessory)
		if(!stored_fashion)
			stored_fashion = new bot_accessory.beepsky_fashion
		if(!stored_fashion.obj_icon_state)
			stored_fashion.obj_icon_state = bot_accessory.icon_state
		if(!stored_fashion.obj_alpha)
			stored_fashion.obj_alpha = bot_accessory.alpha
		if(!stored_fashion.obj_color)
			stored_fashion.obj_color = bot_accessory.color
		add_overlay(stored_fashion.get_overlay())
	else
		if(stored_fashion)
			cut_overlay(stored_fashion.get_overlay())
			stored_fashion = null

/mob/living/simple_animal/bot/secbot/emag_act(mob/user)
	. = ..()
	if(emagged == 2)
		if(user)
			to_chat(user, "<span class='danger'>You short out [src]'s target assessment circuits.</span>")
			oldtarget_name = user.name
		audible_message("<span class='danger'>[src] buzzes oddly!</span>")
		declare_arrests = FALSE
		update_icon()

/mob/living/simple_animal/bot/secbot/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj , /obj/item/projectile/beam)||istype(Proj, /obj/item/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < src.health && ishuman(Proj.firer))
				retaliate(Proj.firer)
	return ..()


/mob/living/simple_animal/bot/secbot/UnarmedAttack(atom/A, proximity, intent = a_intent, flags = NONE)
	if(!on)
		return
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(CHECK_MOBILITY(C, MOBILITY_MOVE|MOBILITY_USE|MOBILITY_STAND) || arrest_type) // CIT CHANGE - makes sentient secbots check for canmove rather than !isstun.
			stun_attack(A)
		else if(C.canBeHandcuffed() && !C.handcuffed)
			cuff(A)
	else
		..()


/mob/living/simple_animal/bot/secbot/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		if(I.throwforce < src.health && I.thrownby && ishuman(I.thrownby))
			var/mob/living/carbon/human/H = I.thrownby
			retaliate(H)
	..()


/mob/living/simple_animal/bot/secbot/proc/cuff(mob/living/carbon/C)
	mode = BOT_ARREST
	playsound(src, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
	C.visible_message("<span class='danger'>[process_emote("CAPTURE_ONE", C)]</span>",\
						"<span class='userdanger'>[process_emote("CAPTURE_TWO", C)]</span>")
	if(do_after(src, 60, C))
		attempt_handcuff(C)

/mob/living/simple_animal/bot/secbot/proc/attempt_handcuff(mob/living/carbon/C)
	if (!on)
		return
	if(!C.handcuffed)
		C.handcuffed = new /obj/item/restraints/handcuffs/cable/zipties/used(C)
		C.update_handcuffed()
		playsound(src, "law", 50, 0)
		back_to_idle()

/mob/living/simple_animal/bot/secbot/proc/stun_attack(mob/living/carbon/C)
	var/judgement_criteria = judgement_criteria()
	icon_state = "secbot-c"
	addtimer(CALLBACK(src, /atom/.proc/update_icon), 2)
	var/threat = 5
	if(ishuman(C))
		if(stored_fashion)
			stored_fashion.stun_attack(C)
			if(stored_fashion.stun_sounds && !stored_fashion.ignore_sound)
				playsound(src, pick(stored_fashion.stun_sounds), 50, TRUE, -1)
			else
				playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
		C.stuttering = 5
		C.DefaultCombatKnockdown(100)
		var/mob/living/carbon/human/H = C
		threat = H.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))
	else
		playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)
		C.DefaultCombatKnockdown(100)
		C.stuttering = 5
		threat = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

	log_combat(src,C,"stunned")
	if(declare_arrests)
		var/area/location = get_area(src)
		speak(process_emote("ARREST", C, threat, arrest_type, location), radio_channel)
	C.visible_message("<span class='danger'>[process_emote("ATTACK_ONE", C)]</span>",\
							"<span class='userdanger'>[process_emote("ATTACK_TWO", C)]</span>")

/mob/living/simple_animal/bot/secbot/handle_automated_action()
	if(!..())
		return

	switch(mode)

		if(BOT_IDLE)		// idle

			walk_to(src,0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = BOT_START_PATROL	// switch to patrol mode

		if(BOT_HUNT)		// hunting for perp

			// if can't reach perp for long enough, go idle
			if(frustration >= 8)
				walk_to(src,0)
				back_to_idle()
				return

			if(target)		// make sure target exists
				if(Adjacent(target) && isturf(target.loc))	// if right next to perp
					stun_attack(target)

					mode = BOT_PREP_ARREST
					anchored = TRUE
					target_lastloc = target.loc
					return

				else								// not next to perp
					var/turf/olddist = get_dist(src, target)
					walk_to(src, target,1,4)
					if((get_dist(src, target)) >= (olddist))
						frustration++
					else
						frustration = 0
			else
				back_to_idle()

		if(BOT_PREP_ARREST)		// preparing to arrest target

			// see if he got away. If he's no no longer adjacent or inside a closet or about to get up, we hunt again.
			if( !Adjacent(target) || !isturf(target.loc) || target.getStaminaLoss() <= 120 || !(target.combat_flags & COMBAT_FLAG_HARD_STAMCRIT)) //CIT CHANGE - replaces amountknockdown with checks for stamina so secbots dont run into an infinite loop
				back_to_hunt()
				return

			if(iscarbon(target) && target.canBeHandcuffed())
				if(!arrest_type)
					if(!target.handcuffed)  //he's not cuffed? Try to cuff him!
						cuff(target)
					else
						back_to_idle()
						return
			else
				back_to_idle()
				return

		if(BOT_ARREST)
			if(!target)
				anchored = FALSE
				mode = BOT_IDLE
				last_found = world.time
				frustration = 0
				return

			if(target.handcuffed) //no target or target cuffed? back to idle.
				back_to_idle()
				return

			if(!Adjacent(target) || !isturf(target.loc) || (target.loc != target_lastloc && !(target.combat_flags & COMBAT_FLAG_HARD_STAMCRIT) && target.getStaminaLoss() <= 120)) //if he's changed loc and about to get up or not adjacent or got into a closet, we prep arrest again. CIT CHANGE - replaces amountknockdown with recoveringstam and staminaloss check
				back_to_hunt()
				return
			else //Try arresting again if the target escapes.
				mode = BOT_PREP_ARREST
				anchored = FALSE

		if(BOT_START_PATROL)
			look_for_perp()
			start_patrol()

		if(BOT_PATROL)
			look_for_perp()
			bot_patrol()

	return

/mob/living/simple_animal/bot/secbot/proc/back_to_idle()
	anchored = FALSE
	mode = BOT_IDLE
	target = null
	last_found = world.time
	frustration = 0
	INVOKE_ASYNC(src, .proc/handle_automated_action)

/mob/living/simple_animal/bot/secbot/proc/back_to_hunt()
	anchored = FALSE
	frustration = 0
	mode = BOT_HUNT
	INVOKE_ASYNC(src, .proc/handle_automated_action)
// look for a criminal in view of the bot

/mob/living/simple_animal/bot/secbot/proc/look_for_perp()
	anchored = FALSE
	var/judgement_criteria = judgement_criteria()
	for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
		if((C.stat) || (C.handcuffed))
			continue

		if((C.name == oldtarget_name) && (world.time < last_found + 100))
			continue

		threatlevel = C.assess_threat(judgement_criteria, weaponcheck=CALLBACK(src, .proc/check_for_weapons))

		if(!threatlevel)
			continue

		else if(threatlevel >= 4)
			target = C
			oldtarget_name = C.name
			speak(process_emote("INFRACTION", target, threatlevel))
			playsound(loc, pick('sound/voice/beepsky/criminal.ogg', 'sound/voice/beepsky/justice.ogg', 'sound/voice/beepsky/freeze.ogg'), 50, FALSE)
			visible_message(process_emote("TAUNT", target, threatlevel))
			mode = BOT_HUNT
			INVOKE_ASYNC(src, .proc/handle_automated_action)
			break
		else
			continue

/mob/living/simple_animal/bot/secbot/proc/check_for_weapons(var/obj/item/slot_item)
	if(slot_item && (slot_item.item_flags & NEEDS_PERMIT))
		return TRUE
	return FALSE

/mob/living/simple_animal/bot/secbot/explode()

	walk_to(src,0)
	visible_message("<span class='boldannounce'>[process_emote("DEATH")]</span>")
	var/atom/Tsec = drop_location()

	var/obj/item/bot_assembly/secbot/Sa = new (Tsec)
	Sa.build_step = ASSEMBLY_SECOND_STEP
	Sa.add_overlay("hs_hole")
	Sa.created_name = name
	new /obj/item/assembly/prox_sensor(Tsec)
	drop_part(baton_type, Tsec)

	if(prob(50))
		drop_part(robot_arm, Tsec)

	do_sparks(3, TRUE, src)

	new /obj/effect/decal/cleanable/oil(loc)
	..()

/mob/living/simple_animal/bot/secbot/attack_alien(var/mob/living/carbon/alien/user as mob)
	..()
	if(!isalien(target))
		target = user
		mode = BOT_HUNT

/mob/living/simple_animal/bot/secbot/Crossed(atom/movable/AM)
	if(has_gravity() && ismob(AM) && target)
		var/mob/living/carbon/C = AM
		if(!istype(C) || !C || in_range(src, target))
			return
		knockOver(C)
		return
	..()

/obj/machinery/bot_core/secbot
	req_access = list(ACCESS_SECURITY)
