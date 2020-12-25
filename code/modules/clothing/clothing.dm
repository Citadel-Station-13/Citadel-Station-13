/obj/item/clothing
	name = "clothing"
	resistance_flags = FLAMMABLE
	max_integrity = 200
	integrity_failure = 0.4
	block_priority = BLOCK_PRIORITY_CLOTHING
	var/damaged_clothes = CLOTHING_PRISTINE //similar to machine's BROKEN stat and structure's broken var
	var/flash_protect = 0		//What level of bright light protection item has. 1 = Flashers, Flashes, & Flashbangs | 2 = Welding | -1 = OH GOD WELDING BURNT OUT MY RETINAS
	var/tint = 0				//Sets the item's level of visual impairment tint, normally set to the same as flash_protect
	var/up = 0					//but separated to allow items to protect but not impair vision, like space helmets
	var/visor_flags = 0			//flags that are added/removed when an item is adjusted up/down
	var/visor_flags_inv = 0		//same as visor_flags, but for flags_inv
	var/visor_flags_cover = 0	//same as above, but for flags_cover
//what to toggle when toggled with weldingvisortoggle()
	var/visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT | VISOR_VISIONFLAGS | VISOR_DARKNESSVIEW | VISOR_INVISVIEW
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	var/alt_desc = null
	var/toggle_message = null
	var/alt_toggle_message = null
	var/active_sound = null
	var/toggle_cooldown = null
	var/cooldown = 0
	var/obj/item/flashlight/F = null
	var/can_flashlight = 0

	var/blocks_shove_knockdown = FALSE //Whether wearing the clothing item blocks the ability for shove to knock down.

	var/clothing_flags = NONE

	// What items can be consumed to repair this clothing (must by an /obj/item/stack)
	var/repairable_by = /obj/item/stack/sheet/cloth

	//Var modification - PLEASE be careful with this I know who you are and where you live
	var/list/user_vars_to_edit //VARNAME = VARVALUE eg: "name" = "butts"
	var/list/user_vars_remembered //Auto built by the above + dropped() + equipped()

	var/pocket_storage_component_path

	//These allow head/mask items to dynamically alter the user's hair
	// and facial hair, checking hair_extensions.dmi and facialhair_extensions.dmi
	// for a state matching hair_state+dynamic_hair_suffix
	// THESE OVERRIDE THE HIDEHAIR FLAGS
	var/dynamic_hair_suffix = ""//head > mask for head hair
	var/dynamic_fhair_suffix = ""//mask > head for facial hair

	//basically a restriction list.
	var/list/species_restricted
	//Basically syntax is species_restricted = list("Species Name","Species Name")
	//Add a "exclude" string to do the opposite, making it only only species listed that can't wear it.
	//You append this to clothing objects


	// How much clothing damage has been dealt to each of the limbs of the clothing, assuming it covers more than one limb
	var/list/damage_by_parts
	// How much integrity is in a specific limb before that limb is disabled (for use in [/obj/item/clothing/proc/take_damage_zone], and only if we cover multiple zones.) Set to 0 to disable shredding.
	var/limb_integrity = 0
	// How many zones (body parts, not precise) we have disabled so far, for naming purposes
	var/zones_disabled
	///These are armor values that protect the wearer, taken from the clothing's armor datum. List updates on examine because it's currently only used to print armor ratings to chat in Topic().
	var/list/armor_list = list()
	///These are armor values that protect the clothing, taken from its armor datum. List updates on examine because it's currently only used to print armor ratings to chat in Topic().
	var/list/durability_list = list()

/obj/item/clothing/Initialize()
	. = ..()
	if(CHECK_BITFIELD(clothing_flags, VOICEBOX_TOGGLABLE))
		actions_types += /datum/action/item_action/toggle_voice_box
	if(ispath(pocket_storage_component_path))
		LoadComponent(pocket_storage_component_path)

/obj/item/clothing/MouseDrop(atom/over_object)
	. = ..()
	var/mob/M = usr

	if(ismecha(M.loc)) // stops inventory actions in a mech
		return

	if(!. && !M.incapacitated() && loc == M && istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)

/obj/item/reagent_containers/food/snacks/clothing
	name = "oops"
	desc = "If you're reading this it means I messed up. This is related to moths eating clothes and I didn't know a better way to do it than making a new food object."
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("dust" = 1, "lint" = 1)

/obj/item/clothing/attack(mob/M, mob/user, def_zone)
	if(user.a_intent != INTENT_HARM && isinsect(M))
		var/obj/item/reagent_containers/food/snacks/clothing/clothing_as_food = new
		clothing_as_food.name = name
		if(clothing_as_food.attack(M, user, def_zone))
			take_damage(15, sound_effect=FALSE)
		qdel(clothing_as_food)
	else
		return ..()

/obj/item/clothing/attackby(obj/item/W, mob/user, params)
	if(damaged_clothes && istype(W, repairable_by))
		var/obj/item/stack/S = W
		switch(damaged_clothes)
			if(CLOTHING_DAMAGED)
				S.use(1)
				repair(user, params)
			if(CLOTHING_SHREDDED)
				if(S.amount < 3)
					to_chat(user, "<span class='warning'>You require 3 [S.name] to repair [src].</span>")
					return
				to_chat(user, "<span class='notice'>You begin fixing the damage to [src] with [S]...</span>")
				if(do_after(user, 6 SECONDS, TRUE, src))
					if(S.use(3))
						repair(user, params)
		return 1
	return ..()

// Set the clothing's integrity back to 100%, remove all damage to bodyparts, and generally fix it up
/obj/item/clothing/proc/repair(mob/user, params)
	update_clothes_damaged_state(CLOTHING_PRISTINE)
	obj_integrity = max_integrity
	name = initial(name) // remove "tattered" or "shredded" if there's a prefix
	body_parts_covered = initial(body_parts_covered)
	slot_flags = initial(slot_flags)
	damage_by_parts = null
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		to_chat(user, "<span class='notice'>You fix the damage on [src].</span>")

/**
  * take_damage_zone() is used for dealing damage to specific bodyparts on a worn piece of clothing, meant to be called from [/obj/item/bodypart/proc/check_woundings_mods()]
  *
  *	This proc only matters when a bodypart that this clothing is covering is harmed by a direct attack (being on fire or in space need not apply), and only if this clothing covers
  * more than one bodypart to begin with. No point in tracking damage by zone for a hat, and I'm not cruel enough to let you fully break them in a few shots.
  * Also if limb_integrity is 0, then this clothing doesn't have bodypart damage enabled so skip it.
  *
  * Arguments:
  * * def_zone: The bodypart zone in question
  * * damage_amount: Incoming damage
  * * damage_type: BRUTE or BURN
  * * armour_penetration: If the attack had armour_penetration
  */
/obj/item/clothing/proc/take_damage_zone(def_zone, damage_amount, damage_type, armour_penetration)
	if(!def_zone || !limb_integrity || (initial(body_parts_covered) in GLOB.bitflags)) // the second check sees if we only cover one bodypart anyway and don't need to bother with this
		return
	var/list/covered_limbs = body_parts_covered2organ_names(body_parts_covered) // what do we actually cover?
	if(!(def_zone in covered_limbs))
		return

	var/damage_dealt = take_damage(damage_amount * 0.1, damage_type, armour_penetration, FALSE) * 10 // only deal 10% of the damage to the general integrity damage, then multiply it by 10 so we know how much to deal to limb
	LAZYINITLIST(damage_by_parts)
	damage_by_parts[def_zone] += damage_dealt
	if(damage_by_parts[def_zone] > limb_integrity)
		disable_zone(def_zone, damage_type)

/**
  * disable_zone() is used to disable a given bodypart's protection on our clothing item, mainly from [/obj/item/clothing/proc/take_damage_zone()]
  *
  * This proc disables all protection on the specified bodypart for this piece of clothing: it'll be as if it doesn't cover it at all anymore (because it won't!)
  * If every possible bodypart has been disabled on the clothing, we put it out of commission entirely and mark it as shredded, whereby it will have to be repaired in
  * order to equip it again. Also note we only consider it damaged if there's more than one bodypart disabled.
  *
  * Arguments:
  * * def_zone: The bodypart zone we're disabling
  * * damage_type: Only really relevant for the verb for describing the breaking, and maybe obj_destruction()
  */
/obj/item/clothing/proc/disable_zone(def_zone, damage_type)
	var/list/covered_limbs = body_parts_covered2organ_names(body_parts_covered)
	if(!(def_zone in covered_limbs))
		return

	var/zone_name = parse_zone(def_zone)
	var/break_verb = ((damage_type == BRUTE) ? "torn" : "burned")

	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		C.visible_message("<span class='danger'>The [zone_name] on [C]'s [src.name] is [break_verb] away!</span>", "<span class='userdanger'>The [zone_name] on your [src.name] is [break_verb] away!</span>", vision_distance = COMBAT_MESSAGE_RANGE)
		RegisterSignal(C, COMSIG_MOVABLE_MOVED, .proc/bristle)

	zones_disabled++
	for(var/i in zone2body_parts_covered(def_zone))
		body_parts_covered &= ~i

	if(body_parts_covered == NONE) // if there are no more parts to break then the whole thing is kaput
		obj_destruction((damage_type == BRUTE ? "melee" : "laser")) // melee/laser is good enough since this only procs from direct attacks anyway and not from fire/bombs
		return

	damaged_clothes = CLOTHING_DAMAGED
	switch(zones_disabled)
		if(1)
			name = "damaged [initial(name)]"
		if(2)
			name = "mangy [initial(name)]"
		if(3 to INFINITY) // take better care of your shit, dude
			name = "tattered [initial(name)]"

	update_clothes_damaged_state(CLOTHING_DAMAGED)

/obj/item/clothing/Destroy()
	user_vars_remembered = null //Oh god somebody put REFERENCES in here? not to worry, we'll clean it up
	return ..()

/obj/item/clothing/dropped(mob/user)
	..()
	if(!istype(user))
		return
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	if(LAZYLEN(user_vars_remembered))
		for(var/variable in user_vars_remembered)
			if(variable in user.vars)
				if(user.vars[variable] == user_vars_to_edit[variable]) //Is it still what we set it to? (if not we best not change it)
					user.vars[variable] = user_vars_remembered[variable]
		user_vars_remembered = initial(user_vars_remembered) // Effectively this sets it to null.

/obj/item/clothing/equipped(mob/user, slot)
	..()
	if (!istype(user))
		return
	if(slot_flags & slotdefine2slotbit(slot)) //Was equipped to a valid slot for this item?
		if(iscarbon(user) && LAZYLEN(zones_disabled))
			RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/bristle)
		if(LAZYLEN(user_vars_to_edit))
			for(var/variable in user_vars_to_edit)
				if(variable in user.vars)
					LAZYSET(user_vars_remembered, variable, user.vars[variable])
					user.vv_edit_var(variable, user_vars_to_edit[variable])

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(damaged_clothes == CLOTHING_SHREDDED)
		. += "<span class='warning'><b>It is completely shredded and requires mending before it can be worn again!</b></span>"
		return
	for(var/zone in damage_by_parts)
		var/pct_damage_part = damage_by_parts[zone] / limb_integrity * 100
		var/zone_name = parse_zone(zone)
		switch(pct_damage_part)
			if(100 to INFINITY)
				. += "<span class='warning'><b>The [zone_name] is useless and requires mending!</b></span>"
			if(60 to 99)
				. += "<span class='warning'>The [zone_name] is heavily shredded!</span>"
			if(30 to 59)
				. += "<span class='danger'>The [zone_name] is partially shredded.</span>"
	var/datum/component/storage/pockets = GetComponent(/datum/component/storage)
	if(pockets)
		var/list/how_cool_are_your_threads = list("<span class='notice'>")
		if(pockets.attack_hand_interact)
			how_cool_are_your_threads += "[src]'s storage opens when clicked.\n"
		else
			how_cool_are_your_threads += "[src]'s storage opens when dragged to yourself.\n"
		how_cool_are_your_threads += "[src] can store [pockets.max_items] item\s.\n"
		how_cool_are_your_threads += "[src] can store items that are [weightclass2text(pockets.max_w_class)] or smaller.\n"
		if(pockets.quickdraw)
			how_cool_are_your_threads += "You can quickly remove an item from [src] using Alt-Click.\n"
		if(pockets.silent)
			how_cool_are_your_threads += "Adding or removing items from [src] makes no noise.\n"
		how_cool_are_your_threads += "</span>"
		. += how_cool_are_your_threads.Join()

	if(LAZYLEN(armor_list))
		armor_list.Cut()
	if(armor.bio)
		armor_list += list("TOXIN" = armor.bio)
	if(armor.bomb)
		armor_list += list("EXPLOSIVE" = armor.bomb)
	if(armor.bullet)
		armor_list += list("BULLET" = armor.bullet)
	if(armor.energy)
		armor_list += list("ENERGY" = armor.energy)
	if(armor.laser)
		armor_list += list("LASER" = armor.laser)
	if(armor.magic)
		armor_list += list("MAGIC" = armor.magic)
	if(armor.melee)
		armor_list += list("MELEE" = armor.melee)
	if(armor.rad)
		armor_list += list("RADIATION" = armor.rad)

	if(LAZYLEN(durability_list))
		durability_list.Cut()
	if(armor.fire)
		durability_list += list("FIRE" = armor.fire)
	if(armor.acid)
		durability_list += list("ACID" = armor.acid)

	if(LAZYLEN(armor_list) || LAZYLEN(durability_list))
		. += "<span class='notice'>It has a <a href='?src=[REF(src)];list_armor=1'>tag</a> listing its protection classes.</span>"

/obj/item/clothing/Topic(href, href_list)
	. = ..()

	if(href_list["list_armor"])
		var/list/readout = list("<span class='notice'><u><b>PROTECTION CLASSES (I-X)</u></b>")
		if(LAZYLEN(armor_list))
			readout += "\n<b>ARMOR</b>"
			for(var/dam_type in armor_list)
				var/armor_amount = armor_list[dam_type]
				readout += "\n[dam_type] [armor_to_protection_class(armor_amount)]" //e.g. BOMB IV
		if(LAZYLEN(durability_list))
			readout += "\n<b>DURABILITY</b>"
			for(var/dam_type in durability_list)
				var/durability_amount = durability_list[dam_type]
				readout += "\n[dam_type] [armor_to_protection_class(durability_amount)]" //e.g. FIRE II
		readout += "</span>"

		to_chat(usr, "[readout.Join()]")

/**
  * Rounds armor_value to nearest 10, divides it by 10 and then expresses it in roman numerals up to 10
  *
  * Rounds armor_value to nearest 10, divides it by 10
  * and then expresses it in roman numerals up to 10
  * Arguments:
  * * armor_value - Number we're converting
  */
/obj/item/clothing/proc/armor_to_protection_class(armor_value)
	armor_value = round(armor_value,10) / 10
	switch (armor_value)
		if (1)
			. = "I"
		if (2)
			. = "II"
		if (3)
			. = "III"
		if (4)
			. = "IV"
		if (5)
			. = "V"
		if (6)
			. = "VI"
		if (7)
			. = "VII"
		if (8)
			. = "VIII"
		if (9)
			. = "IX"
		if (10 to INFINITY)
			. = "X"
	return .

/obj/item/clothing/obj_break(damage_flag)
	damaged_clothes = CLOTHING_DAMAGED
	update_clothes_damaged_state()
	if(ismob(loc)) //It's not important enough to warrant a message if nobody's wearing it
		var/mob/M = loc
		to_chat(M, "<span class='warning'>Your [name] starts to fall apart!</span>")

//This mostly exists so subtypes can call appriopriate update icon calls on the wearer.
/obj/item/clothing/proc/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	damaged_clothes = damaged_state
	update_icon()

/obj/item/clothing/update_overlays()
	. = ..()
	if(damaged_clothes)
		var/index = "[REF(initial(icon))]-[initial(icon_state)]"
		var/static/list/damaged_clothes_icons = list()
		var/icon/damaged_clothes_icon = damaged_clothes_icons[index]
		if(!damaged_clothes_icon)
			damaged_clothes_icon = icon(initial(icon), initial(icon_state), , 1)	//we only want to apply damaged effect to the initial icon_state for each object
			damaged_clothes_icon.Blend("#fff", ICON_ADD) 	//fills the icon_state with white (except where it's transparent)
			damaged_clothes_icon.Blend(icon('icons/effects/item_damage.dmi', "itemdamaged"), ICON_MULTIPLY) //adds damage effect and the remaining white areas become transparant
			damaged_clothes_icon = fcopy_rsc(damaged_clothes_icon)
			damaged_clothes_icons[index] = damaged_clothes_icon
		. += damaged_clothes_icon

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/

/proc/generate_alpha_masked_clothing(index,state,icon,female,alpha_masks)
	var/icon/I = icon(icon, state)
	if(female)
		var/icon/female_s = icon('icons/mob/clothing/alpha_masks.dmi', "[(female == FEMALE_UNIFORM_FULL) ? "female_full" : "female_top"]")
		I.Blend(female_s, ICON_MULTIPLY, -15, -15) //it's a 64x64 icon.
	if(alpha_masks)
		if(istext(alpha_masks))
			alpha_masks = list(alpha_masks)
		for(var/alpha_state in alpha_masks)
			var/icon/alpha = icon('icons/mob/clothing/alpha_masks.dmi', alpha_state)
			I.Blend(alpha, ICON_MULTIPLY, -15, -15)
	. = GLOB.alpha_masked_worn_icons[index] = fcopy_rsc(I)

/obj/item/clothing/proc/weldingvisortoggle(mob/user) //proc to toggle welding visors on helmets, masks, goggles, etc.
	if(!can_use(user))
		return FALSE

	visor_toggling()

	to_chat(user, "<span class='notice'>You adjust \the [src] [up ? "up" : "down"].</span>")

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.head_update(src, forced = 1)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
	return TRUE

/obj/item/clothing/proc/visor_toggling() //handles all the actual toggling of flags
	up = !up
	clothing_flags ^= visor_flags
	flags_inv ^= visor_flags_inv
	flags_cover ^= initial(flags_cover)
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	if(visor_vars_to_toggle & VISOR_FLASHPROTECT)
		flash_protect ^= initial(flash_protect)
	if(visor_vars_to_toggle & VISOR_TINT)
		tint ^= initial(tint)


/obj/item/clothing/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0


/obj/item/clothing/obj_destruction(damage_flag)
	if(damage_flag == "bomb")
		var/turf/T = get_turf(src)
		spawn(1) //so the shred survives potential turf change from the explosion.
			var/obj/effect/decal/cleanable/shreds/Shreds = new(T)
			Shreds.desc = "The sad remains of what used to be [name]."
		deconstruct(FALSE)
	else if(!(damage_flag in list("acid", "fire")))
		damaged_clothes = CLOTHING_SHREDDED
		body_parts_covered = NONE
		name = "shredded [initial(name)]"
		slot_flags = NONE
		update_clothes_damaged_state()
		if(ismob(loc))
			var/mob/M = loc
			M.visible_message("<span class='danger'>[M]'s [src.name] falls off, completely shredded!</span>", "<span class='warning'><b>Your [src.name] falls off, completely shredded!</b></span>", vision_distance = COMBAT_MESSAGE_RANGE)
			M.dropItemToGround(src)
	else
		..()

//Species-restricted clothing check. - Thanks Oraclestation, BS13, /vg/station etc.
/obj/item/clothing/mob_can_equip(mob/M, slot, disable_warning = TRUE)

	//if we can't equip the item anyway, don't bother with species_restricted (also cuts down on spam)
	if(!..())
		return FALSE

	// Skip species restriction checks on non-equipment slots
	if(slot in list(SLOT_IN_BACKPACK, SLOT_L_STORE, SLOT_R_STORE))
		return TRUE

	if(species_restricted && ishuman(M))

		var/wearable = null
		var/exclusive = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted) //TURNS IT INTO A BLACKLIST - AKA ALL MINUS SPECIES LISTED.
			exclusive = TRUE

		if(H.dna.species)
			if(exclusive)
				if(!(H.dna.species.name in species_restricted))
					wearable = TRUE
			else
				if(H.dna.species.name in species_restricted)
					wearable = TRUE

			if(!wearable)
				to_chat(M, "<span class='warning'>Your species cannot wear [src].</span>")
				return FALSE

	return TRUE


/// If we're a clothing with at least 1 shredded/disabled zone, give the wearer a periodic heads up letting them know their clothes are damaged
/obj/item/clothing/proc/bristle(mob/living/L)
	if(!istype(L))
		return
	if(prob(0.2))
		to_chat(L, "<span class='warning'>The damaged threads on your [src.name] chafe!</span>")
