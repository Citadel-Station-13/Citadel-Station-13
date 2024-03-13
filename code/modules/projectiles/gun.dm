
#define DUALWIELD_PENALTY_EXTRA_MULTIPLIER 1.4
#define FIRING_PIN_REMOVAL_DELAY 50

/obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=2000)
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	item_flags = NEEDS_PERMIT
	attack_verb = list("struck", "hit", "bashed")
	attack_speed = CLICK_CD_RANGE
	var/ranged_attack_speed = CLICK_CD_RANGE
	var/melee_attack_speed = CLICK_CD_MELEE

	var/gun_flags = NONE
	var/fire_sound = "gunshot"
	var/suppressed = null					//whether or not a message is displayed when fired
	var/can_suppress = FALSE
	var/can_unsuppress = TRUE
	var/recoil = 0						//boom boom shake the room
	var/clumsy_check = TRUE
	var/obj/item/ammo_casing/chambered = null
	trigger_guard = TRIGGER_GUARD_NORMAL	//trigger guard on the weapon, hulks can't fire them with their big meaty fingers
	var/sawn_desc = null				//description change if weapon is sawn-off
	var/sawn_off = FALSE
	var/firing_burst = 0 //Prevent the weapon from firing again while already firing

	/// can we be put into a turret
	var/can_turret = TRUE
	/// can we be put in a circuit
	var/can_circuit = TRUE
	/// can we be put in an emitter
	var/can_emitter = TRUE

	/// Weapon is burst fire if this is above 1
	var/burst_size = 1
	/// The time between shots in burst.
	var/burst_shot_delay = 3
	/// The time between firing actions, this means between bursts if this is burst weapon. The reason this is 0 is because you are still, by default, limited by clickdelay.
	var/fire_delay = 0
	/// Last world.time this was fired
	var/last_fire = 0
	/// Currently firing, whether or not it's a burst or not.
	var/firing = FALSE
	/// Used in gun-in-mouth execution/suicide and similar, while TRUE nothing should work on this like firing or modification and so on and so forth.
	var/busy_action = FALSE
	var/weapon_weight = WEAPON_LIGHT	//used for inaccuracy and wielding requirements/penalties
	var/spread = 0						//Spread induced by the gun itself.
	var/burst_spread = 0				//Spread induced by the gun itself during burst fire per iteration. Only checked if spread is 0.
	var/randomspread = 1				//Set to 0 for shotguns. This is used for weapons that don't fire all their bullets at once.
	var/inaccuracy_modifier = 1
	var/semicd = 0 //cooldown handler
	var/dual_wield_spread = 24 //additional spread when dual wielding

	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'

	var/obj/item/firing_pin/pin = /obj/item/firing_pin //standard firing pin for most guns
	var/no_pin_required = FALSE //whether the gun can be fired without a pin

	var/obj/item/flashlight/seclite/gun_light
	var/can_flashlight = FALSE
	var/gunlight_state = "flight"
	var/obj/item/kitchen/knife/bayonet
	var/mutable_appearance/knife_overlay
	var/can_bayonet = FALSE
	var/datum/action/item_action/toggle_gunlight/alight
	var/mutable_appearance/flashlight_overlay

	var/ammo_x_offset = 0 //used for positioning ammo count overlay on sprite
	var/ammo_y_offset = 0
	var/flight_x_offset = 0
	var/flight_y_offset = 0
	var/knife_x_offset = 0
	var/knife_y_offset = 0

	//Zooming
	var/zoomable = FALSE //whether the gun generates a Zoom action on creation
	var/zoomed = FALSE //Zoom toggle
	var/zoom_amt = 3 //Distance in TURFs to move the user's screen forward (the "zoom" effect)
	var/zoom_out_amt = 0
	var/datum/action/item_action/toggle_scope_zoom/azoom

	//Firemodes
	var/datum/action/item_action/toggle_firemode/firemode_action
	/// Current fire selection, can choose between burst, single, and full auto.
	var/fire_select = SELECT_SEMI_AUTOMATIC
	var/fire_select_index = 1
	/// What modes does this weapon have? Put SELECT_FULLY_AUTOMATIC in here to enable fully automatic behaviours.
	var/list/fire_select_modes = list(SELECT_SEMI_AUTOMATIC)
	/// if i`1t has an icon for a selector switch indicating current firemode.
	var/selector_switch_icon = FALSE

	var/dualwield_spread_mult = 1		//dualwield spread multiplier

	/// Just 'slightly' snowflakey way to modify projectile damage for projectiles fired from this gun.
	var/projectile_damage_multiplier = 1

	/// directional recoil multiplier
	var/dir_recoil_amp = 10

/obj/item/gun/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_firemode))
		fire_select()
	else if(istype(action, /datum/action/item_action/toggle_scope_zoom))
		zoom(user, user.dir)
	else if(istype(action, alight))
		toggle_gunlight()
	else
		..()

/obj/item/gun/Initialize(mapload)
	. = ..()
	if(pin)
		pin = new pin(src)

	if(gun_light)
		alight = new(src)

	if(zoomable)
		azoom = new (src)

	if(burst_size > 1 && !(SELECT_BURST_SHOT in fire_select_modes))
		fire_select_modes.Add(SELECT_BURST_SHOT)
	else if(burst_size <= 1 && (SELECT_BURST_SHOT in fire_select_modes))
		fire_select_modes.Remove(SELECT_BURST_SHOT)

	burst_size = 1

	sort_list(fire_select_modes, GLOBAL_PROC_REF(cmp_numeric_asc))

	if(fire_select_modes.len > 1)
		firemode_action = new(src)
		firemode_action.button_icon_state = "fireselect_[fire_select]"
		firemode_action.UpdateButtons()

/obj/item/gun/ComponentInitialize()
	. = ..()
	if(SELECT_FULLY_AUTOMATIC in fire_select_modes)
		AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/Destroy()
	if(pin)
		QDEL_NULL(pin)
	if(gun_light)
		QDEL_NULL(gun_light)
	if(bayonet)
		QDEL_NULL(bayonet)
	if(chambered)
		QDEL_NULL(chambered)
	if(azoom)
		QDEL_NULL(azoom)
	if(firemode_action)
		QDEL_NULL(firemode_action)
	return ..()

/obj/item/gun/examine(mob/user)
	. = ..()
	if(!no_pin_required)
		if(pin)
			. += "It has \a [pin] installed."
			. += "<span class='info'>[pin] looks like it could be removed with some <b>tools</b>.</span>"
		else
			. += "It doesn't have a firing pin installed, and won't fire."

	if(gun_light)
		. += "It has \a [gun_light] [can_flashlight ? "" : "permanently "]mounted on it."
		if(can_flashlight) //if it has a light and this is false, the light is permanent.
			. += "<span class='info'>[gun_light] looks like it can be <b>unscrewed</b> from [src].</span>"
	else if(can_flashlight)
		. += "It has a mounting point for a <b>seclite</b>."

	if(bayonet)
		. += "It has \a [bayonet] [can_bayonet ? "" : "permanently "]affixed to it."
		if(can_bayonet) //if it has a bayonet and this is false, the bayonet is permanent.
			. += "<span class='info'>[bayonet] looks like it can be <b>unscrewed</b> from [src].</span>"
	else if(can_bayonet)
		. += "It has a <b>bayonet</b> lug on it."

/obj/item/gun/proc/fire_select()
	var/mob/living/carbon/human/user = usr

	var/max_mode = fire_select_modes.len

	if(max_mode <= 1)
		to_chat(user, "<span class='warning'>[src] is not capable of switching firemodes!</span>")
		return

	fire_select_index = 1 + fire_select_index % max_mode //Magic math to cycle through this shit!

	fire_select = fire_select_modes[fire_select_index]

	switch(fire_select)
		if(SELECT_SEMI_AUTOMATIC)
			burst_size = 1
			fire_delay = 0
			SEND_SIGNAL(src, COMSIG_GUN_AUTOFIRE_DESELECTED, user)
			to_chat(user, "<span class='notice'>You switch [src] to semi-automatic.</span>")
		if(SELECT_BURST_SHOT)
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			SEND_SIGNAL(src, COMSIG_GUN_AUTOFIRE_DESELECTED, user)
			to_chat(user, "<span class='notice'>You switch [src] to [burst_size]-round burst.</span>")
		if(SELECT_FULLY_AUTOMATIC)
			burst_size = 1
			SEND_SIGNAL(src, COMSIG_GUN_AUTOFIRE_SELECTED, user)
			to_chat(user, "<span class='notice'>You switch [src] to automatic.</span>")

	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)
	update_appearance()
	firemode_action.button_icon_state = "fireselect_[fire_select]"
	firemode_action.UpdateButtons()
	return TRUE

/obj/item/gun/equipped(mob/living/user, slot)
	. = ..()
	if(zoomed && user.get_active_held_item() != src)
		zoom(user, user.dir, FALSE) //we can only stay zoomed in if it's in our hands	//yeah and we only unzoom if we're actually zoomed using the gun!!

//called after the gun has successfully fired its chambered ammo.
/obj/item/gun/proc/process_chamber(mob/living/user)
	return FALSE

//check if there's enough ammo/energy/whatever to shoot one time
//i.e if clicking would make it shoot
/obj/item/gun/proc/can_shoot()
	return TRUE

/obj/item/gun/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='danger'>*click*</span>")
	playsound(src, "gun_dry_fire", 30, 1)

/obj/item/gun/proc/shoot_live_shot(mob/living/user, pointblank = FALSE, mob/pbtarget, message = 1, stam_cost = 0)
	if(recoil)
		directional_recoil(user, recoil*dir_recoil_amp, Get_Angle(user, pbtarget))

	if(stam_cost) //CIT CHANGE - makes gun recoil cause staminaloss
		var/safe_cost = clamp(stam_cost, 0, user.stamina_buffer)*(firing && burst_size >= 2 ? 1/burst_size : 1)
		user.UseStaminaBuffer(safe_cost)

	if(suppressed)
		playsound(user, fire_sound, 10, TRUE, ignore_walls = FALSE, extrarange = SILENCED_SOUND_EXTRARANGE, falloff_distance = 0)
	else
		playsound(user, fire_sound, 50, 1)
		if(message)
			if(pointblank)
				user.visible_message("<span class='danger'>[user] fires [src] point blank at [pbtarget]!</span>", null, null, COMBAT_MESSAGE_RANGE)
			else
				user.visible_message("<span class='danger'>[user] fires [src]!</span>", null, null, COMBAT_MESSAGE_RANGE)

/obj/item/gun/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		for(var/obj/O in contents)
			O.emp_act(severity)

/obj/item/gun/attack(mob/living/M, mob/user)
	. = ..()
	if(!(. & DISCARD_LAST_ACTION))
		user.DelayNextAction(melee_attack_speed)

/obj/item/gun/attack_obj(obj/O, mob/user)
	. = ..()
	if(!(. & DISCARD_LAST_ACTION))
		user.DelayNextAction(melee_attack_speed)

/obj/item/gun/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
	if(!CheckAttackCooldown(user, target, TRUE))
		return
	process_afterattack(target, user, flag, params)

/obj/item/gun/CheckAttackCooldown(mob/user, atom/target, shooting = FALSE)
	return user.CheckActionCooldown(shooting? ranged_attack_speed : attack_speed, clickdelay_from_next_action, clickdelay_mod_bypass, clickdelay_ignores_next_action)

/obj/item/gun/proc/process_afterattack(atom/target, mob/living/user, flag, params)
	if(!target)
		return
	if(firing)
		return
	var/stamloss = user.getStaminaLoss()
	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target) || user.a_intent == INTENT_HARM) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH && (user.a_intent != INTENT_DISARM)) //so we can't shoot ourselves (unless mouth selected or disarm intent)
			return
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			for(var/i in C.all_wounds)
				var/datum/wound/W = i
				if(W.try_treating(src, user))
					return // another coward cured!

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		return

	if(flag)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			handle_suicide(user, target, params)
			return

	//Exclude lasertag guns from the TRAIT_CLUMSY check.
	if(clumsy_check)
		if(istype(user))
			if (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(40))
				to_chat(user, "<span class='userdanger'>You shoot yourself in the foot with [src]!</span>")
				var/shot_leg = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				process_fire(user, user, FALSE, params, shot_leg)
				user.dropItemToGround(src, TRUE)
				return

	if(weapon_weight == WEAPON_HEAVY && user.get_inactive_held_item())
		to_chat(user, "<span class='userdanger'>You need both hands free to fire [src]!</span>")
		return

	user.DelayNextAction()

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0

	if(user)
		bonus_spread = getinaccuracy(user, bonus_spread, stamloss) //CIT CHANGE - adds bonus spread while not aiming
	if(ishuman(user) && user.a_intent == INTENT_HARM && weapon_weight <= WEAPON_LIGHT)
		var/mob/living/carbon/human/H = user
		for(var/obj/item/gun/G in H.held_items)
			if(G == src || G.weapon_weight >= WEAPON_MEDIUM)
				continue
			else if(G.can_trigger_gun(user))
				bonus_spread += 24 * G.weapon_weight * G.dualwield_spread_mult
				loop_counter++
				var/stam_cost = G.getstamcost(user)
				addtimer(CALLBACK(G, TYPE_PROC_REF(/obj/item/gun, process_fire), target, user, TRUE, params, null, bonus_spread, stam_cost), loop_counter)

	var/stam_cost = getstamcost(user)
	process_fire(target, user, TRUE, params, null, bonus_spread, stam_cost)

/obj/item/gun/can_trigger_gun(mob/living/user)
	. = ..()
	if(!.)
		return
	if(!handle_pins(user))
		return FALSE
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && chambered?.harmful) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
		to_chat(user, "<span class='notice'> [src] is lethally chambered! You don't want to risk harming anyone...</span>")
		return FALSE

/obj/item/gun/CheckAttackCooldown(mob/user, atom/target)
	if((user.a_intent == INTENT_HARM) && user.Adjacent(target))		//melee
		return user.CheckActionCooldown(CLICK_CD_MELEE)
	return user.CheckActionCooldown(get_clickcd())

/obj/item/gun/proc/get_clickcd()
	return isnull(chambered?.click_cooldown_override)? CLICK_CD_RANGE : chambered.click_cooldown_override

/obj/item/gun/GetEstimatedAttackSpeed()
	return get_clickcd()

/obj/item/gun/proc/handle_pins(mob/living/user)
	if(no_pin_required)
		return TRUE
	if(pin)
		if(pin.pin_auth(user) || (pin.obj_flags & EMAGGED))
			return TRUE
		else
			pin.auth_fail(user)
			return FALSE
	else
		to_chat(user, "<span class='warning'>[src]'s trigger is locked. This weapon doesn't have a firing pin installed!</span>")
	return FALSE

/obj/item/gun/proc/recharge_newshot()
	return

/obj/item/gun/proc/on_cooldown()
	return busy_action || firing || ((last_fire + fire_delay) > world.time)

/obj/item/gun/proc/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, stam_cost = 0)
	add_fingerprint(user)

	if(on_cooldown())
		return
	firing = TRUE
	. = do_fire(target, user, message, params, zone_override, bonus_spread, stam_cost)
	firing = FALSE
	last_fire = world.time

	if(user)
		user.update_inv_hands()
		SEND_SIGNAL(user, COMSIG_LIVING_GUN_PROCESS_FIRE, target, params, zone_override, bonus_spread, stam_cost)

/obj/item/gun/proc/do_fire(atom/target, mob/living/user, message = TRUE, params, zone_override = "", bonus_spread = 0, stam_cost = 0)
	var/sprd = 0
	var/randomized_gun_spread = 0
	var/rand_spr = rand()
	if(spread)
		randomized_gun_spread = rand(0, spread)
	else if(burst_size > 1 && burst_spread)
		randomized_gun_spread = rand(0, burst_spread)
	var/randomized_bonus_spread = rand(0, bonus_spread)

	if(burst_size > 1)
		do_burst_shot(user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, 1)
		for(var/i in 2 to burst_size)
			sleep(burst_shot_delay)
			if(QDELETED(src))
				break
			do_burst_shot(user, target, message, params, zone_override, sprd, randomized_gun_spread, randomized_bonus_spread, rand_spr, i, stam_cost)
	else
		if(chambered)
			sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))
			before_firing(target,user)
			if(!chambered.fire_casing(target, user, params, , suppressed, zone_override, sprd, src))
				shoot_with_empty_chamber(user)
				return
			else
				if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
					shoot_live_shot(user, 1, target, message, stam_cost)
				else
					shoot_live_shot(user, 0, target, message, stam_cost)
		else
			shoot_with_empty_chamber(user)
			return
		process_chamber(user)
		update_icon()

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/obj/item/gun/proc/do_burst_shot(mob/living/user, atom/target, message = TRUE, params=null, zone_override = "", sprd = 0, randomized_gun_spread = 0, randomized_bonus_spread = 0, rand_spr = 0, iteration = 0, stam_cost = 0)
	if(!user || !firing)
		firing = FALSE
		return FALSE
	if(!issilicon(user))
		if(iteration > 1 && !(user.is_holding(src))) //for burst firing
			firing = FALSE
			return FALSE
	if(chambered && chambered.BB)
		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, "<span class='notice'> [src] is lethally chambered! You don't want to risk harming anyone...</span>")
				return
		if(randomspread)
			sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread), 1)
		else //Smart spread
			sprd = round((((rand_spr/burst_size) * iteration) - (0.5 + (rand_spr * 0.25))) * (randomized_gun_spread + randomized_bonus_spread), 1)
		before_firing(target,user)
		if(!chambered.fire_casing(target, user, params, ,suppressed, zone_override, sprd, src))
			shoot_with_empty_chamber(user)
			firing = FALSE
			return FALSE
		else
			if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
				shoot_live_shot(user, 1, target, message, stam_cost)
			else
				shoot_live_shot(user, 0, target, message, stam_cost)
			if (iteration >= burst_size)
				firing = FALSE
	else
		shoot_with_empty_chamber(user)
		firing = FALSE
		return FALSE
	process_chamber(user)
	update_icon()
	return TRUE

/obj/item/gun/attack(mob/living/M, mob/user)
	if(user.a_intent == INTENT_HARM) //Flogging
		if(bayonet)
			M.attackby(bayonet, user)
			return
		else
			return ..()

/obj/item/gun/attack_obj(obj/O, mob/user)
	if(user.a_intent == INTENT_HARM)
		if(bayonet)
			return O.attackby(bayonet, user)
	return ..()

/obj/item/gun/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	else if(istype(I, /obj/item/flashlight/seclite))
		if(!can_flashlight)
			return ..()
		var/obj/item/flashlight/seclite/S = I
		if(!gun_light)
			if(!user.transferItemToLoc(I, src))
				return
			to_chat(user, "<span class='notice'>You click [S] into place on [src].</span>")
			if(S.on)
				set_light(0)
			set_gun_light(S)
			update_gunlight(user)
			alight = new(src)
			if(loc == user)
				alight.Grant(user)
	else if(istype(I, /obj/item/kitchen/knife))
		var/obj/item/kitchen/knife/K = I
		if(!can_bayonet || !K.bayonet || bayonet) //ensure the gun has an attachment point available, and that the knife is compatible with it.
			return ..()
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, "<span class='notice'>You attach [K] to [src]'s bayonet lug.</span>")
		bayonet = K
		update_icon()
	else
		return ..()

/obj/item/gun/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if((can_flashlight && gun_light) && (can_bayonet && bayonet)) //give them a choice instead of removing both
		var/list/possible_items = list(gun_light, bayonet)
		var/obj/item/item_to_remove = input(user, "Select an attachment to remove", "Attachment Removal") as null|obj in possible_items
		if(!item_to_remove || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
			return
		return remove_gun_attachment(user, I, item_to_remove)

	else if(gun_light && can_flashlight) //if it has a gun_light and can_flashlight is false, the flashlight is permanently attached.
		return remove_gun_attachment(user, I, gun_light, "unscrewed")

	else if(bayonet && can_bayonet) //if it has a bayonet, and the bayonet can be removed
		return remove_gun_attachment(user, I, bayonet, "unfix")

	else if(pin && user.is_holding(src))
		user.visible_message(span_warning("[user] attempts to remove [pin] from [src] with [I]."),
		span_notice("You attempt to remove [pin] from [src]. (It will take [DisplayTimeText(FIRING_PIN_REMOVAL_DELAY)].)"), null, 3)
		if(I.use_tool(src, user, FIRING_PIN_REMOVAL_DELAY, volume = 50))
			if(!pin) //check to see if the pin is still there, or we can spam messages by clicking multiple times during the tool delay
				return
			user.visible_message(span_notice("[pin] is pried out of [src] by [user], destroying the pin in the process."),
								span_warning("You pry [pin] out with [I], destroying the pin in the process."), null, 3)
			QDEL_NULL(pin)
			return TRUE

/obj/item/gun/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(pin && user.is_holding(src))
		user.visible_message(span_warning("[user] attempts to remove [pin] from [src] with [I]."),
		span_notice("You attempt to remove [pin] from [src]. (It will take [DisplayTimeText(FIRING_PIN_REMOVAL_DELAY)].)"), null, 3)
		if(I.use_tool(src, user, FIRING_PIN_REMOVAL_DELAY, 5, volume = 50))
			if(!pin) //check to see if the pin is still there, or we can spam messages by clicking multiple times during the tool delay
				return
			user.visible_message(span_notice("[pin] is spliced out of [src] by [user], melting part of the pin in the process."),
								span_warning("You splice [pin] out of [src] with [I], melting part of the pin in the process."), null, 3)
			QDEL_NULL(pin)
			return TRUE

/obj/item/gun/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if(pin && user.is_holding(src))
		user.visible_message(span_warning("[user] attempts to remove [pin] from [src] with [I]."),
		span_notice("You attempt to remove [pin] from [src]. (It will take [DisplayTimeText(FIRING_PIN_REMOVAL_DELAY)].)"), null, 3)
		if(I.use_tool(src, user, FIRING_PIN_REMOVAL_DELAY, volume = 50))
			if(!pin) //check to see if the pin is still there, or we can spam messages by clicking multiple times during the tool delay
				return
			user.visible_message(span_notice("[pin] is ripped out of [src] by [user], mangling the pin in the process."),
								span_warning("You rip [pin] out of [src] with [I], mangling the pin in the process."), null, 3)
			QDEL_NULL(pin)
			return TRUE

/obj/item/gun/proc/remove_gun_attachment(mob/living/user, obj/item/tool_item, obj/item/item_to_remove, removal_verb)
	if(tool_item)
		tool_item.play_tool_sound(src)
	to_chat(user, span_notice("You [removal_verb ? removal_verb : "remove"] [item_to_remove] from [src]."))
	item_to_remove.forceMove(drop_location())

	if(Adjacent(user) && !issilicon(user))
		user.put_in_hands(item_to_remove)

	if(item_to_remove == bayonet)
		return clear_bayonet()
	else if(item_to_remove == gun_light)
		return clear_gunlight()

/obj/item/gun/proc/clear_bayonet()
	if(!bayonet)
		return
	bayonet = null
	update_appearance()
	return TRUE

/obj/item/gun/proc/clear_gunlight()
	if(!gun_light)
		return
	var/obj/item/flashlight/seclite/removed_light = gun_light
	set_gun_light(null)
	update_gunlight()
	removed_light.update_brightness()
	QDEL_NULL(alight)
	return TRUE

/**
 * Swaps the gun's seclight, dropping the old seclight if it has not been qdel'd.
 *
 * Returns the former gun_light that has now been replaced by this proc.
 * Arguments:
 * * new_light - The new light to attach to the weapon. Can be null, which will mean the old light is removed with no replacement.
 */
/obj/item/gun/proc/set_gun_light(obj/item/flashlight/seclite/new_light)
	// Doesn't look like this should ever happen? We're replacing our old light with our old light?
	if(gun_light == new_light)
		CRASH("Tried to set a new gun light when the old gun light was also the new gun light.")

	. = gun_light

	// If there's an old gun light that isn't being QDELETED, detatch and drop it to the floor.
	if(!QDELETED(gun_light))
		if(gun_light.loc == src)
			gun_light.forceMove(get_turf(src))

	// If there's a new gun light to be added, attach and move it to the gun.
	if(new_light)
		if(new_light.loc != src)
			new_light.forceMove(src)

	gun_light = new_light

/obj/item/gun/proc/toggle_gunlight()
	if(!gun_light)
		return

	var/mob/living/carbon/human/user = usr
	gun_light.on = !gun_light.on
	to_chat(user, "<span class='notice'>You toggle the gunlight [gun_light.on ? "on":"off"].</span>")

	playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	update_gunlight(user)
	return

/obj/item/gun/proc/update_gunlight(mob/user = null)
	if(gun_light)
		if(gun_light.on)
			set_light(gun_light.brightness_on, gun_light.flashlight_power, gun_light.light_color)
		else
			set_light(0)
	else
		set_light(0)
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtons()

/obj/item/gun/update_overlays()
	. = ..()
	if(gun_light)
		var/mutable_appearance/flashlight_overlay
		var/state = "[gunlight_state][gun_light.on? "_on":""]"	//Generic state.
		if(gun_light.icon_state in icon_states('icons/obj/guns/flashlights.dmi'))	//Snowflake state?
			state = gun_light.icon_state
		flashlight_overlay = mutable_appearance('icons/obj/guns/flashlights.dmi', state)
		flashlight_overlay.pixel_x = flight_x_offset
		flashlight_overlay.pixel_y = flight_y_offset
		. += flashlight_overlay

	if(bayonet)
		var/mutable_appearance/knife_overlay
		var/state = "bayonet"							//Generic state.
		if(bayonet.icon_state in icon_states('icons/obj/guns/bayonets.dmi'))		//Snowflake state?
			state = bayonet.icon_state
		var/icon/bayonet_icons = 'icons/obj/guns/bayonets.dmi'
		knife_overlay = mutable_appearance(bayonet_icons, state)
		knife_overlay.pixel_x = knife_x_offset
		knife_overlay.pixel_y = knife_y_offset
		. += knife_overlay

/obj/item/gun/item_action_slot_check(slot, mob/user, datum/action/A)
	if(istype(A, /datum/action/item_action/toggle_scope_zoom) && slot != ITEM_SLOT_HANDS)
		return FALSE
	return ..()

/obj/item/gun/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(on_cooldown())
		return

	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger...</span>", \
			"<span class='userdanger'>You stick [src] in your mouth, ready to pull the trigger...</span>")
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='userdanger'>[user] points [src] at your head, ready to pull the trigger...</span>")

	busy_action = TRUE

	if(!bypass_timer && (!do_mob(user, target, 120) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided not to shoot.</span>")
			else if(target && target.Adjacent(user))
				target.visible_message("<span class='notice'>[user] has decided to spare [target]</span>", "<span class='notice'>[user] has decided to spare your life!</span>")
		busy_action = FALSE
		return

	busy_action = FALSE

	target.visible_message("<span class='warning'>[user] pulls the trigger!</span>", "<span class='userdanger'>[user] pulls the trigger!</span>")

	playsound('sound/weapons/dink.ogg', 30, 1)

	if(chambered && chambered.BB)
		chambered.BB.damage *= 5

	process_fire(target, user, TRUE, params, BODY_ZONE_HEAD, stam_cost = getstamcost(user))

/obj/item/gun/proc/unlock() //used in summon guns and as a convience for admins
	if(pin)
		qdel(pin)
	pin = new /obj/item/firing_pin

//Happens before the actual projectile creation
/obj/item/gun/proc/before_firing(atom/target,mob/user)
	return

/////////////
// ZOOMING //
/////////////

/datum/action/item_action/toggle_scope_zoom
	name = "Toggle Scope"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"

/datum/action/item_action/toggle_scope_zoom/IsAvailable(silent = FALSE)
	. = ..()
	if(!. && owner)
		var/obj/item/gun/G = target
		G.zoom(owner, owner.dir, FALSE)

/datum/action/item_action/toggle_scope_zoom/Trigger()
	. = ..()
	if(.)
		var/obj/item/gun/G = target
		G.zoom(owner, owner.dir)

/datum/action/item_action/toggle_scope_zoom/Remove(mob/living/L)
	var/obj/item/gun/G = target
	G.zoom(L, L.dir, FALSE)
	return ..()

/obj/item/gun/proc/rotate(atom/thing, old_dir, new_dir)
	if(ismob(thing))
		var/mob/lad = thing
		lad.client.view_size.zoomOut(zoom_out_amt, zoom_amt, new_dir)

/obj/item/gun/proc/zoom(mob/living/user, direct, forced_zoom)
	if(!(user?.client))
		return

	if(!isnull(forced_zoom))
		if(zoomed == forced_zoom)
			return
		zoomed = forced_zoom
	else
		zoomed = !zoomed

	if(zoomed)
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(rotate))
		user.client.view_size.zoomOut(zoom_out_amt, zoom_amt, direct)
	else
		UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		user.client.view_size.zoomIn()

/obj/item/gun/handle_atom_del(atom/A)
	if(A == pin)
		pin = null
	if(A == chambered)
		chambered = null
		update_icon()
	if(A == bayonet)
		clear_bayonet()
	if(A == gun_light)
		clear_gunlight()
	return ..()

/obj/item/gun/proc/getinaccuracy(mob/living/user, bonus_spread, stamloss)
	return FALSE		// Replacement TBD: Exponential curved aim instability system.

/*
	if(inaccuracy_modifier == 0)
		return bonus_spread
	var/base_inaccuracy = weapon_weight * 25 * inaccuracy_modifier
	var/aiming_delay = 0 //Otherwise aiming would be meaningless for slower guns such as sniper rifles and launchers.
	if(fire_delay)
		var/penalty = (last_fire + GUN_AIMING_TIME + fire_delay) - world.time
		if(penalty > 0) //Yet we only penalize users firing it multiple times in a haste. fire_delay isn't necessarily cumbersomeness.
			aiming_delay = penalty
	if(SEND_SIGNAL(user, COMSIG_COMBAT_MODE_CHECK, COMBAT_MODE_ACTIVE) || HAS_TRAIT(user, TRAIT_INSANE_AIM)) //To be removed in favor of something less tactless later.
		base_inaccuracy /= 1.5
	if(stamloss > STAMINA_NEAR_SOFTCRIT) //This can null out the above bonus.
		base_inaccuracy *= 1 + (stamloss - STAMINA_NEAR_SOFTCRIT)/(STAMINA_NEAR_CRIT - STAMINA_NEAR_SOFTCRIT)*0.5
	if(HAS_TRAIT(user, TRAIT_POOR_AIM)) //nice shootin' tex
		if(!HAS_TRAIT(user, TRAIT_INSANE_AIM))
			bonus_spread += 25
		else
			//you have both poor aim and insane aim, why?
			bonus_spread += rand(0,50)
	var/mult = max((GUN_AIMING_TIME + aiming_delay + user.last_click_move - world.time)/GUN_AIMING_TIME, -0.5) //Yes, there is a bonus for taking time aiming.
	if(mult < 0) //accurate weapons should provide a proper bonus with negative inaccuracy. the opposite is true too.
		mult *= 1/inaccuracy_modifier
	return max(bonus_spread + (base_inaccuracy * mult), 0) //no negative spread.
*/

/obj/item/gun/proc/getstamcost(mob/living/carbon/user)
	. = recoil
	if(user && !user.has_gravity())
		. = recoil*5

#undef FIRING_PIN_REMOVAL_DELAY
#undef DUALWIELD_PENALTY_EXTRA_MULTIPLIER
