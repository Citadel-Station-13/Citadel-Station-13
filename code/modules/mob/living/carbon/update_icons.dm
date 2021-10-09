/mob/living/carbon/regenerate_icons()
	if(mob_transforming)
		return TRUE
	update_limbs(list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG))
	//full_appearance.render()
	return FALSE

/mob/living/carbon/update_inv_hands()
	remove_overlay(HANDS_LAYER)
	if (handcuffed)
		drop_all_held_items()
		return

	var/list/hands = list()
	for(var/obj/item/I in held_items)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			I.screen_loc = ui_hand_position(get_held_index_of_item(I))
			client.screen += I
			if(observers && observers.len)
				for(var/M in observers)
					var/mob/dead/observe = M
					if(observe.client && observe.client.eye == src)
						observe.client.screen += I
					else
						observers -= observe
						if(!observers.len)
							observers = null
							break

		var/icon_file = I.lefthand_file
		if(get_held_index_of_item(I) % 2 == 0)
			icon_file = I.righthand_file

		hands += I.build_worn_icon(default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE)

	full_appearance.appearance_list[MISC_APPEARANCE].add_data(hands, num2text(HANDS_LAYER))


/mob/living/carbon/update_fire(var/fire_icon = "Generic_mob_burning")
	remove_overlay(FIRE_LAYER)
	if(on_fire)
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.appearance_flags = RESET_COLOR
		full_appearance.appearance_list[MISC_APPEARANCE].add_data(new_fire_overlay, num2text(FIRE_LAYER))
	else
		full_appearance.appearance_list[MISC_APPEARANCE].remove_data(num2text(FIRE_LAYER))

/mob/living/carbon/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)
	var/dam_colors = "#E62525"
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		dam_colors = H.dna.species.exotic_blood_color

	var/mutable_appearance/damage_overlay = mutable_appearance('icons/mob/dam_mob.dmi', "blank", -DAMAGE_LAYER, color = dam_colors)

	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(BP.dmg_overlay_type)
			if(BP.brutestate)
				damage_overlay.add_overlay("[BP.dmg_overlay_type]_[BP.body_zone]_[BP.brutestate]0")	//we're adding icon_states of the base image as overlays
			if(BP.burnstate)
				damage_overlay.add_overlay("[BP.dmg_overlay_type]_[BP.body_zone]_0[BP.burnstate]")

	full_appearance.appearance_list[MISC_APPEARANCE].add_data(damage_overlay, num2text(-DAMAGE_LAYER))


/mob/living/carbon/update_inv_wear_mask()
	full_appearance.appearance_list[CLOTHING_APPEARANCE].remove_data(num2text(FACEMASK_LAYER))

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[SLOT_WEAR_MASK]
		inv?.update_icon()

	if(wear_mask)
		if(!(head && (head.flags_inv & HIDEMASK)))
			var/mutable_appearance/mask_overlay = wear_mask.build_worn_icon(default_layer = FACEMASK_LAYER, default_icon_file = 'icons/mob/clothing/mask.dmi', override_state = wear_mask.icon_state)
			full_appearance.appearance_list[CLOTHING_APPEARANCE].add_data(mask_overlay, num2text(FACEMASK_LAYER))
		update_hud_wear_mask(wear_mask)

/mob/living/carbon/update_inv_neck()
	full_appearance.appearance_list[CLOTHING_APPEARANCE].remove_data(num2text(NECK_LAYER))

	if(client && hud_used && hud_used.inv_slots[SLOT_NECK])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[SLOT_NECK]
		inv.update_icon()

	if(wear_neck)
		if(!(head && (head.flags_inv & HIDENECK)))
			var/mutable_appearance/neck_overlay = wear_neck.build_worn_icon(default_layer = NECK_LAYER, default_icon_file = 'icons/mob/clothing/neck.dmi', override_state = wear_neck.icon_state)
			full_appearance.appearance_list[CLOTHING_APPEARANCE].add_data(neck_overlay, num2text(NECK_LAYER))
		update_hud_neck(wear_neck)


/mob/living/carbon/update_inv_back()
	full_appearance.appearance_list[CLOTHING_APPEARANCE].remove_data(num2text(BACK_LAYER))

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[SLOT_BACK]
		inv?.update_icon()

	if(back)
		var/mutable_appearance/back_overlay = back.build_worn_icon(default_layer = BACK_LAYER, default_icon_file = 'icons/mob/clothing/back.dmi', override_state = back.icon_state)
		full_appearance.appearance_list[CLOTHING_APPEARANCE].add_data(back_overlay, num2text(BACK_LAYER))
		update_hud_back(back)

/mob/living/carbon/update_inv_head()
	full_appearance.appearance_list[CLOTHING_APPEARANCE].remove_data(num2text(HEAD_LAYER))

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[SLOT_HEAD]
		inv?.update_icon()

	if(head)
		var/mutable_appearance/head_overlay = head.build_worn_icon(default_layer = HEAD_LAYER, default_icon_file = 'icons/mob/clothing/head.dmi', override_state = head.icon_state)
		full_appearance.appearance_list[CLOTHING_APPEARANCE].add_data(head_overlay, num2text(HEAD_LAYER))
		update_hud_head(head)


/mob/living/carbon/update_inv_handcuffed()
	full_appearance.appearance_list[CLOTHING_APPEARANCE].remove_data(num2text(HANDCUFF_LAYER))
	if(handcuffed)
		var/mutable_appearance/cuffs = mutable_appearance('icons/mob/clothing/restraints.dmi', handcuffed.item_state, -HANDCUFF_LAYER)
		cuffs.color = handcuffed.color

		full_appearance.appearance_list[CLOTHING_APPEARANCE].add_data(cuffs, num2text(HANDCUFF_LAYER))

/mob/living/carbon/update_inv_legcuffed()
	full_appearance.appearance_list[CLOTHING_APPEARANCE].remove_data(num2text(LEGCUFF_LAYER))
	clear_alert("legcuffed")
	if(legcuffed)
		var/mutable_appearance/legcuffs = mutable_appearance('icons/mob/clothing/restraints.dmi', legcuffed.item_state, -LEGCUFF_LAYER)
		legcuffs.color = legcuffed.color

		full_appearance.appearance_list[CLOTHING_APPEARANCE].add_data(legcuffs, num2text(LEGCUFF_LAYER))
		throw_alert("legcuffed", /atom/movable/screen/alert/restrained/legcuffed, new_master = legcuffed)

//mob HUD updates for items in our inventory

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(hud_used)
		for(var/hand in hud_used.hand_slots)
			var/atom/movable/screen/inventory/hand/H = hud_used.hand_slots[hand]
			if(H)
				H.update_icon()

//update whether our head item appears on our hud.
/mob/living/carbon/proc/update_hud_head(obj/item/I)
	return

//update whether our mask item appears on our hud.
/mob/living/carbon/proc/update_hud_wear_mask(obj/item/I)
	return

//update whether our neck item appears on our hud.
/mob/living/carbon/proc/update_hud_neck(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_back(obj/item/I)
	return

/mob/living/carbon/update_body()
	update_body_parts()

/mob/living/carbon/proc/update_body_parts()
	//CHECK FOR UPDATE
	var/oldkey = icon_render_key
	icon_render_key = generate_icon_render_key()
	if(oldkey == icon_render_key)
		return

	remove_overlay(BODYPARTS_LAYER)

	var/is_taur = FALSE
	if(dna?.species.mutant_bodyparts["taur"])
		var/datum/sprite_accessory/taur/T = GLOB.taur_list[dna.features["taur"]]
		if(T?.hide_legs)
			is_taur = TRUE

	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		BP.update_limb()

	//LOAD ICONS
	if(limb_icon_cache[icon_render_key])
		load_limb_from_cache()
		return

	//GENERATE NEW LIMBS
	var/static/list/leg_day = typecacheof(list(/obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg))
	var/list/new_limbs = list()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		if(is_taur && leg_day[BP.type])
			continue
		new_limbs += BP.get_limb_icon()
	if(new_limbs.len)
		full_appearance.appearance_list[BODYPART_APPEARANCE].add_data(
		limb_icon_cache[icon_render_key] = new_limbs

	apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()



/////////////////////
// Limb Icon Cache //
/////////////////////
/*
	Called from update_body_parts() these procs handle the limb icon cache.
	the limb icon cache adds an icon_render_key to a human mob, it represents:
	- skin_tone (if applicable)
	- gender
	- limbs (stores as the limb name and whether it is removed/fine, organic/robotic)
	These procs only store limbs as to increase the number of matching icon_render_keys
	This cache exists because drawing 6/7 icons for humans constantly is quite a waste
	See RemieRichards on irc.rizon.net #coderbus
*/

//produces a key based on the mob's limbs

/mob/living/carbon/proc/generate_icon_render_key()
	for(var/X in bodyparts)
		var/obj/item/bodypart/BP = X
		. += "-[BP.body_zone]"
		if(BP.use_digitigrade)
			. += "-digitigrade[BP.use_digitigrade]"
		if(BP.animal_origin)
			. += "-[BP.animal_origin]"
		if(BP.is_organic_limb(FALSE))
			. += "-organic"
		else
			. += "-robotic"

	if(HAS_TRAIT(src, TRAIT_HUSK))
		. += "-husk"
