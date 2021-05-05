#define INTERNALS_TOGGLE_DELAY (4 SECONDS)
#define POCKET_EQUIP_DELAY (1 SECONDS)

GLOBAL_LIST_INIT(strippable_human_items, create_strippable_list(list(
	/datum/strippable_item/mob_item_slot/head,
	/datum/strippable_item/mob_item_slot/back,
	/datum/strippable_item/mob_item_slot/mask,
	/datum/strippable_item/mob_item_slot/neck,
	/datum/strippable_item/mob_item_slot/eyes,
	/datum/strippable_item/mob_item_slot/ears,
	/datum/strippable_item/mob_item_slot/jumpsuit,
	/datum/strippable_item/mob_item_slot/suit,
	/datum/strippable_item/mob_item_slot/gloves,
	/datum/strippable_item/mob_item_slot/feet,
	/datum/strippable_item/mob_item_slot/suit_storage,
	/datum/strippable_item/mob_item_slot/id,
	/datum/strippable_item/mob_item_slot/belt,
	/datum/strippable_item/mob_item_slot/pocket/left,
	/datum/strippable_item/mob_item_slot/pocket/right,
	/datum/strippable_item/hand/left,
	/datum/strippable_item/hand/right,
	/datum/strippable_item/mob_item_slot/handcuffs,
	/datum/strippable_item/mob_item_slot/legcuffs,
)))

/mob/living/carbon/human/proc/should_strip(mob/user)
	if (user.pulling != src || user.grab_state != GRAB_AGGRESSIVE)
		return TRUE

	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		return !human_user.can_be_firemanned(src)

	return TRUE

/datum/strippable_item/mob_item_slot/eyes
	key = STRIPPABLE_ITEM_EYES
	item_slot = ITEM_SLOT_EYES

/datum/strippable_item/mob_item_slot/ears
	key = STRIPPABLE_ITEM_EARS
	item_slot = ITEM_SLOT_EARS

/datum/strippable_item/mob_item_slot/jumpsuit
	key = STRIPPABLE_ITEM_JUMPSUIT
	item_slot = ITEM_SLOT_ICLOTHING

/datum/strippable_item/mob_item_slot/jumpsuit/get_alternate_action(atom/source, mob/user)
	var/obj/item/clothing/under/jumpsuit = get_item(source)
	if (!istype(jumpsuit))
		return null
	return jumpsuit?.can_adjust ? "adjust_jumpsuit" : null

/datum/strippable_item/mob_item_slot/jumpsuit/alternate_action(atom/source, mob/user)
	if (!..())
		return
	var/obj/item/clothing/under/jumpsuit = get_item(source)
	if (!istype(jumpsuit))
		return null
	to_chat(source, "<span class='notice'>[user] is trying to adjust your [jumpsuit.name].")
	if (!do_mob(user, source, jumpsuit.strip_delay * 0.5))
		return
	to_chat(source, "<span class='notice'>[user] successfully adjusted your [jumpsuit.name].")
	jumpsuit.toggle_jumpsuit_adjust()

	if (!ismob(source))
		return

	var/mob/mob_source = source
	mob_source.update_inv_w_uniform()
	mob_source.update_body()

/datum/strippable_item/mob_item_slot/suit
	key = STRIPPABLE_ITEM_SUIT
	item_slot = ITEM_SLOT_OCLOTHING

/datum/strippable_item/mob_item_slot/gloves
	key = STRIPPABLE_ITEM_GLOVES
	item_slot = ITEM_SLOT_GLOVES

/datum/strippable_item/mob_item_slot/feet
	key = STRIPPABLE_ITEM_FEET
	item_slot = ITEM_SLOT_FEET

/datum/strippable_item/mob_item_slot/feet/get_alternate_action(atom/source, mob/user)
	var/obj/item/clothing/shoes/shoes = get_item(source)
	if (!istype(shoes) || !shoes.can_be_tied)
		return null

	switch (shoes.tied)
		if (SHOES_UNTIED)
			return "knot"
		if (SHOES_TIED)
			return "untie"
		if (SHOES_KNOTTED)
			return "unknot"

/datum/strippable_item/mob_item_slot/feet/alternate_action(atom/source, mob/user)
	if(!..())
		return
	var/obj/item/clothing/shoes/shoes = get_item(source)
	if (!istype(shoes))
		return

	shoes.handle_tying(user)

/datum/strippable_item/mob_item_slot/suit_storage
	key = STRIPPABLE_ITEM_SUIT_STORAGE
	item_slot = ITEM_SLOT_SUITSTORE

/datum/strippable_item/mob_item_slot/suit_storage/get_alternate_action(atom/source, mob/user)
	return get_strippable_alternate_action_internals(get_item(source), source)

/datum/strippable_item/mob_item_slot/suit_storage/alternate_action(atom/source, mob/user)
	if (!..())
		return
	strippable_alternate_action_internals(get_item(source), source, user)

/datum/strippable_item/mob_item_slot/id
	key = STRIPPABLE_ITEM_ID
	item_slot = ITEM_SLOT_ID

/datum/strippable_item/mob_item_slot/belt
	key = STRIPPABLE_ITEM_BELT
	item_slot = ITEM_SLOT_BELT

/datum/strippable_item/mob_item_slot/belt/get_alternate_action(atom/source, mob/user)
	return get_strippable_alternate_action_internals(get_item(source), source)

/datum/strippable_item/mob_item_slot/belt/alternate_action(atom/source, mob/user)
	if (!..())
		return
	strippable_alternate_action_internals(get_item(source), source, user)

/datum/strippable_item/mob_item_slot/pocket
	/// Which pocket we're referencing. Used for visible text.
	var/pocket_side

/datum/strippable_item/mob_item_slot/pocket/get_obscuring(atom/source)
	return isnull(get_item(source)) \
		? STRIPPABLE_OBSCURING_NONE \
		: STRIPPABLE_OBSCURING_HIDDEN

/datum/strippable_item/mob_item_slot/pocket/get_equip_delay(obj/item/equipping)
	return POCKET_EQUIP_DELAY

/datum/strippable_item/mob_item_slot/pocket/start_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		warn_owner(source)

/datum/strippable_item/mob_item_slot/pocket/start_unequip(atom/source, mob/user)
	var/obj/item/item = get_item(source)
	if (isnull(item))
		return FALSE

	to_chat(user, "<span class='notice'>You try to empty [source]'s [pocket_side] pocket.</span>")

	var/log_message = "[key_name(source)] is being pickpocketed of [item] by [key_name(user)] ([pocket_side])"
	source.log_message(log_message, LOG_ATTACK, color="red")
	user.log_message(log_message, LOG_ATTACK, color="red", log_globally=FALSE)
	item.add_fingerprint(src)

	var/result = start_unequip_mob(item, source, user, POCKET_STRIP_DELAY)

	if (!result)
		warn_owner(source)

	return result

/datum/strippable_item/mob_item_slot/pocket/proc/warn_owner(atom/owner)
	to_chat(owner, "<span class='warning'>You feel your [pocket_side] pocket being fumbled with!</span>")

/datum/strippable_item/mob_item_slot/pocket/left
	key = STRIPPABLE_ITEM_LPOCKET
	item_slot = ITEM_SLOT_LPOCKET
	pocket_side = "left"

/datum/strippable_item/mob_item_slot/pocket/right
	key = STRIPPABLE_ITEM_RPOCKET
	item_slot = ITEM_SLOT_RPOCKET
	pocket_side = "right"

/proc/get_strippable_alternate_action_internals(obj/item/item, atom/source)
	if (!iscarbon(source))
		return

	var/mob/living/carbon/carbon_source = source
	var/obj/item/clothing/mask = carbon_source.wear_mask
	var/hasmask_or_suit = istype(mask, /obj/item/clothing/mask)
	// human check, suits have seals dumb
	var/mob/living/carbon/human/human_source = carbon_source
	if(istype(human_source))
		var/obj/item/clothing/suit/space/suit = human_source.wear_suit
		hasmask_or_suit = hasmask_or_suit || istype(suit, /obj/item/clothing/suit/space/hardsuit)

	if (hasmask_or_suit && istype(item, /obj/item/tank)) // (mask.clothing_flags & MASKINTERNALS)
		return isnull(carbon_source.internal) ? "enable_internals" : "disable_internals"

/proc/strippable_alternate_action_internals(obj/item/item, atom/source, mob/user)
	var/obj/item/tank/tank = item
	if (!istype(tank))
		return

	var/mob/living/carbon/carbon_source = source
	if (!istype(carbon_source))
		return

	var/obj/item/clothing/mask = carbon_source.wear_mask
	// var/obj/item/clothing/suit/space/suit = carbon_source.wear_suit
	var/hasmask_or_suit = istype(mask, /obj/item/clothing/mask) // || istype(suit, /obj/item/clothing/suit/space/hardsuit)

	if (!hasmask_or_suit)
		return

	// if (!istype(mask) || !(mask.clothing_flags & MASKINTERNALS))
	// 	return

	carbon_source.visible_message(
		"<span class='danger'>[user] tries to [isnull(carbon_source.internal) ? "open": "close"] the valve on [source]'s [item.name].</span>",
		"<span class='userdanger'>[user] tries to [isnull(carbon_source.internal) ? "open": "close"] the valve on your [item.name].</span>",
		ignored_mobs = user,
	)

	to_chat(user, "<span class='notice'>You try to [isnull(carbon_source.internal) ? "open": "close"] the valve on [source]'s [item.name]...</span>")

	if(!do_mob(user, carbon_source, INTERNALS_TOGGLE_DELAY))
		return

	if(carbon_source.internal)
		carbon_source.internal = null

		// This isn't meant to be FALSE, it correlates to the icon's name.
		carbon_source.update_internals_hud_icon(0)
	else if (!QDELETED(item))
		if(hasmask_or_suit || carbon_source.getorganslot(ORGAN_SLOT_BREATHING_TUBE))
			carbon_source.internal = item
			carbon_source.update_internals_hud_icon(1)

	carbon_source.visible_message(
		"<span class='danger'>[user] [isnull(carbon_source.internal) ? "closes": "opens"] the valve on [source]'s [item.name].</span>",
		"<span class='userdanger'>[user] [isnull(carbon_source.internal) ? "closes": "opens"] the valve on your [item.name].</span>",
		ignored_mobs = user,
	)

	to_chat(user, "<span class='notice'>You [isnull(carbon_source.internal) ? "close" : "open"] the valve on [source]'s [item.name].</span>")

#undef INTERNALS_TOGGLE_DELAY
#undef POCKET_EQUIP_DELAY
